// SPDX-License-Identifier: GPL-3.0-or-later
#include "VForceController.hpp"

namespace velocity::engine {

VForceController::VForceController()
    : m_activeProfile(core::PerformanceProfile::Balanced) {}

void VForceController::setProfile(core::PerformanceProfile profile) {
    m_activeProfile = profile;
}

ProfileConfiguration VForceController::getConfiguration() const {
    return getProfileDefaults(m_activeProfile);
}

ProfileConfiguration VForceController::getProfileDefaults(core::PerformanceProfile profile) {
    ProfileConfiguration cfg;
    cfg.profile = profile;

    switch (profile) {
        case core::PerformanceProfile::Balanced:
            cfg.maxDiskCacheMB = 128;
            cfg.maxGlobalConnections = 120;
            cfg.maxConnectionsPerTorrent = 40;
            cfg.hashingThreads = 2;
            cfg.socketReceiveBufferKB = 512;
            cfg.pieceCoalescingChunkMB = 4;
            break;

        case core::PerformanceProfile::Turbo:
            cfg.maxDiskCacheMB = 512;
            cfg.maxGlobalConnections = 250;
            cfg.maxConnectionsPerTorrent = 80;
            cfg.hashingThreads = 4;
            cfg.socketReceiveBufferKB = 1024;
            cfg.pieceCoalescingChunkMB = 8;
            break;

        case core::PerformanceProfile::VForceMax:
            cfg.maxDiskCacheMB = 1536; // 1.5 GB
            cfg.maxGlobalConnections = 400;
            cfg.maxConnectionsPerTorrent = 120;
            cfg.hashingThreads = 8;
            cfg.socketReceiveBufferKB = 2048;
            cfg.pieceCoalescingChunkMB = 16;
            break;
    }

    return cfg;
}

void VForceController::updateThermalSample(float cpuTempCelsius) {
    // Evaluate temperature in Thermal Guardian
    m_thermalGuardian.evaluateTemperature(cpuTempCelsius);

    // USER DIRECTIVE POLICY ENFORCEMENT:
    // Fast download must continue without interruption.
    // We do NOT automatically demote m_activeProfile from VForceMax/Turbo to Balanced.
    // The user retains total manual control over their selected performance profile.
    // Thermal Guardian status is exposed to the UI so visible warnings alert the user.
}

} // namespace velocity::engine
