// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include "core/Types.hpp"
#include <string>

namespace velocity::engine {

class V200Pipeline {
public:
    static constexpr double THEORETICAL_MAX_MBPS = 200.0;
    static constexpr double THEORETICAL_MAX_BYTES_PER_SEC = 25000000.0; // ~23.84 MiB/s
    static constexpr double OPTIMAL_THRESHOLD_BYTES_PER_SEC = 22000000.0; // 22 MB/s target

    V200Pipeline() = default;

    // Evaluates current pipeline state and returns structured diagnostics
    core::V200Diagnostics analyzePipeline(int64_t currentDownloadRateBps,
                                          double aggregateSwarmCapacityMBs,
                                          int currentSwarmRttMs,
                                          int baselineRttMs,
                                          double socketBufferFillPercent,
                                          double cpuHashThreadLoadPercent,
                                          double diskWriteLatencyMs,
                                          double pieceCoalescingRatio) const;

    // Returns human-readable bottleneck explanation
    static std::string getBottleneckExplanation(core::BottleneckCause cause);
};

} // namespace velocity::engine
