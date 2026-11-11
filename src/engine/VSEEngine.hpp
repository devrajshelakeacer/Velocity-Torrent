// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include "core/Interfaces.hpp"
#include "security/VShieldSanitizer.hpp"
#include "PeerScorer.hpp"
#include "V200Pipeline.hpp"
#include "VForceController.hpp"
#include "network/NetworkInterfaceManager.hpp"
#include <unordered_map>
#include <mutex>
#include <atomic>

namespace velocity::engine {

class VSEEngine : public core::ITorrentEngine {
public:
    VSEEngine();
    ~VSEEngine() override;

    bool initialize(const core::EngineConfig& config) override;
    void shutdown() override;
    bool isRunning() const override;

    core::TorrentId addMagnet(const std::string& magnetUri, const std::string& savePath) override;
    core::TorrentId addTorrentFile(const std::string& torrentFilePath, const std::string& savePath) override;
    bool pauseTorrent(const core::TorrentId& id) override;
    bool resumeTorrent(const core::TorrentId& id) override;
    bool removeTorrent(const core::TorrentId& id, bool deleteFiles) override;
    bool setTorrentPriority(const core::TorrentId& id, int fileIndex, core::FilePriority priority) override;

    std::vector<core::TorrentSnapshot> getTorrentSnapshots() const override;
    std::vector<core::PeerSnapshot> getPeerSnapshots(const core::TorrentId& id) const override;
    core::SessionMetrics getSessionMetrics() const override;
    core::V200Diagnostics getV200Diagnostics() const override;

    void setPerformanceProfile(core::PerformanceProfile profile) override;
    core::PerformanceProfile getPerformanceProfile() const override;

    void setNetworkLockInterface(const std::string& adapterGuid) override;
    bool isNetworkLockEngaged() const override;

    // Simulation/Mock Tick for controlled benchmark & testing environments
    void advanceTick(double deltaSeconds);

    // Subsystem accessors
    security::VShieldSanitizer& getSanitizer() { return m_sanitizer; }
    PeerScorer& getPeerScorer() { return m_peerScorer; }
    V200Pipeline& getV200Pipeline() { return m_v200Pipeline; }
    VForceController& getVForceController() { return m_vforceController; }
    network::NetworkInterfaceManager& getNetworkManager() { return m_networkManager; }

private:
    std::atomic<bool> m_running{false};
    core::EngineConfig m_config;
    mutable std::mutex m_stateMutex;

    security::VShieldSanitizer m_sanitizer;
    PeerScorer m_peerScorer;
    V200Pipeline m_v200Pipeline;
    VForceController m_vforceController;
    network::NetworkInterfaceManager m_networkManager;

    std::unordered_map<core::TorrentId, core::TorrentSnapshot> m_torrents;
    std::unordered_map<core::TorrentId, std::vector<core::PeerSnapshot>> m_peers;
};

} // namespace velocity::engine
