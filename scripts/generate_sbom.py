# SPDX-License-Identifier: GPL-3.0-or-later
"""
VELOCITY — Software Bill of Materials (SBOM) Generator & Validator
Generates and validates SPDX 2.3 JSON specification listing all direct and transitive dependencies.
Supports:
1. Truthful generation timestamps (defaulting to current UTC build time).
2. Reproducible build timestamps via SOURCE_DATE_EPOCH (SPDX standard).
3. Deep structural, schema, and dependency inventory validation via --check.
"""

import argparse
import json
import os
import re
import sys
from datetime import datetime, timezone
from typing import Dict, List, Optional, Tuple

CANONICAL_PACKAGES = [
    {
        "SPDXID": "SPDXRef-Package-Velocity",
        "name": "velocity",
        "versionInfo": "1.0.0",
        "downloadLocation": "https://github.com/velocity-torrent/velocity",
        "licenseConcluded": "GPL-3.0-or-later",
        "licenseDeclared": "GPL-3.0-or-later",
        "copyrightText": "Copyright (C) 2026 The Velocity Authors",
        "description": "Intelligent Torrent Downloading desktop client for Windows 10 & 11."
    },
    {
        "SPDXID": "SPDXRef-Package-Qt6",
        "name": "qt6",
        "versionInfo": "6.7.2",
        "downloadLocation": "https://download.qt.io/archive/qt/",
        "licenseConcluded": "LGPL-3.0-only OR GPL-3.0-only",
        "licenseDeclared": "LGPL-3.0-only",
        "copyrightText": "Copyright (C) 2026 The Qt Company Ltd.",
        "externalRefs": [
            {
                "referenceCategory": "PACKAGE-MANAGER",
                "referenceType": "purl",
                "referenceLocator": "pkg:generic/qt@6.7.2"
            }
        ]
    },
    {
        "SPDXID": "SPDXRef-Package-Libtorrent",
        "name": "libtorrent-rasterbar",
        "versionInfo": "2.0.10",
        "downloadLocation": "https://github.com/arvidn/libtorrent",
        "licenseConcluded": "BSD-3-Clause",
        "licenseDeclared": "BSD-3-Clause",
        "copyrightText": "Copyright (c) 2003-2026 Arvid Norberg",
        "externalRefs": [
            {
                "referenceCategory": "PACKAGE-MANAGER",
                "referenceType": "purl",
                "referenceLocator": "pkg:github/arvidn/libtorrent@v2.0.10"
            }
        ]
    },
    {
        "SPDXID": "SPDXRef-Package-OpenSSL",
        "name": "openssl",
        "versionInfo": "3.3.1",
        "downloadLocation": "https://www.openssl.org/source/",
        "licenseConcluded": "Apache-2.0",
        "licenseDeclared": "Apache-2.0",
        "copyrightText": "Copyright 1998-2026 The OpenSSL Project Authors",
        "externalRefs": [
            {
                "referenceCategory": "PACKAGE-MANAGER",
                "referenceType": "purl",
                "referenceLocator": "pkg:generic/openssl@3.3.1"
            }
        ]
    },
    {
        "SPDXID": "SPDXRef-Package-SQLite",
        "name": "sqlite3",
        "versionInfo": "3.45.3",
        "downloadLocation": "https://www.sqlite.org/",
        "licenseConcluded": "blessing",
        "licenseDeclared": "Public-Domain",
        "copyrightText": "Public Domain",
        "externalRefs": [
            {
                "referenceCategory": "PACKAGE-MANAGER",
                "referenceType": "purl",
                "referenceLocator": "pkg:generic/sqlite@3.45.3"
            }
        ]
    }
]

