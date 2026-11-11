# SPDX-License-Identifier: GPL-3.0-or-later
"""
VELOCITY — V-SHIELD Security Architecture & Path Sanitizer
Zero-trust file path canonicalization, NTFS ADS stripping, and reserved device defense.
"""

import os
import re
from pathlib import Path
from typing import Tuple

WIN32_RESERVED_NAMES = {
    "CON", "PRN", "AUX", "NUL",
    "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9",
    "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9"
}

class VShieldSanitizer:
    @staticmethod
    def is_safe_filename(name: str) -> bool:
        if not name or len(name) > 255:
            return False
        
        # Check null bytes or control characters
        if any(ord(c) < 32 or ord(c) in (127, 0) for c in name):
            return False

        # Reject path separators in a pure filename
        if "/" in name or "\\" in name:
            return False

        # Check Win32 reserved device names
        base = name.split(".")[0].upper()
        if base in WIN32_RESERVED_NAMES:
            return False

        return True

    @staticmethod
    def strip_alternate_data_streams(path_str: str) -> str:
        """Strip NTFS Alternate Data Streams (e.g. filename.exe:stream:$DATA)."""
        # Split drive letter if present
        drive, rest = os.path.splitdrive(path_str)
        # Remove stream specifiers from path components
        parts = rest.replace("\\", "/").split("/")
        clean_parts = []
        for p in parts:
            if ":" in p:
                p = p.split(":")[0]
            clean_parts.append(p)
        clean_rest = "/".join(clean_parts)
        return (drive + clean_rest) if drive else clean_rest

    @classmethod
    def sanitize_path(cls, download_root: str, relative_path: str) -> Tuple[bool, str, str]:
        """
        Validates and canonicalizes an incoming torrent file path.
        Returns: (is_safe, sanitized_absolute_path, reason)
        """
        if not relative_path:
            return False, "", "Empty path provided."

        # Null byte injection check
        if "\x00" in relative_path:
            return False, "", "Path contains illegal null bytes."

        # Strip NTFS Alternate Data Streams
        cleaned = cls.strip_alternate_data_streams(relative_path)

        # Standardize separators
        cleaned = cleaned.replace("\\", "/")

        # Check for reserved Win32 device names in path segments
        segments = [s for s in cleaned.split("/") if s]
        for seg in segments:
            base_name = seg.split(".")[0].upper()
            if base_name in WIN32_RESERVED_NAMES:
                return False, "", f"Path component '{seg}' contains a Windows reserved device name."

        # Resolve absolute canonical paths
        root_abs = os.path.abspath(download_root)
        target_abs = os.path.abspath(os.path.join(root_abs, *segments))

        # Enforce destination jail (must start with download_root)
        try:
            rel = os.path.relpath(target_abs, root_abs)
            if rel.startswith("..") or os.path.isabs(rel):
                return False, "", "Path traversal attempt detected. Target escapes download root."
        except ValueError:
            return False, "", "Path traverses across different drive letters."

        return True, target_abs, "Path sanitized and verified within destination jail."
