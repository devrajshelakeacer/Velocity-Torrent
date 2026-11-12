#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-or-later
"""
VELOCITY — Production Release Packaging Engine
Builds the minimal, clean, user-facing portable release package.
Strictly bundles only application runtime code, UI assets, launchers, and legal notices.
Excludes tests, agent prompts, internal docs, development scripts, and caches.
"""

import os
import sys
import argparse
import zipfile
import fnmatch

# Root directory of the repository
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Explicit runtime files and directories to include
RUNTIME_INCLUDES = [
    # Application code & engines
    "backend",
    "web",
    "ui",
    # Launchers & configurations
    "Launch-Velocity.bat",
    "Launch-Velocity.vbs",
    "launch.sh",
    "run_app.py",
    "requirements.txt",
    "qtquickcontrols2.conf",
    # Licenses, security policies, and user documentation
    "LICENSE",
    "README.md",
    "SECURITY.md",
    "PRIVACY.md",
]

# Patterns that MUST NEVER be bundled into a release package
FORBIDDEN_PATTERNS = [
    "tests*",
    "scripts*",
    "docs*",
    "AGENTS.md",
    ".github*",
    ".git*",
    ".planning*",
    ".venv*",
    "*__pycache__*",
    "*.py[cod]",
    "*.log",
    "*.dmp",
    "*.tmp",
    "PRD.md",
    "progress.txt",
]

def is_forbidden(rel_path: str) -> bool:
    normalized = rel_path.replace("\\", "/")
    parts = normalized.split("/")
    for pattern in FORBIDDEN_PATTERNS:
        if fnmatch.fnmatch(normalized, pattern):
            return True
        for part in parts:
            if fnmatch.fnmatch(part, pattern):
                return True
    return False

def collect_release_files(root_dir: str):
    """Gathers all files that belong to the production release artifact."""
    files_to_pack = []
    
    for item in RUNTIME_INCLUDES:
        full_path = os.path.join(root_dir, item)
        if not os.path.exists(full_path):
            raise FileNotFoundError(f"Required release runtime component missing: {item}")
        
        if os.path.isfile(full_path):
            rel = os.path.relpath(full_path, root_dir).replace("\\", "/")
            if not is_forbidden(rel):
                files_to_pack.append((full_path, rel))
        elif os.path.isdir(full_path):
            for dirpath, _, filenames in os.walk(full_path):
                for fname in sorted(filenames):
                    fpath = os.path.join(dirpath, fname)
                    rel = os.path.relpath(fpath, root_dir).replace("\\", "/")
                    if not is_forbidden(rel):
                        files_to_pack.append((fpath, rel))

    return sorted(files_to_pack, key=lambda x: x[1])

def verify_package_contents(zip_path: str):
    """Audits the generated zip archive to guarantee 100% compliance with release rules."""
    with zipfile.ZipFile(zip_path, "r") as zf:
        namelist = zf.namelist()
        
        # Check required files
        essential_files = [
            "backend/app.py",
            "backend/engine.py",
            "web/index.html",
            "requirements.txt",
            "Launch-Velocity.bat",
            "LICENSE",
            "README.md"
        ]
        for req in essential_files:
            if req not in namelist:
                raise ValueError(f"Package verification failed: missing essential file '{req}'")

        # Check forbidden files
        for name in namelist:
            if is_forbidden(name):
                raise ValueError(f"Package verification failed: forbidden item found in release: '{name}'")

    return len(namelist)

def create_release_package(output_zip: str, verbose: bool = False):
    output_path = os.path.abspath(output_zip)
    files = collect_release_files(REPO_ROOT)
    
    print(f"[*] Packaging {len(files)} runtime files into: {output_path}")
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    total_uncompressed = 0
    with zipfile.ZipFile(output_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for fpath, rel in files:
            total_uncompressed += os.path.getsize(fpath)
            if verbose:
                print(f"  + {rel}")
            zf.write(fpath, arcname=rel)

    total_compressed = os.path.getsize(output_path)
    ratio = (1.0 - (total_compressed / total_uncompressed)) * 100.0 if total_uncompressed > 0 else 0.0

    # Audit the package
    verified_count = verify_package_contents(output_path)

    print("========================================================")
    print("  VELOCITY Release Package Created & Verified Successfully")
    print("========================================================")
    print(f"  Target Archive:      {output_path}")
    print(f"  Packaged Files:      {verified_count}")
    print(f"  Uncompressed Size:   {total_uncompressed / (1024 * 1024):.2f} MB")
    print(f"  Compressed Size:     {total_compressed / (1024 * 1024):.2f} MB ({ratio:.1f}% ratio)")
    print("  Sanitization Status: PASSED (Zero dev tests, docs, or agent prompts included)")
    print("========================================================")
    return output_path

def main():
    parser = argparse.ArgumentParser(description="VELOCITY Release Packaging Engine")
    parser.add_argument("--output", "-o", default=os.path.join(REPO_ROOT, "Velocity-Portable-x64.zip"),
                        help="Destination path for the zip package")
    parser.add_argument("--check", action="store_true",
                        help="Validate runtime file manifest without generating zip")
    parser.add_argument("--verbose", "-v", action="store_true",
                        help="Print all files included in the package")
    args = parser.parse_args()

    if args.check:
        files = collect_release_files(REPO_ROOT)
        print(f"[OK] Release manifest valid: {len(files)} runtime files identified.")
        for _, rel in files:
            assert not is_forbidden(rel), f"Forbidden file in manifest: {rel}"
        sys.exit(0)

    create_release_package(args.output, verbose=args.verbose)

if __name__ == "__main__":
    main()