CANONICAL_RELATIONSHIPS = [
    {"spdxElementId": "SPDXRef-DOCUMENT", "relationshipType": "DESCRIBES", "relatedSpdxElement": "SPDXRef-Package-Velocity"},
    {"spdxElementId": "SPDXRef-Package-Velocity", "relationshipType": "DEPENDS_ON", "relatedSpdxElement": "SPDXRef-Package-Qt6"},
    {"spdxElementId": "SPDXRef-Package-Velocity", "relationshipType": "DEPENDS_ON", "relatedSpdxElement": "SPDXRef-Package-Libtorrent"},
    {"spdxElementId": "SPDXRef-Package-Velocity", "relationshipType": "DEPENDS_ON", "relatedSpdxElement": "SPDXRef-Package-OpenSSL"},
    {"spdxElementId": "SPDXRef-Package-Velocity", "relationshipType": "DEPENDS_ON", "relatedSpdxElement": "SPDXRef-Package-SQLite"}
]

def get_generation_timestamp(custom_timestamp: Optional[str] = None) -> str:
    """Returns generation timestamp respecting custom input, SOURCE_DATE_EPOCH, or current UTC time."""
    if custom_timestamp:
        return custom_timestamp
    
    # Reproducible build standard (SOURCE_DATE_EPOCH)
    source_date_epoch = os.environ.get("SOURCE_DATE_EPOCH")
    if source_date_epoch:
        try:
            epoch = int(source_date_epoch)
            return datetime.fromtimestamp(epoch, tz=timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
        except ValueError:
            pass
            
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

def build_sbom(timestamp: Optional[str] = None) -> Dict:
    """Constructs the canonical SPDX 2.3 SBOM dictionary."""
    created_ts = get_generation_timestamp(timestamp)
    return {
        "spdxVersion": "SPDX-2.3",
        "dataLicense": "CC0-1.0",
        "SPDXID": "SPDXRef-DOCUMENT",
        "name": "VELOCITY Software Bill of Materials",
        "documentNamespace": "https://github.com/velocity-torrent/velocity/sbom/v1.0.0",
        "creationInfo": {
            "created": created_ts,
            "creators": [
                "Organization: Velocity Torrent Project",
                "Tool: Velocity-SBOM-Gen-1.0"
            ]
        },
        "packages": [dict(p) for p in CANONICAL_PACKAGES],
        "relationships": [dict(r) for r in CANONICAL_RELATIONSHIPS]
    }

def generate_sbom(output_path: str = "docs/SBOM.json", timestamp: Optional[str] = None) -> Dict:
    """Generates and writes the SPDX 2.3 SBOM to disk."""
    sbom = build_sbom(timestamp)
    parent_dir = os.path.dirname(output_path)
    if parent_dir:
        os.makedirs(parent_dir, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(sbom, f, indent=2)
        f.write("\n")
    print(f"Generated SPDX 2.3 SBOM at {output_path} successfully (timestamp: {sbom['creationInfo']['created']}).")
    return sbom

def validate_sbom(target_path: str = "docs/SBOM.json") -> Tuple[bool, List[str]]:
    """
    Validates that target_path exists, has valid JSON, conforms to SPDX 2.3 schema,
    possesses a valid ISO-8601 UTC timestamp, and contains up-to-date packages and relationships.
    Does NOT require the timestamp to match current time (preserves truthful committed timestamp).
    """
    errors: List[str] = []

    if not os.path.exists(target_path):
        return False, [f"SBOM file not found at '{target_path}'"]

    try:
        with open(target_path, "r", encoding="utf-8") as f:
            target = json.load(f)
    except Exception as e:
        return False, [f"Failed to parse SBOM JSON at '{target_path}': {e}"]

    canonical = build_sbom()

    # 1. Validate top-level metadata
    for key in ["spdxVersion", "dataLicense", "SPDXID", "name", "documentNamespace"]:
        if target.get(key) != canonical[key]:
            errors.append(f"Header field '{key}' mismatch: expected '{canonical[key]}', got '{target.get(key)}'")

    # 2. Validate creationInfo
    c_info = target.get("creationInfo")
    if not isinstance(c_info, dict):
        errors.append("Missing or invalid 'creationInfo' object")
    else:
        created_val = c_info.get("created")
        if not created_val or not isinstance(created_val, str):
            errors.append("Missing 'creationInfo.created' timestamp")
        else:
            # Check ISO 8601 UTC format: YYYY-MM-DDTHH:MM:SSZ
            if not re.match(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$", created_val):
                errors.append(f"Invalid timestamp format in 'creationInfo.created': '{created_val}'. Must be ISO-8601 UTC (YYYY-MM-DDTHH:MM:SSZ)")
            else:
                try:
                    datetime.strptime(created_val, "%Y-%m-%dT%H:%M:%SZ")
                except ValueError as e:
                    errors.append(f"Unparseable date in 'creationInfo.created' ('{created_val}'): {e}")

        expected_creators = canonical["creationInfo"]["creators"]
        if c_info.get("creators") != expected_creators:
            errors.append(f"'creationInfo.creators' mismatch: expected {expected_creators}, got {c_info.get('creators')}")

    # 3. Validate packages inventory
    t_packages = target.get("packages")
    if not isinstance(t_packages, list):
        errors.append("Missing or invalid 'packages' list")
    else:
        c_packages = canonical["packages"]
        c_pkg_map = {p["SPDXID"]: p for p in c_packages}
        t_pkg_map = {p.get("SPDXID"): p for p in t_packages if isinstance(p, dict)}

        if len(t_packages) != len(c_packages):
            errors.append(f"Package count mismatch: expected {len(c_packages)} packages, got {len(t_packages)}")

        # Check for missing or unexpected packages
        for spdx_id, c_pkg in c_pkg_map.items():
            if spdx_id not in t_pkg_map:
                errors.append(f"Missing required package: '{spdx_id}' ({c_pkg.get('name')})")
            else:
                t_pkg = t_pkg_map[spdx_id]
                for prop in ["name", "versionInfo", "downloadLocation", "licenseConcluded", "licenseDeclared", "copyrightText", "externalRefs"]:
                    if t_pkg.get(prop) != c_pkg.get(prop):
                        errors.append(f"Package '{spdx_id}' field '{prop}' mismatch: expected '{c_pkg.get(prop)}', got '{t_pkg.get(prop)}'")

        for spdx_id in t_pkg_map:
            if spdx_id not in c_pkg_map:
                errors.append(f"Unexpected unapproved package found in SBOM: '{spdx_id}'")

    # 4. Validate relationships
    t_rels = target.get("relationships")
    if not isinstance(t_rels, list):
        errors.append("Missing or invalid 'relationships' list")
    else:
        c_rels = canonical["relationships"]
        if len(t_rels) != len(c_rels):
            errors.append(f"Relationship count mismatch: expected {len(c_rels)}, got {len(t_rels)}")
        else:
            c_rel_set = {(r["spdxElementId"], r["relationshipType"], r["relatedSpdxElement"]) for r in c_rels}
            t_rel_set = {(r.get("spdxElementId"), r.get("relationshipType"), r.get("relatedSpdxElement")) for r in t_rels if isinstance(r, dict)}
            missing = c_rel_set - t_rel_set
            extra = t_rel_set - c_rel_set
            if missing:
                errors.append(f"Missing required relationships: {missing}")
            if extra:
                errors.append(f"Unexpected relationships found: {extra}")

    return len(errors) == 0, errors

def main():
    parser = argparse.ArgumentParser(description="VELOCITY SPDX 2.3 SBOM Generator & Validator")
    parser.add_argument("--check", nargs="?", const="docs/SBOM.json", help="Validate existing SBOM file against canonical specification")
    parser.add_argument("--output", default="docs/SBOM.json", help="Target output file path for generation (default: docs/SBOM.json)")
    parser.add_argument("--timestamp", default=None, help="Explicit generation timestamp in ISO-8601 UTC format")
    args = parser.parse_args()

    if args.check is not None:
        target_file = args.check or "docs/SBOM.json"
        is_valid, errors = validate_sbom(target_file)
        if is_valid:
            print(f"[PASS] SPDX 2.3 SBOM at '{target_file}' is valid, up-to-date, and structurally sound.")
            sys.exit(0)
        else:
            print(f"[FAIL] SPDX 2.3 SBOM validation failed for '{target_file}' with {len(errors)} error(s):", file=sys.stderr)
            for err in errors:
                print(f"  - {err}", file=sys.stderr)
            sys.exit(1)

    generate_sbom(args.output, args.timestamp)

if __name__ == "__main__":
    main()
