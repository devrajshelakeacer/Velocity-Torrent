// SPDX-License-Identifier: GPL-3.0-or-later
#include "security/VShieldSanitizer.hpp"
#include <cassert>
#include <iostream>

void runVShieldSanitizerTests() {
    std::cout << "[TEST] Running VShieldSanitizer Security Test Suite...\n";
    velocity::security::VShieldSanitizer sanitizer;
    std::filesystem::path root("D:/Downloads");

    // Test 1: Standard Safe File
    {
        auto res = sanitizer.sanitizePath(root, "ubuntu.iso");
        assert(res.status == velocity::security::SanitizeResult::Safe);
        assert(res.safePath == (root / "ubuntu.iso"));
        std::cout << "  ✓ Test 1 Passed: Safe filename accepted.\n";
    }

    // Test 2: Path Traversal Attempt with ".."
    {
        auto res = sanitizer.sanitizePath(root, "../../../Windows/System32/cmd.exe");
        assert(res.status == velocity::security::SanitizeResult::RejectedPathTraversal);
        // Ensure destination does NOT contain ".."
        std::string str = res.safePath.string();
        assert(str.find("..") == std::string::npos);
        std::cout << "  ✓ Test 2 Passed: Directory traversal attack blocked.\n";
    }

    // Test 3: NTFS Alternate Data Stream Attempt
    {
        auto res = sanitizer.sanitizePath(root, "file.txt::$DATA");
        assert(res.status == velocity::security::SanitizeResult::RejectedAlternateDataStream);
        assert(res.safePath.string().find(':') == std::string::npos || res.safePath.string().find("D:") == 0);
        std::cout << "  ✓ Test 3 Passed: NTFS Alternate Data Stream blocked.\n";
    }

    // Test 4: Reserved Win32 Device Names (CON, AUX, NUL, COM1)
    {
        assert(sanitizer.isReservedDeviceName("CON"));
        assert(sanitizer.isReservedDeviceName("con.txt"));
        assert(sanitizer.isReservedDeviceName("AUX"));
        assert(sanitizer.isReservedDeviceName("nul.dat"));
        assert(sanitizer.isReservedDeviceName("COM1"));
        assert(!sanitizer.isReservedDeviceName("normal_file.iso"));

        auto res = sanitizer.sanitizePath(root, "CON.txt");
        assert(res.status == velocity::security::SanitizeResult::Sanitized);
        assert(res.safePath.filename().string() == "_CON.txt");
        std::cout << "  ✓ Test 4 Passed: Reserved Win32 device name neutralized.\n";
    }

    // Test 5: Illegal Win32 Characters Sanitized
    {
        std::string illegal = "my<bad>file:name?.iso";
        std::string clean = velocity::security::VShieldSanitizer::sanitizeComponent(illegal);
        assert(clean == "my_bad_file_name_.iso");
        std::cout << "  ✓ Test 5 Passed: Illegal Win32 characters replaced with safe underscores.\n";
    }

    std::cout << "[PASS] All VShieldSanitizer Tests Passed Cleanly.\n\n";
}
