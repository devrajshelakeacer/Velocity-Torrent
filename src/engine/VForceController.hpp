// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include "core/Types.hpp"
#include "hardware/ThermalGuardian.hpp"
#include <memory>

namespace velocity::engine {

struct ProfileConfiguration {
    core::PerformanceProfile profile;
    int maxDiskCacheMB;
    int maxGlobalConnections;
    int maxConnectionsPerTorrent;
    int hashingThreads;
    int socketReceiveBufferKB;
    int pieceCoalescingChunkMB;
};

class VForceController {
public:
    VForceController();
    ~VForceController() = default;

    // Sets profile manually (Balanced, Turbo, VForceMax)
    void setProfile(core::PerformanceProfile profile);
    core::PerformanceProfile getProfile() const { return m_activeProfile; }
    ProfileConfiguration getConfiguration() const;

    // Evaluates thermal feedback from Thermal Guardian
    // User Directive: Fast download continues; NO auto-downgrade to Balanced at 85°C.
    void updateThermalSample(float cpuTempCelsius);

    hardware::ThermalGuardian& getThermalGuardian() { return m_thermalGuardian; }
    const hardware::ThermalGuardian& getThermalGuardian() const { return m_thermalGuardian; }

    static ProfileConfiguration getProfileDefaults(core::PerformanceProfile profile);

private:
    core::PerformanceProfile m_activeProfile{core::PerformanceProfile::Balanced};
    hardware::ThermalGuardian m_thermalGuardian;
};

} // namespace velocity::engine
