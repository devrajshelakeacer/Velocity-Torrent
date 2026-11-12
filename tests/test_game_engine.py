# SPDX-License-Identifier: GPL-3.0-or-later
"""
VELOCITY — Large PC Game Engine Specialization Test Suite
Validates repack classification, non-destructive user guidance guarantees,
disk space warden, checksum auditor, and gaming QoS telemetry.
"""

import os
import sys
import tempfile
import zlib
import hashlib
import unittest

sys.path.insert(0, os.path.abspath("."))

from backend.game_engine import GameRepackClassifier, DiskSpaceWarden, ChecksumAuditor

class TestGameEngine(unittest.TestCase):
    def test_repack_classification_and_guidance(self):
        sample_files = [
            {"index": 0, "name": "setup.exe", "size": 45 * 1024 * 1024},
            {"index": 1, "name": "data1.bin", "size": 25 * 1024 * 1024 * 1024},
            {"index": 2, "name": "data2.bin", "size": 20 * 1024 * 1024 * 1024},
            {"index": 3, "name": "selective-english.bin", "size": 4 * 1024 * 1024 * 1024},
            {"index": 4, "name": "selective-french.bin", "size": 18 * 1024 * 1024 * 1024},
            {"index": 5, "name": "selective-german.bin", "size": 16 * 1024 * 1024 * 1024},
            {"index": 6, "name": "optional-4k-textures.bin", "size": 12 * 1024 * 1024 * 1024},
            {"index": 7, "name": "QuickSFV.exe", "size": 1 * 1024 * 1024},
            {"index": 8, "name": "checksums.sfv", "size": 512}
        ]

        analysis = GameRepackClassifier.analyze_torrent(sample_files)
        self.assertTrue(analysis["is_game_repack"])
        self.assertEqual(analysis["optional_files_count"], 3) # french, german, 4k
        self.assertTrue(analysis["has_installer"])
        self.assertTrue(analysis["has_checksum"])

        # Check total vs recommended sizes
        total_gb = analysis["total_size"] / (1024 * 1024 * 1024)
        opt_gb = analysis["optional_size"] / (1024 * 1024 * 1024)
        rec_gb = analysis["recommended_size"] / (1024 * 1024 * 1024)
        self.assertAlmostEqual(total_gb, 95.04, delta=0.5)
        self.assertAlmostEqual(opt_gb, 46.0, delta=0.5)
        self.assertAlmostEqual(rec_gb, 49.04, delta=0.5)

        # CRITICAL USER AUTONOMY RULE: All files must default to is_included: True
        for f in analysis["files"]:
            self.assertTrue(f["is_included"], f"File {f['name']} was not included by default!")

        # Verify explicit guidance for optional non-English voice pack
        french_file = next(f for f in analysis["files"] if "french" in f["name"])
        self.assertTrue(french_file["is_optional"])
        self.assertTrue(french_file["recommended_skip"])
        self.assertIn("Yes, the game will run 100% smoothly in English without this file", french_file["guidance"])

        # Verify base game cannot be skipped
        base_file = next(f for f in analysis["files"] if f["name"] == "data1.bin")
        self.assertFalse(base_file["is_optional"])
        self.assertFalse(base_file["recommended_skip"])

    def test_disk_space_warden(self):
        # Test valid directory with small requirement (should pass)
        res = DiskSpaceWarden.check_space("downloads", required_bytes=1000)
        self.assertTrue(res["success"])
        self.assertTrue(res["is_sufficient"])
        self.assertFalse(res["is_critical"])

        # Test unrealistic 1000 TB requirement (should flag insufficient)
        res_huge = DiskSpaceWarden.check_space("downloads", required_bytes=1000 * 1024 * 1024 * 1024 * 1024)
        self.assertTrue(res_huge["success"])
        self.assertFalse(res_huge["is_sufficient"])
        self.assertTrue(res_huge["is_critical"])
        self.assertIn("requires", res_huge["message"])

    def test_checksum_auditor(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            # Create a mock game data archive
            archive_path = os.path.join(temp_dir, "data1.bin")
            test_content = b"VELOCITY_INTEGRITY_GAME_ARCHIVE_DATA_BLOCKS" * 100
            with open(archive_path, "wb") as f:
                f.write(test_content)

            # Compute CRC32
            actual_crc = f"{zlib.crc32(test_content) & 0xFFFFFFFF:08X}"

            # Write SFV file
            sfv_path = os.path.join(temp_dir, "checksums.sfv")
            with open(sfv_path, "w") as f:
                f.write(f"; SFV created by QuickSFV\ndata1.bin {actual_crc}\n")

            # Audit directory
            report = ChecksumAuditor.audit_directory(temp_dir)
            self.assertTrue(report["success"])
            self.assertEqual(report["total_checked"], 1)
            self.assertEqual(report["verified_count"], 1)
            self.assertEqual(report["corrupted_count"], 0)
            self.assertTrue(report["is_clean"])
            self.assertIn("100% authentic", report["message"])

if __name__ == "__main__":
    unittest.main()
