# SPDX-License-Identifier: GPL-3.0-or-later
"""
VELOCITY — Production Release Package Verification Suite
Tests scripts/package_release.py to ensure that:
1. All essential runtime code, assets, and launchers are packaged.
2. All non-runtime development materials (tests, agent prompts, dev scripts, internal docs) are strictly excluded.
3. Legal notices (LICENSE, README.md, PRIVACY.md, SECURITY.md) are preserved.
"""

import os
import sys
import tempfile
import zipfile

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if REPO_ROOT not in sys.path:
    sys.path.insert(0, REPO_ROOT)

from scripts.package_release import (
    collect_release_files,
    create_release_package,
    verify_package_contents,
    is_forbidden,
    FORBIDDEN_PATTERNS
)

def test_manifest_inclusion():
    print("[TEST] Verifying release package runtime manifest inclusions...")
    files = collect_release_files(REPO_ROOT)
    rel_names = {rel for _, rel in files}
    
    expected_essentials = [
        "backend/app.py",
        "backend/engine.py",
        "backend/game_engine.py",
        "backend/sanitizer.py",
        "backend/telemetry.py",
        "web/index.html",
        "web/landing.html",
        "web/js/app.js",
        "web/css/geist.css",
        "Launch-Velocity.bat",
        "Launch-Velocity.vbs",
        "launch.sh",
        "run_app.py",
        "requirements.txt",
        "qtquickcontrols2.conf",
        "LICENSE",
        "README.md",
        "SECURITY.md",
        "PRIVACY.md"
    ]
    
    for item in expected_essentials:
        assert item in rel_names, f"Missing essential runtime item in package manifest: {item}"
        
    print(f"  [PASS] All {len(expected_essentials)} essential runtime files present in manifest.")

def test_manifest_exclusion():
    print("[TEST] Verifying strict exclusion of non-runtime development files...")
    files = collect_release_files(REPO_ROOT)
    rel_names = {rel for _, rel in files}
    
    # Assert nothing forbidden made it into the manifest
    for name in rel_names:
        assert not is_forbidden(name), f"Forbidden file found in release manifest: {name}"
        assert not name.startswith("tests/"), f"Test file leaked into manifest: {name}"
        assert not name.startswith("scripts/"), f"Script file leaked into manifest: {name}"
        assert not name.startswith("docs/"), f"Internal doc leaked into manifest: {name}"
        assert name != "AGENTS.md", "AGENTS.md must never be bundled into release!"
        
    print("  [PASS] Strict exclusion verified. Zero tests, agent prompts, or dev scripts in manifest.")

def test_live_package_creation_and_audit():
    print("[TEST] Building and verifying live release zip artifact...")
    with tempfile.TemporaryDirectory() as tmpdir:
        test_zip = os.path.join(tmpdir, "Velocity-Test-Release.zip")
        create_release_package(test_zip, verbose=False)
        
        assert os.path.exists(test_zip), "Failed to generate release zip archive."
        assert os.path.getsize(test_zip) > 10000, "Release zip archive suspiciously small."
        
        # Verify zip structure
        with zipfile.ZipFile(test_zip, "r") as zf:
            namelist = zf.namelist()
            assert "backend/app.py" in namelist
            assert "web/index.html" in namelist
            assert "Launch-Velocity.bat" in namelist
            assert "LICENSE" in namelist
            
            # Verify no dev clutter in zip
            for name in namelist:
                assert not name.startswith("tests/"), f"Forbidden in zip: {name}"
                assert not name.startswith("scripts/"), f"Forbidden in zip: {name}"
                assert not name.startswith("docs/"), f"Forbidden in zip: {name}"
                assert name != "AGENTS.md", f"Forbidden in zip: {name}"
                assert "__pycache__" not in name, f"Forbidden cache in zip: {name}"

        # Audit function verification
        verified_count = verify_package_contents(test_zip)
        assert verified_count > 0
        print(f"  [PASS] Live archive verified cleanly ({verified_count} files).")

def test_audit_catches_violations():
    print("[TEST] Verifying package auditor catches forbidden injections...")
    with tempfile.TemporaryDirectory() as tmpdir:
        bad_zip = os.path.join(tmpdir, "bad.zip")
        with zipfile.ZipFile(bad_zip, "w") as zf:
            zf.writestr("backend/app.py", "# code")
            zf.writestr("backend/engine.py", "# code")
            zf.writestr("web/index.html", "<html></html>")
            zf.writestr("requirements.txt", "fastapi")
            zf.writestr("Launch-Velocity.bat", "@echo off")
            zf.writestr("LICENSE", "GPL")
            zf.writestr("README.md", "Docs")
            # Inject forbidden file
            zf.writestr("AGENTS.md", "Agent instructions")
            
        caught = False
        try:
            verify_package_contents(bad_zip)
        except ValueError as e:
            if "forbidden item found in release" in str(e):
                caught = True
        assert caught, "Auditor failed to catch AGENTS.md injection!"
        print("  [PASS] Packaging auditor successfully caught and rejected forbidden injection.")

def run_all_package_tests():
    print("\n========================================================")
    print("  VELOCITY Production Release Packaging Test Suite     ")
    print("========================================================")
    test_manifest_inclusion()
    test_manifest_exclusion()
    test_live_package_creation_and_audit()
    test_audit_catches_violations()
    print("========================================================")
    print("  PACKAGE VERDICT: 100% OF PACKAGING TESTS PASSED       ")
    print("========================================================")

if __name__ == "__main__":
    run_all_package_tests()
