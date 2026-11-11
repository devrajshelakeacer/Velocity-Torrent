// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include "core/Types.hpp"
#include "core/Interfaces.hpp"
#include <atomic>
#include <string>

namespace velocity::hardware {

class ThermalGuardian {
public:
    static constexpr float WARNING_THRESHOLD_CELSIUS = 80.0f;
    static constexpr float CRITICAL_PEAK_THRESHOLD_CELSIUS = 95.0f;

    ThermalGuardian();
    ~ThermalGuardian() = default;

    // Evaluates current hardware thermal sample and returns updated thermal state
    core::ThermalState evaluateTemperature(float currentTempCelsius);

    // Direct Piece Coalescing Cache calculation
    // Computes SSD write amplification reduction percentage based on staged block chunk size
    double calculateWriteAmplificationReduction(int coalescedChunkSizeBytes) const;

    // Current State Getters
    float getCurrentTemperature() const { return m_currentTemp.load(); }
    core::ThermalState getThermalState() const { return m_thermalState.load(); }
    bool isElevatedWarning() const { return m_thermalState.load() == core::ThermalState::ElevatedWarning; }
    bool isCriticalPeakDanger() const { return m_thermalState.load() == core::ThermalState::CriticalPeakDanger; }
    
    // Status message for UI telemetry
    std::string getThermalStatusString() const;

private:
    std::atomic<float> m_currentTemp{42.0f};
    std::atomic<core::ThermalState> m_thermalState{core::ThermalState::Normal};
};

} // namespace velocity::hardware
