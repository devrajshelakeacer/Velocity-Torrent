// SPDX-License-Identifier: GPL-3.0-or-later
#include "engine/VForceController.hpp"
#include <cassert>
#include <iostream>

void runVForceControllerTests() {
    std::cout << "[TEST] Running V-FORCE Controller & Thermal Guardian Test Suite...\n";
    velocity::engine::VForceController controller;

    // Test 1: Profile Memory Cache Limits
    {
        controller.setProfile(velocity::core::PerformanceProfile::Balanced);
        assert(controller.getConfiguration().maxDiskCacheMB == 128);

        controller.setProfile(velocity::core::PerformanceProfile::Turbo);
        assert(controller.getConfiguration().maxDiskCacheMB == 512);

        controller.setProfile(velocity::core::PerformanceProfile::VForceMax);
        assert(controller.getConfiguration().maxDiskCacheMB == 1536); // 1.5 GB
        std::cout << "  ✓ Test 1 Passed: Profile memory cache limits strictly bounded.\n";
    }

    // Test 2: Direct Piece Coalescing Cache (SSD WAF Reduction)
    {
        auto& guardian = controller.getThermalGuardian();
        // 16KB write gives 0% reduction
        assert(guardian.calculateWriteAmplificationReduction(16384) == 0.0);
        // 16MB contiguous commit yields ~90% reduction
        double reduction = guardian.calculateWriteAmplificationReduction(16 * 1024 * 1024);
        assert(reduction >= 88.0 && reduction <= 92.5);
        std::cout << "  ✓ Test 2 Passed: Direct Piece Coalescing cuts SSD write amplification by " << reduction << "%.\n";
    }

    // Test 3: USER DIRECTIVE VERIFICATION:
    // When CPU reaches 85°C (Elevated Warning), V-FORCE MAX is NOT automatically downgraded!
    {
        controller.setProfile(velocity::core::PerformanceProfile::VForceMax);
        controller.updateThermalSample(85.5f); // 85.5°C

        // Thermal state is ElevatedWarning
        assert(controller.getThermalGuardian().isElevatedWarning());
        assert(!controller.getThermalGuardian().isCriticalPeakDanger());

        // CRITICAL CHECK: Active profile remains VForceMax! (User retains total control)
        assert(controller.getProfile() == velocity::core::PerformanceProfile::VForceMax);
        std::cout << "  ✓ Test 3 Passed: At 85.5°C, fast download continues; NO auto-downgrade to Balanced.\n";
    }

    // Test 4: Critical Peak Danger (>= 95°C)
    {
        controller.updateThermalSample(96.0f); // 96.0°C
        assert(controller.getThermalGuardian().isCriticalPeakDanger());
        std::cout << "  ✓ Test 4 Passed: At 96.0°C, Critical Peak Danger alert is engaged.\n";
    }

    std::cout << "[PASS] All V-FORCE Controller & Thermal Guardian Tests Passed Cleanly.\n\n";
}
