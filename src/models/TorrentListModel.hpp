// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <vector>
#include <string>
#include "core/Types.hpp"

namespace velocity::models {

// Plain C++ data representation for torrent list
class TorrentListModel {
public:
    TorrentListModel();
    ~TorrentListModel() = default;

    void updateSnapshots(const std::vector<core::TorrentSnapshot>& snapshots);
    const std::vector<core::TorrentSnapshot>& getSnapshots() const { return m_snapshots; }
    size_t count() const { return m_snapshots.size(); }

private:
    std::vector<core::TorrentSnapshot> m_snapshots;
};

} // namespace velocity::models
