# SPDX-License-Identifier: GPL-3.0-or-later
"""
VELOCITY — SPDX 2.3 SBOM Integrity & Generator Verification Suite
Validates:
1. Committed docs/SBOM.json structural, schema, and dependency integrity.
2. Truthful timestamp generation and ISO-8601 UTC compliance.
3. Deterministic repeat-generation when SOURCE_DATE_EPOCH is set.
4. Robust detection of stale package versions, missing dependencies, and corrupted JSON.
"""

import json
import os
import sys
import tempfile
from typing import Dict

# Ensure project root is on sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from scripts.generate_sbom import (
    build_sbom,
    generate_sbom,
    validate_sbom,
    CANONICAL_PACKAGES,
    CANONICAL_RELATIONSHIPS
)

def test_committed_sbom_validity():
    print("[TEST] Validating committed docs/SBOM.json integrity...")
    is_valid, errors = validate_sbom("docs/SBOM.json")
    assert is_valid, f"Committed docs/SBOM.json must be valid! Errors: {errors}"
    print("  [PASS] Committed docs/SBOM.json passed all structural & dependency checks.")

def test_generation_truthful_timestamp():
    print("[TEST] Verifying generation produces valid SPDX 2.3 with truthful timestamp...")
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_sbom = os.path.join(tmpdir, "test_sbom.json")
        data = generate_sbom(tmp_sbom)
        assert os.path.exists(tmp_sbom)
        assert data["creationInfo"]["created"].endswith("Z")
        is_valid, errors = validate_sbom(tmp_sbom)
        assert is_valid, f"Generated SBOM must be valid! Errors: {errors}"
    print("  [PASS] Generation with truthful timestamp verified.")

def test_deterministic_generation_source_date_epoch():
    print("[TEST] Verifying deterministic repeat generation with SOURCE_DATE_EPOCH...")
    os.environ["SOURCE_DATE_EPOCH"] = "1700000000"
    try:
        with tempfile.TemporaryDirectory() as tmpdir:
            file1 = os.path.join(tmpdir, "sbom1.json")
            file2 = os.path.join(tmpdir, "sbom2.json")
            generate_sbom(file1)
            generate_sbom(file2)
            with open(file1, "rb") as f1, open(file2, "rb") as f2:
                content1 = f1.read()
                content2 = f2.read()
            assert content1 == content2, "Deterministic generation must produce identical files!"
            assert b"2023-11-14T22:13:20Z" in content1
    finally:
        os.environ.pop("SOURCE_DATE_EPOCH", None)
    print("  [PASS] Deterministic repeat generation verified with SOURCE_DATE_EPOCH.")

def test_validation_catches_stale_package_version():
    print("[TEST] Verifying validator catches stale package versions...")
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_sbom = os.path.join(tmpdir, "stale_version.json")
        data = build_sbom("2026-11-12T00:00:00Z")
        # Tamper with libtorrent version
        for pkg in data["packages"]:
            if pkg["name"] == "libtorrent-rasterbar":
                pkg["versionInfo"] = "1.2.19" # Stale version
        with open(tmp_sbom, "w", encoding="utf-8") as f:
            json.dump(data, f)
        is_valid, errors = validate_sbom(tmp_sbom)
        assert not is_valid, "Validator must reject stale package version!"
        assert any("libtorrent-rasterbar" in err or "versionInfo" in err for err in errors)
    print("  [PASS] Stale package version successfully detected and rejected.")

def test_validation_catches_missing_package():
    print("[TEST] Verifying validator catches missing packages...")
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_sbom = os.path.join(tmpdir, "missing_pkg.json")
        data = build_sbom("2026-11-12T00:00:00Z")
        # Remove sqlite3
        data["packages"] = [p for p in data["packages"] if p["name"] != "sqlite3"]
        with open(tmp_sbom, "w", encoding="utf-8") as f:
            json.dump(data, f)
        is_valid, errors = validate_sbom(tmp_sbom)
        assert not is_valid, "Validator must reject missing package!"
        assert any("sqlite3" in err or "Package count mismatch" in err for err in errors)
    print("  [PASS] Missing package successfully detected and rejected.")

def test_validation_catches_malformed_json():
    print("[TEST] Verifying validator catches corrupted JSON...")
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_sbom = os.path.join(tmpdir, "corrupt.json")
        with open(tmp_sbom, "w", encoding="utf-8") as f:
            f.write("{ invalid json")
        is_valid, errors = validate_sbom(tmp_sbom)
        assert not is_valid, "Validator must reject malformed JSON!"
        assert any("Failed to parse" in err for err in errors)
    print("  [PASS] Malformed JSON successfully detected and rejected.")

def test_validation_catches_invalid_timestamp_format():
    print("[TEST] Verifying validator catches invalid timestamp formats...")
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_sbom = os.path.join(tmpdir, "bad_ts.json")
        data = build_sbom("not-a-valid-timestamp")
        with open(tmp_sbom, "w", encoding="utf-8") as f:
            json.dump(data, f)
        is_valid, errors = validate_sbom(tmp_sbom)
        assert not is_valid, "Validator must reject invalid timestamp format!"
        assert any("Invalid timestamp format" in err for err in errors)
    print("  [PASS] Invalid timestamp format successfully detected and rejected.")

def test_validation_catches_missing_relationship():
    print("[TEST] Verifying validator catches missing relationships...")
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_sbom = os.path.join(tmpdir, "missing_rel.json")
        data = build_sbom("2026-11-12T00:00:00Z")
        data["relationships"] = data["relationships"][:-1] # Drop last relationship
        with open(tmp_sbom, "w", encoding="utf-8") as f:
            json.dump(data, f)
        is_valid, errors = validate_sbom(tmp_sbom)
        assert not is_valid, "Validator must reject missing relationship!"
        assert any("Relationship count mismatch" in err or "Missing required relationships" in err for err in errors)
    print("  [PASS] Missing relationship successfully detected and rejected.")

def run_all_sbom_tests():
    print("========================================================")
    print("  VELOCITY SPDX 2.3 SBOM Verification Suite             ")
    print("========================================================\n")
    test_committed_sbom_validity()
    test_generation_truthful_timestamp()
    test_deterministic_generation_source_date_epoch()
    test_validation_catches_stale_package_version()
    test_validation_catches_missing_package()
    test_validation_catches_malformed_json()
    test_validation_catches_invalid_timestamp_format()
    test_validation_catches_missing_relationship()
    print("\n========================================================")
    print("  SBOM VERDICT: 100% OF SBOM TESTS PASSED               ")
    print("========================================================")

if __name__ == "__main__":
    run_all_sbom_tests()
