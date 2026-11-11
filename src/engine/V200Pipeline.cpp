// SPDX-License-Identifier: GPL-3.0-or-later
#include "V200Pipeline.hpp"
#include <algorithm>
#include <cmath>

namespace velocity::engine {

core::V200Diagnostics V200Pipeline::analyzePipeline(int64_t currentDownloadRateBps,
                                                    double aggregateSwarmCapacityMBs,
                                                    int currentSwarmRttMs,
                                                    int baselineRttMs,
                                                    double socketBufferFillPercent,
                                                    double cpuHashThreadLoadPercent,
                                                    double diskWriteLatencyMs,
                                                    double pieceCoalescingRatio) const {
    core::V200Diagnostics diag;

    // Calculate line efficiency percentage relative to 200 Mbps (25 MB/s)
    double rateBytes = static_cast<double>(currentDownloadRateBps);
    diag.lineEfficiencyPercent = std::clamp((rateBytes / THEORETICAL_MAX_BYTES_PER_SEC) * 100.0, 0.0, 100.0);
    diag.swarmSeedCapacityMBs = aggregateSwarmCapacityMBs;
    diag.averageSwarmRttMs = currentSwarmRttMs;
    diag.socketBufferUtilizationPercent = socketBufferFillPercent;
    diag.cpuHashUtilizationPercent = cpuHashThreadLoadPercent;
    diag.diskWriteLatencyMs = diskWriteLatencyMs;
    diag.directPieceCoalescingRatio = pieceCoalescingRatio;

    // 1. Check if line is already running near optimal saturation
    if (rateBytes >= OPTIMAL_THRESHOLD_BYTES_PER_SEC) {
        diag.primaryBottleneck = core::BottleneckCause::V200LineSaturatedOptimal;
        diag.bottleneckExplanation = getBottleneckExplanation(diag.primaryBottleneck);
        return diag;
    }

    // 2. Check Disk Storage Bottleneck
    if (diskWriteLatencyMs > 25.0) {
        diag.primaryBottleneck = core::BottleneckCause::DiskStorageBottleneck;
        diag.bottleneckExplanation = getBottleneckExplanation(diag.primaryBottleneck);
        return diag;
    }

    // 3. Check CPU Cryptographic Hash Verification Bottleneck
    if (cpuHashThreadLoadPercent >= 92.0) {
        diag.primaryBottleneck = core::BottleneckCause::CpuHashVerificationBound;
        diag.bottleneckExplanation = getBottleneckExplanation(diag.primaryBottleneck);
        return diag;
    }

    // 4. Check Socket Stack Backpressure
    if (socketBufferFillPercent >= 88.0) {
        diag.primaryBottleneck = core::BottleneckCause::WinsockStackBackpressure;
        diag.bottleneckExplanation = getBottleneckExplanation(diag.primaryBottleneck);
        return diag;
    }

    // 5. Check Network Bufferbloat (RTT delta > 50ms)
    int rttDelta = currentSwarmRttMs - baselineRttMs;
    if (rttDelta > 50 && currentSwarmRttMs > 120) {
        diag.primaryBottleneck = core::BottleneckCause::NetworkBufferbloat;
        diag.bottleneckExplanation = getBottleneckExplanation(diag.primaryBottleneck);
        return diag;
    }

    // 6. Check Swarm Seed Capacity
    if (aggregateSwarmCapacityMBs < 18.0) {
        diag.primaryBottleneck = core::BottleneckCause::SwarmCapacityConstrained;
        diag.bottleneckExplanation = getBottleneckExplanation(diag.primaryBottleneck);
        return diag;
    }

    diag.primaryBottleneck = core::BottleneckCause::None;
    diag.bottleneckExplanation = getBottleneckExplanation(diag.primaryBottleneck);
    return diag;
}

std::string V200Pipeline::getBottleneckExplanation(core::BottleneckCause cause) {
    switch (cause) {
        case core::BottleneckCause::V200LineSaturatedOptimal:
            return "Optimal Line Saturation: Transfer running at peak 200 Mbps broadband velocity (22-24+ MB/s).";
        case core::BottleneckCause::SwarmCapacityConstrained:
            return "Swarm Upload Constrained: Connected seeders are currently not providing enough upload bandwidth to saturate your 200 Mbps line.";
        case core::BottleneckCause::NetworkBufferbloat:
            return "Network Congestion / Bufferbloat: Local router queuing delay has increased significantly; uTP is maintaining latency stability.";
        case core::BottleneckCause::WinsockStackBackpressure:
            return "Winsock Socket Backpressure: OS network buffers are saturated; socket read window is being tuned.";
        case core::BottleneckCause::CpuHashVerificationBound:
            return "CPU Verification Bound: Cryptographic SHA hashing threads are near 100% capacity on current processor cores.";
        case core::BottleneckCause::DiskStorageBottleneck:
            return "Storage Write Bottleneck: Disk write latency exceeds 25ms; memory cache is coalescing writes to prevent dropped packets.";
        case core::BottleneckCause::None:
        default:
            return "Pipeline Balanced: Swarm, network, CPU, and storage subsystems are operating within normal operational parameters.";
    }
}

} // namespace velocity::engine
