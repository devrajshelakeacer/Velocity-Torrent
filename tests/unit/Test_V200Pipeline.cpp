// SPDX-License-Identifier: GPL-3.0-or-later
#include "engine/V200Pipeline.hpp"
#include <cassert>
#include <iostream>

void runV200PipelineTests() {
    std::cout << "[TEST] Running V200 Broadband Pipeline Test Suite...\n";
    velocity::engine::V200Pipeline pipeline;

    // Test 1: Optimal 200 Mbps Line Saturation (23.4 MB/s)
    {
        auto diag = pipeline.analyzePipeline(
            23400000LL, // 23.4 MB/s
            28.0, 35, 30, 40.0, 25.0, 5.0, 88.0
        );
        assert(diag.primaryBottleneck == velocity::core::BottleneckCause::V200LineSaturatedOptimal);
        assert(diag.lineEfficiencyPercent >= 93.0);
        std::cout << "  ✓ Test 1 Passed: 23.4 MB/s correctly identified as Optimal Line Saturation (" << diag.lineEfficiencyPercent << "%).\n";
    }

    // Test 2: Storage Write Bottleneck (High Disk Latency > 25ms)
    {
        auto diag = pipeline.analyzePipeline(
            12000000LL, // 12 MB/s
            30.0, 35, 30, 40.0, 20.0, 35.0, 40.0 // Disk write latency: 35ms!
        );
        assert(diag.primaryBottleneck == velocity::core::BottleneckCause::DiskStorageBottleneck);
        std::cout << "  ✓ Test 2 Passed: Disk write bottleneck correctly isolated.\n";
    }

    // Test 3: CPU Cryptographic Verification Bottleneck (> 92% load)
    {
        auto diag = pipeline.analyzePipeline(
            14000000LL,
            30.0, 35, 30, 40.0, 96.0, 5.0, 80.0 // CPU Load: 96%
        );
        assert(diag.primaryBottleneck == velocity::core::BottleneckCause::CpuHashVerificationBound);
        std::cout << "  ✓ Test 3 Passed: CPU hashing bottleneck correctly isolated.\n";
    }

    // Test 4: Swarm Seed Capacity Constrained (< 18 MB/s)
    {
        auto diag = pipeline.analyzePipeline(
            4500000LL,
            6.5, // Total swarm capacity is only 6.5 MB/s
            40, 35, 20.0, 10.0, 3.0, 50.0
        );
        assert(diag.primaryBottleneck == velocity::core::BottleneckCause::SwarmCapacityConstrained);
        std::cout << "  ✓ Test 4 Passed: Swarm capacity constraint correctly attributed.\n";
    }

    std::cout << "[PASS] All V200 Pipeline Tests Passed Cleanly.\n\n";
}
