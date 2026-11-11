// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include "Types.hpp"
#include <string>
#include <vector>
#include <memory>
#include <filesystem>

namespace velocity::core {

class ITorrentEngine {
public:
    virtual ~ITorrentEngine() = default;

    virtual bool initialize(const EngineConfig& config) = 0;
    virtual void shutdown() = 0;
    virtual bool isRunning() const = 0;

    virtual TorrentId addMagnet(const std::string& magnetUri, const std::string& savePath) = 0;
    virtual TorrentId addTorrentFile(const std::string& torrentFilePath, const std::string& savePath) = 0;
    virtual bool pauseTorrent(const TorrentId& id) = 0;
    virtual bool resumeTorrent(const TorrentId& id) = 0;
    virtual bool removeTorrent(const TorrentId& id, bool deleteFiles) = 0;
    virtual bool setTorrentPriority(const TorrentId& id, int fileIndex, FilePriority priority) = 0;

    virtual std::vector<TorrentSnapshot> getTorrentSnapshots() const = 0;
    virtual std::vector<PeerSnapshot> getPeerSnapshots(const TorrentId& id) const = 0;
    virtual SessionMetrics getSessionMetrics() const = 0;
    virtual V200Diagnostics getV200Diagnostics() const = 0;

    virtual void setPerformanceProfile(PerformanceProfile profile) = 0;
    virtual PerformanceProfile getPerformanceProfile() const = 0;

    virtual void setNetworkLockInterface(const std::string& adapterGuid) = 0;
    virtual bool isNetworkLockEngaged() const = 0;
};

} // namespace velocity::core

namespace velocity::security {

enum class SanitizeResult {
    Safe,
    Sanitized,
    RejectedPathTraversal,
    RejectedReservedName,
    RejectedAlternateDataStream
};

struct SanitizedPathResult {
    SanitizeResult status;
    std::filesystem::path safePath;
    std::string originalPath;
    std::string reason;
};

class ISecuritySanitizer {
public:
    virtual ~ISecuritySanitizer() = default;
    virtual SanitizedPathResult sanitizePath(const std::filesystem::path& downloadRoot, 
                                             const std::string& rawRelativePath) const = 0;
    virtual bool isSafeFilename(const std::string& filename) const = 0;
};

} // namespace velocity::security

namespace velocity::hardware {

struct ThermalSample {
    float temperatureCelsius{45.0f};
    bool isThrottling{false};
    bool isSensorAvailable{true};
    velocity::core::ThermalState thermalState{velocity::core::ThermalState::Normal};
    std::string sensorName;
};

class IThermalProvider {
public:
    virtual ~IThermalProvider() = default;
    virtual ThermalSample queryThermalState() = 0;
};

} // namespace velocity::hardware
