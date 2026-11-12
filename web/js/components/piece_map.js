/**
 * SPDX-License-Identifier: GPL-3.0-or-later
 * VELOCITY — High-Performance Piece Heatmap Visualizer
 * Renders torrent piece distribution across swarms using Canvas 2D.
 * Supports up to 20,000+ blocks with batched rendering and hover inspection.
 */

class PieceMap {
  constructor(canvasElement, tooltipElement) {
    this.canvas = canvasElement;
    this.ctx = canvasElement.getContext('2d');
    this.tooltip = tooltipElement;
    this.pieces = []; // 0: empty, 1: downloading, 2: verified
    this.pieceSize = 0;
    this.totalPieces = 0;
    this.dpr = window.devicePixelRatio || 1;

    // Palette (VELOCITY design tokens)
    this.colors = {
      empty: '#171717',
      emptyBorder: '#262626',
      downloading: '#0070f3',
      verified: '#00e599'
    };

    this.blockSize = 12;
    this.gap = 2;
    this.cols = 1;
    this.rows = 1;

    this.resize();
    this.setupInteractivity();
    window.addEventListener('resize', () => this.resize());
  }

  resize() {
    this.dpr = window.devicePixelRatio || 1;
    const rect = this.canvas.getBoundingClientRect();
    this.width = rect.width;
    this.height = Math.max(160, rect.height);

    this.canvas.width = Math.floor(this.width * this.dpr);
    this.canvas.height = Math.floor(this.height * this.dpr);

    this.ctx.scale(this.dpr, this.dpr);
    this.calculateGrid();
    this.render();
  }

  calculateGrid() {
    if (!this.totalPieces || this.totalPieces === 0) return;
    const availableW = this.width - 4;
    const stride = this.blockSize + this.gap;
    this.cols = Math.max(1, Math.floor(availableW / stride));
    this.rows = Math.ceil(this.totalPieces / this.cols);

    // Dynamic height resize if rows overflow canvas
    const requiredH = this.rows * stride + 4;
    if (requiredH > this.height) {
      this.canvas.style.height = `${requiredH}px`;
      this.height = requiredH;
      this.canvas.height = Math.floor(this.height * this.dpr);
      this.ctx.scale(this.dpr, this.dpr);
    }
  }

  setPieces(pieceArray, pieceSizeBytes = 1048576, isPending = false) {
    this.pieces = pieceArray || [];
    this.totalPieces = this.pieces.length;
    this.pieceSize = pieceSizeBytes;
    this.isPending = isPending;
    this.calculateGrid();
    this.render();
  }

  setupInteractivity() {
    this.canvas.addEventListener('mousemove', (e) => {
      if (!this.totalPieces || !this.tooltip) return;
      const rect = this.canvas.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const stride = this.blockSize + this.gap;
      const col = Math.floor(x / stride);
      const row = Math.floor(y / stride);

      if (col >= 0 && col < this.cols) {
        const index = row * this.cols + col;
        if (index >= 0 && index < this.totalPieces) {
          const state = this.pieces[index];
          const stateText = state === 2 ? 'Verified (Complete)' : (state === 1 ? 'Downloading (In-Flight)' : 'Unrequested');
          const stateColor = state === 2 ? '#00e599' : (state === 1 ? '#0070f3' : '#a1a1a1');
          const startMb = (index * this.pieceSize / (1024 * 1024)).toFixed(1);
          const endMb = ((index + 1) * this.pieceSize / (1024 * 1024)).toFixed(1);

          this.tooltip.innerHTML = `
            <div style="font-weight: 600; margin-bottom: 2px;">Piece #${index}</div>
            <div style="color: ${stateColor}; font-size: 11px;">${stateText}</div>
            <div style="color: #737373; font-size: 11px; margin-top: 2px;">Range: ${startMb}MB - ${endMb}MB</div>
          `;
          this.tooltip.style.display = 'block';
          this.tooltip.style.left = `${e.clientX + 14}px`;
          this.tooltip.style.top = `${e.clientY + 14}px`;
          return;
        }
      }
      this.tooltip.style.display = 'none';
    });

    this.canvas.addEventListener('mouseleave', () => {
      if (this.tooltip) this.tooltip.style.display = 'none';
    });
  }

  render() {
    if (!this.width || !this.height) return;
    const ctx = this.ctx;
    ctx.clearRect(0, 0, this.width, this.height);

    if (this.totalPieces === 0) {
      ctx.fillStyle = '#737373';
      ctx.font = '13px Inter, sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText(this.isPending ? 'Connecting to swarm / retrieving metadata...' : 'No active torrent selected', this.width / 2, this.height / 2);
      return;
    }

    const stride = this.blockSize + this.gap;

    for (let i = 0; i < this.totalPieces; i++) {
      const col = i % this.cols;
      const row = Math.floor(i / this.cols);
      const x = col * stride + 2;
      const y = row * stride + 2;

      const state = this.pieces[i];
      if (state === 2) {
        ctx.fillStyle = this.colors.verified;
      } else if (state === 1) {
        ctx.fillStyle = this.colors.downloading;
      } else {
        ctx.fillStyle = this.colors.empty;
      }

      ctx.fillRect(x, y, this.blockSize, this.blockSize);

      // Border for empty pieces to maintain grid rhythm
      if (state === 0) {
        ctx.strokeStyle = this.colors.emptyBorder;
        ctx.lineWidth = 1;
        ctx.strokeRect(x + 0.5, y + 0.5, this.blockSize - 1, this.blockSize - 1);
      }
    }
  }
}

window.PieceMap = PieceMap;
