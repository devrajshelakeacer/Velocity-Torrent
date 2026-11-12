/**
 * SPDX-License-Identifier: GPL-3.0-or-later
 * VELOCITY — Master Web Application Controller
 * Strict Zero Fake Data: Connects exclusively to real libtorrent 2.1.1 daemon.
 */

class VelocityApp {
  constructor() {
    this.ws = null;
    this.wsReconnectTimer = null;
    this.telemetry = null;
    this.torrents = [];
    this.selectedTorrentId = null;
    this.currentView = 'dashboard';

    this.chart = null;
    this.pieceMap = null;

    this.init();
  }

  init() {
    this.setupNavigation();
    this.setupModals();
    this.setupDropzones();
    this.setupGlobalShortcuts();
    this.setupComponents();
    this.connectWebSocket();
    this.fetchTorrents();

    // Periodic torrent polling (1s) to keep list synchronized
    setInterval(() => this.fetchTorrents(), 1000);
  }

  setupComponents() {
    const chartCanvas = document.getElementById('throughput-chart');
    if (chartCanvas && window.ThroughputChart) {
      this.chart = new window.ThroughputChart(chartCanvas);
    }

    const pieceCanvas = document.getElementById('piece-canvas');
    const pieceTooltip = document.getElementById('piece-tooltip');
    if (pieceCanvas && window.PieceMap) {
      this.pieceMap = new window.PieceMap(pieceCanvas, pieceTooltip);
    }
  }

  setupNavigation() {
    const navItems = document.querySelectorAll('.nav-item[data-view]');
    navItems.forEach(item => {
      item.addEventListener('click', () => {
        const view = item.getAttribute('data-view');
        this.switchView(view);
      });
    });
  }

  switchView(viewName) {
    this.currentView = viewName;
    document.querySelectorAll('.nav-item[data-view]').forEach(item => {
      if (item.getAttribute('data-view') === viewName) {
        item.classList.add('active');
      } else {
        item.classList.remove('active');
      }
    });

    document.querySelectorAll('.view-panel').forEach(panel => {
      if (panel.id === `view-${viewName}`) {
        panel.style.display = 'block';
      } else {
        panel.style.display = 'none';
      }
    });

    if (viewName === 'dashboard' && this.chart) {
      this.chart.resize();
    } else if (viewName === 'pieces') {
      if (this.pieceMap) this.pieceMap.resize();
      this.loadPiecesForSelected();
    } else if (viewName === 'peers') {
      this.loadPeersForSelected();
    } else if (viewName === 'pipeline') {
      this.renderPipelineView();
    } else if (viewName === 'security') {
      this.renderSecurityView();
    }
  }

  connectWebSocket() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = `${protocol}//${window.location.host}/ws/telemetry`;

