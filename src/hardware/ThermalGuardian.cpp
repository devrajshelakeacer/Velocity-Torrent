// SPDX-License-Identifier: GPL-3.0-or-later
#include "ThermalGuardian.hpp"
#include <algorithm>
#include <cmath>

namespace velocity::hardware {

ThermalGuardian::ThermalGuardian()
    : m_currentTemp(45.0f),
      m_thermalState(core::ThermalState::Normal) {}

core::ThermalState ThermalGuardian::evaluateTemperature(float currentTempCelsius) {
    m_currentTemp.store(currentTempCelsius);

    if (currentTempCelsius >= CRITICAL_PEAK_THRESHOLD_CELSIUS) {
        // >= 95°C: Extreme Silicon Danger Peak
        m_thermalState.store(core::ThermalState::CriticalPeakDanger);
    } else if (currentTempCelsius >= WARNING_THRESHOLD_CELSIUS) {
        // 80°C - 94°C: Elevated Warning.
        // User Directive: Fast download continues uninterrupted. No auto-downgrade to Balanced!
        m_thermalState.store(core::ThermalState::ElevatedWarning);
    } else {
        // < 80°C: Safe Normal Operating Temperature
        m_thermalState.store(core::ThermalState::Normal);
    }

    return m_thermalState.load();
}

double ThermalGuardian::calculateWriteAmplificationReduction(int coalescedChunkSizeBytes) const {
    // Standard random 16KB writes yield typical WAF of 3.0 to 5.0 on consumer TLC/QLC SSDs.
    // Assembling blocks into 4MB to 16MB sequential chunks approaches ideal WAF ~1.05.
    if (coalescedChunkSizeBytes <= 16384) {
        return 0.0; // Standard single block write; zero reduction
    }

    double sizeMb = static_cast<double>(coalescedChunkSizeBytes) / (1024.0 * 1024.0);
    // Scales up to ~90% reduction at 16MB contiguous commit
    double reduction = std::clamp((sizeMb / 16.0) * 90.0, 10.0, 92.5);
    return reduction;
}

std::string ThermalGuardian::getThermalStatusString() const {
    switch (m_thermalState.load()) {
        case core::ThermalState::Normal:
            return "Normal (Hardware Safe)";
        case core::ThermalState::ElevatedWarning:
            return "Elevated Warning (Fast Download Maintained — User in Control)";
        case core::ThermalState::CriticalPeakDanger:
            return "CRITICAL PEAK DANGER (>= 95°C — Hardware Protection Recommended)";
        default:
            return "Monitoring Active";
    }
}

} // namespace velocity::hardware
