// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <string>
#include <vector>
#include <chrono>
#include <cstdint>

namespace velocity::core {

using TorrentId = std::string;

enum class TorrentState {
    Queued,
    Checking,
    Downloading,
    Seeding,
    Paused,
    Error
};

enum class FilePriority {
    Skip = 0,
    Low = 1,
    Normal = 4,
    High = 7
};

enum class PerformanceProfile {
    Balanced,
    Turbo,
    VForceMax
};

enum class ThermalState {
    Normal,
    ElevatedWarning,
    CriticalPeakDanger
};

enum class BottleneckCause {
    None,
    SwarmCapacityConstrained,
    NetworkBufferbloat,
    WinsockStackBackpressure,
    CpuHashVerificationBound,
    DiskStorageBottleneck,
    V200LineSaturatedOptimal
};

struct TorrentSnapshot {
    TorrentId id;
    std::string name;
    TorrentState state{TorrentState::Queued};
    int64_t totalBytes{0};
    int64_t downloadedBytes{0};
    int64_t uploadedBytes{0};
    int64_t downloadRate{0}; // bytes per second
    int64_t uploadRate{0};   // bytes per second
    double progress{0.0};    // 0.0 to 1.0
    int64_t etaSeconds{0};
    int seedsConnected{0};
    int seedsTotal{0};
    int peersConnected{0};
    int peersTotal{0};
    int averagePusScore{0};  // 0 to 100
    std::string infoHash;
    std::string savePath;
};

struct PeerSnapshot {
    std::string ip;
    uint16_t port{0};
    std::string clientName;
    std::string countryCode;
    std::string transportType; // "uTP" or "TCP"
    bool isEncrypted{true};
    int64_t downloadRate{0};
    int64_t uploadRate{0};
    int pusScore{0};
    double pieceAvailability{0.0};
    int rttMs{0};
    bool isChoked{false};
};

struct SessionMetrics {
    int64_t aggregateDownloadRate{0};
    int64_t aggregateUploadRate{0};
    int64_t totalDownloaded{0};
    int64_t totalUploaded{0};
    int activeDownloads{0};
    int activeSeeders{0};
    int totalConnectedPeers{0};
    double swarmHealthRatio{0.0};
};

struct V200Diagnostics {
    double lineEfficiencyPercent{0.0}; // e.g. 93.6% of 200 Mbps (25 MB/s)
    BottleneckCause primaryBottleneck{BottleneckCause::None};
    std::string bottleneckExplanation;
    double swarmSeedCapacityMBs{0.0};
    int averageSwarmRttMs{0};
    double socketBufferUtilizationPercent{0.0};
    double cpuHashUtilizationPercent{0.0};
    double diskWriteLatencyMs{0.0};
    double directPieceCoalescingRatio{0.0}; // percentage of writes coalesced into 4MB-16MB chunks
};

struct EngineConfig {
    std::string defaultSavePath;
    std::string incompleteSavePath;
    uint16_t listenPort{6881};
    bool enableUpnp{true};
    bool enableNatPmp{true};
    PerformanceProfile initialProfile{PerformanceProfile::Balanced};
    std::string networkLockAdapterGuid;
    bool enableDefenderScanning{true};
};

} // namespace velocity::core
