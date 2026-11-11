// SPDX-License-Identifier: GPL-3.0-or-later
#include <iostream>

void runVShieldSanitizerTests();
void runPeerScorerTests();
void runV200PipelineTests();
void runVForceControllerTests();

int main() {
    std::cout << "========================================================\n";
    std::cout << "  VELOCITY Test Suite Runner — Verification & Integrity \n";
    std::cout << "========================================================\n\n";

    try {
        runVShieldSanitizerTests();
        runPeerScorerTests();
        runV200PipelineTests();
        runVForceControllerTests();

        std::cout << "========================================================\n";
        std::cout << "  SUMMARY: 100% OF TESTS PASSED WITH ZERO DEFECTS       \n";
        std::cout << "========================================================\n";
        return 0;
    } catch (const std::exception& ex) {
        std::cerr << "[FATAL] Test failed with exception: " << ex.what() << "\n";
        return 1;
    }
}
