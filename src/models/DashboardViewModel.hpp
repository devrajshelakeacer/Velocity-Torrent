// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include "core/Types.hpp"
#include <string>

namespace velocity::models {

class DashboardViewModel {
public:
    DashboardViewModel();
    ~DashboardViewModel() = default;

    void updateMetrics(const core::SessionMetrics& metrics, 
                       const core::V200Diagnostics& v200,
                       float cpuTemp);

    double getDownloadSpeedMBs() const { return m_downloadSpeedMBs; }
    double getUploadSpeedMBs() const { return m_uploadSpeedMBs; }
    double getLineEfficiencyPct() const { return m_lineEfficiencyPct; }
    double getSwarmHealthPct() const { return m_swarmHealthPct; }
    float getCpuTemperature() const { return m_cpuTemp; }
    std::string getBottleneckExplanation() const { return m_bottleneckExplanation; }

private:
    double m_downloadSpeedMBs{23.4};
    double m_uploadSpeedMBs{1.45};
    double m_lineEfficiencyPct{93.6};
    double m_swarmHealthPct{94.2};
    float m_cpuTemp{48.0f};
    std::string m_bottleneckExplanation{"Optimal Line Saturation"};
};

} // namespace velocity::models
