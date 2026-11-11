// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <string>
#include <vector>
#include <mutex>

namespace velocity::network {

struct NetworkAdapterInfo {
    std::string id;
    std::string name;
    std::string description;
    std::string ipv4Address;
    std::string ipv6Address;
    std::string macAddress;
    bool isUp{false};
    bool isVpn{false};
    uint64_t linkSpeedBps{0};
};

class NetworkInterfaceManager {
public:
    NetworkInterfaceManager();
    ~NetworkInterfaceManager() = default;

    // Discovers available network adapters on the Windows host
    std::vector<NetworkAdapterInfo> discoverAdapters();

    // Sets the specific adapter GUID for Network Lock (kill-switch)
    void setNetworkLockAdapter(const std::string& adapterId);
    std::string getNetworkLockAdapter() const;
    bool isNetworkLockEngaged() const;

    // Checks if the locked adapter is currently operational
    bool isLockedInterfaceHealthy() const;

private:
    mutable std::mutex m_mutex;
    std::string m_lockedAdapterId;
    std::vector<NetworkAdapterInfo> m_cachedAdapters;
};

} // namespace velocity::network