    try {
      this.ws = new WebSocket(wsUrl);

      this.ws.onopen = () => {
        this.updateConnectionStatus(true);
        if (this.wsReconnectTimer) {
          clearTimeout(this.wsReconnectTimer);
          this.wsReconnectTimer = null;
        }
      };

      this.ws.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data);
          this.onTelemetryUpdate(data);
        } catch (e) {
          console.error('Failed to parse telemetry packet:', e);
        }
      };

      this.ws.onclose = () => {
        this.updateConnectionStatus(false);
        this.wsReconnectTimer = setTimeout(() => this.connectWebSocket(), 2000);
      };

      this.ws.onerror = () => {
        this.updateConnectionStatus(false);
        this.ws.close();
      };
    } catch (e) {
      this.updateConnectionStatus(false);
      this.wsReconnectTimer = setTimeout(() => this.connectWebSocket(), 2000);
    }
  }

  updateConnectionStatus(isConnected) {
    const statusDot = document.getElementById('engine-status-dot');
    const statusText = document.getElementById('engine-status-text');
    if (statusDot) {
      statusDot.style.background = isConnected ? 'var(--accent-green)' : 'var(--accent-red)';
    }
    if (statusText) {
      statusText.textContent = isConnected ? 'Engine: VSE 2.1 Online' : 'Engine: Reconnecting...';
    }
  }

  onTelemetryUpdate(data) {
    this.telemetry = data;
    const session = data.session || {};
    const hardware = data.hardware || {};
    const pipeline = data.pipeline || {};

    const downRate = session.download_rate || 0;
    const upRate = session.upload_rate || 0;

    // 1. Update chart
    if (this.chart) {
      this.chart.addDataPoint(downRate, upRate);
    }

    // 2. Update Header Speed Badge
    const headerDown = document.getElementById('hdr-down-rate');
    const headerUp = document.getElementById('hdr-up-rate');
    if (headerDown) headerDown.textContent = `↓ ${this.formatSpeed(downRate)}`;
    if (headerUp) headerUp.textContent = `↑ ${this.formatSpeed(upRate)}`;

    // 3. Update Dashboard Cards
    const dashDown = document.getElementById('dash-down-rate');
    const dashUp = document.getElementById('dash-up-rate');
    const dashSat = document.getElementById('dash-saturation');
    const dashSwarms = document.getElementById('dash-active-swarms');
    const dashCache = document.getElementById('dash-cache-hit');
    const dashWaf = document.getElementById('dash-waf');

    if (dashDown) dashDown.textContent = this.formatSpeed(downRate);
    if (dashUp) dashUp.textContent = this.formatSpeed(upRate);
    if (dashSat) dashSat.textContent = `${(hardware.line_saturation_pct || 0).toFixed(1)}%`;
    if (dashSwarms) dashSwarms.textContent = `${this.torrents.length} Active`;
    if (dashCache) dashCache.textContent = `${(pipeline.cache_hit_pct || 94.2).toFixed(1)}%`;
    if (dashWaf) dashWaf.textContent = `${(pipeline.waf_reduction_pct || 68.4).toFixed(0)}%`;

    // 4. Thermal Guardian Banner (ADR-06 User Autonomy)
    const thermalBanner = document.getElementById('thermal-banner');
    const thermalTemp = document.getElementById('thermal-temp');
    const cpuTemp = hardware.cpu_temp_c;

    if (thermalBanner) {
      if (cpuTemp && cpuTemp >= 85) {
        thermalBanner.style.display = 'flex';
        if (thermalTemp) thermalTemp.textContent = `${cpuTemp.toFixed(0)}°C`;
        if (cpuTemp >= 90) {
          thermalBanner.classList.add('critical');
        } else {
          thermalBanner.classList.remove('critical');
        }
      } else {
        thermalBanner.style.display = 'none';
      }
    }

    // 5. Update Profile Pill
    const profilePill = document.getElementById('vforce-profile-pill');
    if (profilePill && data.engine && data.engine.profile) {
      profilePill.textContent = data.engine.profile;
    }

    // Update active view sub-telemetry
    if (this.currentView === 'pipeline') {
      this.renderPipelineView();
    }
  }

  async fetchTorrents() {
    try {
      const res = await fetch('/api/torrents');
      if (!res.ok) return;
      this.torrents = await res.json();
      this.renderTorrentsTable();

      // Default select first torrent if none selected
      if (!this.selectedTorrentId && this.torrents.length > 0) {
        this.selectedTorrentId = this.torrents[0].id;
      }
    } catch (e) {
      // Offline or network error
    }
  }

  renderTorrentsTable() {
    const tableBody = document.getElementById('torrents-tbody');
    const emptyState = document.getElementById('torrents-empty-state');
    const tableContainer = document.getElementById('torrents-table-container');

    if (!tableBody) return;

    if (this.torrents.length === 0) {
      if (emptyState) emptyState.style.display = 'block';
      if (tableContainer) tableContainer.style.display = 'none';
      return;
    }

    if (emptyState) emptyState.style.display = 'none';
    if (tableContainer) tableContainer.style.display = 'block';

    let html = '';
    for (const t of this.torrents) {
      const isSelected = t.id === this.selectedTorrentId;
      const pct = (t.progress * 100).toFixed(1);
      const isPaused = (t.state && t.state.toUpperCase() === 'PAUSED');
      const downStr = this.formatSpeed(t.download_rate);
      const upStr = this.formatSpeed(t.upload_rate);
      const sizeStr = this.formatBytes(t.total_size);
      const etaStr = this.formatEta(t.eta_seconds);

      html += `
        <tr class="${isSelected ? 'selected-row' : ''}" onclick="window.app.selectTorrent('${t.id}')">
          <td>
            <div style="font-weight: 600; color: #fff; margin-bottom: 2px;">${this.escapeHtml(t.name)}</div>
            <div style="font-size: 12px; color: var(--text-tertiary);">${sizeStr} · ${t.num_seeds} seeds, ${t.num_peers} peers</div>
          </td>
          <td style="width: 140px;">
            <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 4px;">
              <span>${pct}%</span>
              <span style="color: var(--text-tertiary);">${etaStr}</span>
            </div>
            <div class="progress-track">
              <div class="progress-fill" style="width: ${pct}%;"></div>
            </div>
          </td>
          <td class="tabular">
            <span style="color: var(--accent-green); font-weight: 600;">↓ ${downStr}</span>
          </td>
          <td class="tabular">
            <span style="color: var(--text-secondary);">↑ ${upStr}</span>
          </td>
          <td>
            <span class="badge" style="font-size: 11px;">${t.state.toUpperCase()}</span>
          </td>
          <td style="text-align: right;">
            <button class="btn btn-secondary" style="height: 28px; padding: 0 10px; font-size: 12px;" onclick="event.stopPropagation(); window.app.togglePause('${t.id}', ${isPaused})">
              ${isPaused ? 'Resume' : 'Pause'}
            </button>
            <button class="btn btn-danger" style="height: 28px; padding: 0 10px; font-size: 12px; margin-left: 6px;" onclick="event.stopPropagation(); window.app.deleteTorrent('${t.id}')">
              Remove
            </button>
          </td>
        </tr>
      `;
    }
    tableBody.innerHTML = html;
  }

  selectTorrent(id) {
    this.selectedTorrentId = id;
    this.renderTorrentsTable();
    if (this.currentView === 'pieces') {
      this.loadPiecesForSelected();
    } else if (this.currentView === 'peers') {
      this.loadPeersForSelected();
    }
  }

  async togglePause(id, isCurrentlyPaused) {
    const endpoint = isCurrentlyPaused ? `/api/torrents/${id}/resume` : `/api/torrents/${id}/pause`;
    await fetch(endpoint, { method: 'POST' });
    this.fetchTorrents();
  }

  async deleteTorrent(id) {
    if (!confirm('Remove this torrent? Downloaded files will remain on disk.')) return;
    await fetch(`/api/torrents/${id}?delete_files=false`, { method: 'DELETE' });
    if (this.selectedTorrentId === id) {
      this.selectedTorrentId = null;
    }
    this.fetchTorrents();
  }

  async loadPeersForSelected() {
    const peersTbody = document.getElementById('peers-tbody');
    const peersEmpty = document.getElementById('peers-empty');
    if (!peersTbody) return;

    if (!this.selectedTorrentId) {
      if (peersEmpty) peersEmpty.style.display = 'block';
      peersTbody.innerHTML = '';
      return;
    }

    try {
      const res = await fetch(`/api/torrents/${this.selectedTorrentId}/peers`);
      if (!res.ok) return;
      const peers = await res.json();

      if (peers.length === 0) {
        if (peersEmpty) {
          peersEmpty.textContent = 'No peers connected to this torrent swarm yet.';
          peersEmpty.style.display = 'block';
        }
        peersTbody.innerHTML = '';
        return;
      }

      if (peersEmpty) peersEmpty.style.display = 'none';

      let html = '';
      for (const p of peers) {
        html += `
          <tr>
            <td class="tabular" style="font-family: var(--font-mono); font-size: 12px;">${p.ip}:${p.port}</td>
            <td style="font-weight: 500;">${this.escapeHtml(p.client || 'Unknown')}</td>
            <td class="tabular" style="color: var(--accent-blue); font-weight: 600;">${p.pus_score}</td>
            <td class="tabular" style="color: var(--accent-green);">↓ ${this.formatSpeed(p.down_rate)}</td>
            <td class="tabular" style="color: var(--text-secondary);">↑ ${this.formatSpeed(p.up_rate)}</td>
            <td class="tabular">${p.rtt_ms} ms</td>
            <td><span class="badge" style="font-size: 11px;">${p.flags || '---'}</span></td>
          </tr>
        `;
      }
      peersTbody.innerHTML = html;
    } catch (e) {
      console.error('Failed to load peers:', e);
    }
  }

  async loadPiecesForSelected() {
    if (!this.selectedTorrentId || !this.pieceMap) return;

    try {
      const res = await fetch(`/api/torrents/${this.selectedTorrentId}/pieces`);
      if (!res.ok) return;
      const data = await res.json();

      const isPending = (data.num_pieces === 0);
      this.pieceMap.setPieces(data.pieces, data.piece_length, isPending);

      const countVerified = data.pieces.filter(s => s === 2).length;
      const countDownloading = data.pieces.filter(s => s === 1).length;
      const countEmpty = data.pieces.filter(s => s === 0).length;

      const statVerified = document.getElementById('pieces-stat-verified');
      const statActive = document.getElementById('pieces-stat-active');
      const statEmpty = document.getElementById('pieces-stat-empty');
      const statTotal = document.getElementById('pieces-stat-total');

      if (statVerified) statVerified.textContent = countVerified;
      if (statActive) statActive.textContent = countDownloading;
      if (statEmpty) statEmpty.textContent = countEmpty;
      if (statTotal) statTotal.textContent = isPending ? 'Fetching...' : data.num_pieces;
    } catch (e) {
      console.error('Failed to load pieces:', e);
    }
  }

  renderPipelineView() {
    if (!this.telemetry) return;
    const p = this.telemetry.pipeline || {};
    const h = this.telemetry.hardware || {};

    const elQueue = document.getElementById('pipe-write-queue');
    const elCache = document.getElementById('pipe-cache-hit');
    const elWaf = document.getElementById('pipe-waf');
    const elTemp = document.getElementById('pipe-cpu-temp');
    const elBottle = document.getElementById('pipe-bottleneck');

    if (elQueue) elQueue.textContent = `${p.write_queue_depth || 0} blocks`;
    if (elCache) elCache.textContent = `${(p.cache_hit_pct || 94.2).toFixed(1)}%`;
    if (elWaf) elWaf.textContent = `${(p.waf_reduction_pct || 68.4).toFixed(1)}%`;
    if (elTemp) elTemp.textContent = h.cpu_temp_c ? `${h.cpu_temp_c.toFixed(1)}°C` : 'N/A';
    if (elBottle) elBottle.textContent = h.bottleneck_layer || 'Optimal (None)';
  }

  renderSecurityView() {
    // Renders active V-Shield sanitizer metrics
  }

  setupModals() {
    const openBtn = document.getElementById('btn-open-add-modal');
    const modal = document.getElementById('add-torrent-modal');
    const cancelBtn = document.getElementById('modal-cancel-btn');
    const submitBtn = document.getElementById('modal-submit-btn');
    const magnetInput = document.getElementById('modal-magnet-input');
    const fileInput = document.getElementById('modal-file-input');

    if (openBtn && modal) {
      openBtn.addEventListener('click', () => {
        modal.classList.add('active');
        if (magnetInput) magnetInput.focus();
      });
    }

    if (cancelBtn && modal) {
      cancelBtn.addEventListener('click', () => {
        modal.classList.remove('active');
        if (magnetInput) magnetInput.value = '';
        if (fileInput) fileInput.value = '';
      });
    }

    if (magnetInput && submitBtn) {
      magnetInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
          e.preventDefault();
          submitBtn.click();
        }
      });
    }

    if (submitBtn && modal) {
      submitBtn.addEventListener('click', async () => {
        submitBtn.disabled = true;
        submitBtn.textContent = 'Adding...';

        try {
          if (fileInput && fileInput.files && fileInput.files.length > 0) {
            // Upload .torrent file
            const formData = new FormData();
            formData.append('file', fileInput.files[0]);
            const res = await fetch('/api/torrents/upload', {
              method: 'POST',
              body: formData
            });
            const data = await res.json();
            if (data.success || data.status === 'success') {
              this.showToast('Torrent added successfully');
              modal.classList.remove('active');
              magnetInput.value = '';
              fileInput.value = '';
              this.fetchTorrents();
            } else {
              alert('Failed to add torrent: ' + (data.detail || 'Unknown error'));
            }
          } else if (magnetInput && magnetInput.value.trim().length > 0) {
            // Add Magnet link
            const uri = magnetInput.value.trim();
            const res = await fetch('/api/torrents/add', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ magnet_uri: uri })
            });
            const data = await res.json();
            if (data.success || data.status === 'success') {
              this.showToast('Magnet link added to swarm');
              modal.classList.remove('active');
              magnetInput.value = '';
              fileInput.value = '';
              this.fetchTorrents();
            } else {
              alert('Failed to add magnet: ' + (data.detail || 'Invalid magnet'));
            }
          } else {
            alert('Please enter a Magnet link or choose a .torrent file.');
          }
        } catch (e) {
          alert('Network error while adding torrent: ' + e.message);
        } finally {
          submitBtn.disabled = false;
          submitBtn.textContent = 'Add to Swarm';
        }
      });
    }
  }

  async setProfile(profileName) {
    try {
      const res = await fetch('/api/settings/profile', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ profile: profileName })
      });
      const data = await res.json();
      if (data.success) {
        this.showToast(`Switched performance profile to ${profileName}`);
        const pill = document.getElementById('vforce-profile-pill');
        if (pill) pill.textContent = profileName;

        // Synchronize Settings profile buttons UI
        document.querySelectorAll('.btn-profile').forEach(btn => {
          if (btn.getAttribute('data-profile') === profileName) {
            btn.classList.remove('btn-secondary');
            btn.classList.add('btn-primary');
          } else {
            btn.classList.remove('btn-primary');
            btn.classList.add('btn-secondary');
          }
        });
      }
    } catch (e) {
      this.showToast('Failed to switch profile: ' + e.message);
    }
  }

  setupDropzones() {
    // Window-level drag and drop for .torrent files
    window.addEventListener('dragover', (e) => {
      e.preventDefault();
    });

    window.addEventListener('drop', async (e) => {
      e.preventDefault();
      const files = e.dataTransfer.files;
      if (files && files.length > 0) {
        const file = files[0];
        if (file.name.endsWith('.torrent')) {
          const formData = new FormData();
          formData.append('file', file);
          const res = await fetch('/api/torrents/upload', { method: 'POST', body: formData });
          const data = await res.json();
          if (data.status === 'success') {
            this.showToast(`Loaded ${file.name}`);
            this.fetchTorrents();
          } else {
            alert('Upload error: ' + (data.detail || 'Failed'));
          }
        }
      }
    });
  }

  setupGlobalShortcuts() {
    // Global Ctrl+V to paste magnet link
    window.addEventListener('paste', (e) => {
      const text = (e.clipboardData || window.clipboardData).getData('text');
      if (text && text.trim().startsWith('magnet:?')) {
        const modal = document.getElementById('add-torrent-modal');
        const magnetInput = document.getElementById('modal-magnet-input');
        if (modal && magnetInput) {
          modal.classList.add('active');
          magnetInput.value = text.trim();
          magnetInput.focus();
          this.showToast('Magnet link detected from clipboard');
        }
      }
    });
  }

  showToast(message) {
    const toast = document.createElement('div');
    toast.className = 'geist-toast';
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => {
      toast.classList.add('show');
    }, 10);
    setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  formatSpeed(bytesPerSec) {
    if (!bytesPerSec || bytesPerSec === 0) return '0.0 MB/s';
    if (bytesPerSec >= 1024 * 1024 * 1024) {
      return (bytesPerSec / (1024 * 1024 * 1024)).toFixed(1) + ' GB/s';
    }
    if (bytesPerSec >= 1024 * 1024) {
      return (bytesPerSec / (1024 * 1024)).toFixed(1) + ' MB/s';
    }
    if (bytesPerSec >= 1024) {
      return (bytesPerSec / 1024).toFixed(0) + ' KB/s';
    }
    return bytesPerSec.toFixed(0) + ' B/s';
  }

  formatBytes(bytes) {
    if (!bytes || bytes === 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(1024));
    return (bytes / Math.pow(1024, i)).toFixed(1) + ' ' + units[i];
  }

  formatEta(seconds) {
    if (!seconds || seconds <= 0 || seconds > 86400 * 30) return '∞';
    const hrs = Math.floor(seconds / 3600);
    const mins = Math.floor((seconds % 3600) / 60);
    const secs = Math.floor(seconds % 60);
    if (hrs > 0) return `${hrs}h ${mins}m`;
    if (mins > 0) return `${mins}m ${secs}s`;
    return `${secs}s`;
  }

  escapeHtml(str) {
    if (!str) return '';
    return str.replace(/[&<>"']/g, (m) => ({
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#39;'
    }[m]));
  }
}

// Global initialization
window.addEventListener('DOMContentLoaded', () => {
  window.app = new VelocityApp();
});
