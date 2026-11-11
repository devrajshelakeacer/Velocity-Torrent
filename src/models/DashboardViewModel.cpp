// SPDX-License-Identifier: GPL-3.0-or-later
#include "DashboardViewModel.hpp"

namespace velocity::models {

DashboardViewModel::DashboardViewModel() = default;

void DashboardViewModel::updateMetrics(const core::SessionMetrics& metrics, 
                                       const core::V200Diagnostics& v200,
                                       float cpuTemp) {
    m_downloadSpeedMBs = static_cast<double>(metrics.aggregateDownloadRate) / 1000000.0;
    m_uploadSpeedMBs = static_cast<double>(metrics.aggregateUploadRate) / 1000000.0;
    m_lineEfficiencyPct = v200.lineEfficiencyPercent;
    m_swarmHealthPct = metrics.swarmHealthRatio * 100.0;
    m_cpuTemp = cpuTemp;
    m_bottleneckExplanation = v200.bottleneckExplanation;
}

} // namespace velocity::models
