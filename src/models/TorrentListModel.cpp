// SPDX-License-Identifier: GPL-3.0-or-later
#include "TorrentListModel.hpp"

namespace velocity::models {

TorrentListModel::TorrentListModel() = default;

void TorrentListModel::updateSnapshots(const std::vector<core::TorrentSnapshot>& snapshots) {
    m_snapshots = snapshots;
}

} // namespace velocity::models
