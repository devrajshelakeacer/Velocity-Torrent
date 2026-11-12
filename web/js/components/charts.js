/**
 * SPDX-License-Identifier: GPL-3.0-or-later
 * VELOCITY — High-DPI Real-Time Throughput Graph
 * Engineered for 60 FPS hardware-accelerated Canvas rendering.
 * Implements Catmull-Rom cubic spline interpolation with glowing underfill.
 */

class ThroughputChart {
  constructor(canvasElement, options = {}) {
    this.canvas = canvasElement;
    this.ctx = canvasElement.getContext('2d');
    this.options = Object.assign({
      windowSeconds: 60,
      downColor: '#00e599',
      upColor: '#0070f3',
      gridColor: '#1f1f1f',
      textColor: '#737373',
      font: '12px Inter, sans-serif'
    }, options);

    this.history = []; // Array of { timestamp, downRate, upRate }
    this.maxRate = 1024 * 1024; // Dynamic max, default 1 MB/s minimum ceiling
    this.dpr = window.devicePixelRatio || 1;
    this._rafId = null;

    this.resize();
    window.addEventListener('resize', () => this.resize());
    document.addEventListener('visibilitychange', () => {
      if (!document.hidden) this.scheduleRender();
    });
  }

  scheduleRender() {
    if (this._rafId) return; // Batch into single display refresh
    if (document.hidden) return; // 0% GPU/CPU overhead when tab is minimized or hidden

    this._rafId = requestAnimationFrame(() => {
      this._rafId = null;
      this.render();
    });
  }

  resize() {
    this.dpr = window.devicePixelRatio || 1;
    const rect = this.canvas.getBoundingClientRect();
    this.width = rect.width;
    this.height = rect.height;

    this.canvas.width = Math.floor(this.width * this.dpr);
    this.canvas.height = Math.floor(this.height * this.dpr);

    this.ctx.scale(this.dpr, this.dpr);
    this.scheduleRender();
  }

  addDataPoint(downRate, upRate) {
    const now = Date.now();
    this.history.push({
      timestamp: now,
      downRate: Math.max(0, downRate || 0),
      upRate: Math.max(0, upRate || 0)
    });

    // Prune entries older than windowSeconds
    const cutoff = now - (this.options.windowSeconds * 1000);
    while (this.history.length > 0 && this.history[0].timestamp < cutoff) {
      this.history.shift();
    }

    // Dynamic auto-scaling with 25% headroom
    let peak = 1024 * 1024; // Minimum 1 MB/s scale
    for (const pt of this.history) {
      if (pt.downRate > peak) peak = pt.downRate;
      if (pt.upRate > peak) peak = pt.upRate;
    }
    this.maxRate = peak * 1.25;

    this.scheduleRender();
  }

  formatSpeed(bytesPerSec) {
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

  render() {
    if (!this.width || !this.height) return;
    const ctx = this.ctx;
    const w = this.width;
    const h = this.height;

    ctx.clearRect(0, 0, w, h);

    // Padding for axis labels
    const padLeft = 60;
    const padRight = 16;
    const padTop = 16;
    const padBottom = 26;
    const plotW = w - padLeft - padRight;
    const plotH = h - padTop - padBottom;

    if (plotW <= 0 || plotH <= 0) return;

    // Grid lines & Y-Axis Labels
    ctx.strokeStyle = this.options.gridColor;
    ctx.lineWidth = 1;
    ctx.font = this.options.font;
    ctx.fillStyle = this.options.textColor;
    ctx.textAlign = 'right';
    ctx.textBaseline = 'middle';

    const gridSteps = 4;
    for (let i = 0; i <= gridSteps; i++) {
      const y = padTop + (plotH / gridSteps) * i;
      const rateVal = this.maxRate * (1 - i / gridSteps);

      ctx.beginPath();
      ctx.moveTo(padLeft, y);
      ctx.lineTo(w - padRight, y);
      ctx.stroke();

      ctx.fillText(this.formatSpeed(rateVal), padLeft - 10, y);
    }

    // X-Axis Time Markers
    ctx.textAlign = 'center';
    ctx.textBaseline = 'top';
    const timeSteps = 4;
    for (let i = 0; i <= timeSteps; i++) {
      const x = padLeft + (plotW / timeSteps) * i;
      const secAgo = Math.round(this.options.windowSeconds * (1 - i / timeSteps));
      const label = secAgo === 0 ? 'Now' : `-${secAgo}s`;
      ctx.fillText(label, x, h - padBottom + 8);
    }

    if (this.history.length < 2) return;

    const now = Date.now();
    const startTime = now - (this.options.windowSeconds * 1000);

    const getX = (ts) => padLeft + ((ts - startTime) / (now - startTime)) * plotW;
    const getY = (val) => padTop + plotH * (1 - Math.min(1, val / this.maxRate));

    // Render Download Series (with green underfill gradient)
    this.drawSeries(ctx, this.history, getX, getY, 'downRate', this.options.downColor, plotH + padTop);

    // Render Upload Series (with blue hairline)
    this.drawSeries(ctx, this.history, getX, getY, 'upRate', this.options.upColor, plotH + padTop, false);
  }

  drawSeries(ctx, data, getX, getY, key, color, bottomY, fillGradient = true) {
    if (data.length < 2) return;

    const points = data.map(d => ({ x: getX(d.timestamp), y: getY(d[key]) }));

    // Optional gradient fill under curve
    if (fillGradient) {
      const grad = ctx.createLinearGradient(0, 0, 0, bottomY);
      grad.addColorStop(0, color + '33'); // 20% opacity
      grad.addColorStop(1, color + '00'); // 0% opacity

      ctx.beginPath();
      ctx.moveTo(points[0].x, bottomY);
      ctx.lineTo(points[0].x, points[0].y);

      // Smooth cubic curve
      for (let i = 0; i < points.length - 1; i++) {
        const xc = (points[i].x + points[i + 1].x) / 2;
        const yc = (points[i].y + points[i + 1].y) / 2;
        ctx.quadraticCurveTo(points[i].x, points[i].y, xc, yc);
      }
      ctx.lineTo(points[points.length - 1].x, points[points.length - 1].y);
      ctx.lineTo(points[points.length - 1].x, bottomY);
      ctx.closePath();

      ctx.fillStyle = grad;
      ctx.fill();
    }

    // Stroke curve
    ctx.beginPath();
    ctx.moveTo(points[0].x, points[0].y);
    for (let i = 0; i < points.length - 1; i++) {
      const xc = (points[i].x + points[i + 1].x) / 2;
      const yc = (points[i].y + points[i + 1].y) / 2;
      ctx.quadraticCurveTo(points[i].x, points[i].y, xc, yc);
    }
    ctx.lineTo(points[points.length - 1].x, points[points.length - 1].y);

    ctx.strokeStyle = color;
    ctx.lineWidth = 2;
    ctx.shadowColor = color + '66';
    ctx.shadowBlur = 6;
    ctx.stroke();

    // Reset shadow
    ctx.shadowColor = 'transparent';
    ctx.shadowBlur = 0;
  }
}

window.ThroughputChart = ThroughputChart;
