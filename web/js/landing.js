// SPDX-License-Identifier: GPL-3.0-or-later
/**
 * VELOCITY — Flagship Marketing Homepage Interactive Logic
 * Controls the real-time BDP Calculator, UI Preview Tab Switcher, and Terminal Copy Utilities.
 */

class VelocityLanding {
  constructor() {
    this.initMobileDrawer();
    this.initSpeedSlider();
    this.initPreviewTabs();
    this.initCopyButtons();
    this.initFaqAccordion();
    this.initBackToTop();
  }

  /* ---------------- 0. CLOUDFLARE-GRADE MOBILE DRAWER ---------------- */
  initMobileDrawer() {
    const toggle = document.getElementById('mobile-menu-toggle');
    const drawer = document.getElementById('mobile-drawer');
    if (!toggle || !drawer) return;

    const openDrawer = () => {
      toggle.classList.add('active');
      toggle.setAttribute('aria-expanded', 'true');
      drawer.classList.add('open');
      document.body.style.overflow = 'hidden';
    };

    const closeDrawer = () => {
      toggle.classList.remove('active');
      toggle.setAttribute('aria-expanded', 'false');
      drawer.classList.remove('open');
      document.body.style.overflow = '';
    };

    toggle.addEventListener('click', (e) => {
      e.stopPropagation();
      if (drawer.classList.contains('open')) {
        closeDrawer();
      } else {
        openDrawer();
      }
    });

    // Close when any link clicked
    drawer.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => closeDrawer());
    });

    // Close on Escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && drawer.classList.contains('open')) {
        closeDrawer();
      }
    });
  }

  /* ---------------- 1. INTERACTIVE BDP CALCULATOR ---------------- */
  initSpeedSlider() {
    const slider = document.getElementById('speed-slider');
    const badge = document.getElementById('speed-val-display');
    if (!slider || !badge) return;

    const updateCalc = () => {
      const mbps = parseInt(slider.value, 10);
      badge.textContent = `${mbps} Mbps`;

      // 50ms typical BitTorrent swarm round-trip time (RTT)
      const rtt = 0.050; 
      const wireBytesPerSec = (mbps * 1e6) / 8;
      const bdpBytes = wireBytesPerSec * rtt;
      const bdpMB = (bdpBytes / (1024 * 1024)).toFixed(2);

      // Legacy client buffer: 256 KiB = 0.25 MB
      const legacyBufferMB = 0.25;
      // Max throughput legacy can sustain before TCP window stalls = Buffer / RTT
      const legacyMaxMbps = Math.min(mbps, Math.round((legacyBufferMB * 8) / rtt));
      const legacyWireMbs = (legacyMaxMbps / 8).toFixed(1);
      const legacyEfficiency = Math.round((legacyMaxMbps / mbps) * 100);

      // VELOCITY buffer: 8.0 MiB
      const velocityBufferMB = 8.0;
      const velocityMaxMbps = Math.min(mbps, Math.round((velocityBufferMB * 8) / rtt));
      const velocityWireMbs = (velocityMaxMbps / 8).toFixed(1);
      const velocityEfficiency = 100;

      // Update DOM elements
      document.getElementById('bdp-requirement-val').textContent = `${bdpMB} MB`;
      
      document.getElementById('legacy-speed-val').textContent = `${legacyMaxMbps} Mbps (${legacyWireMbs} MB/s)`;
      document.getElementById('legacy-efficiency-val').textContent = `${legacyEfficiency}%`;
      document.getElementById('legacy-bar-fill').style.width = `${legacyEfficiency}%`;

      document.getElementById('velocity-speed-val').textContent = `${velocityMaxMbps} Mbps (${velocityWireMbs} MB/s)`;
      document.getElementById('velocity-efficiency-val').textContent = `${velocityEfficiency}% (SATURATED)`;
      document.getElementById('velocity-bar-fill').style.width = '100%';

      const legacyStatus = document.getElementById('legacy-stall-status');
      if (mbps > 40) {
        legacyStatus.innerHTML = `<span style="color: #ff5e57;"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align: -1px; margin-right: 4px;"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>STALLED</span> (Window exhausted by ${((bdpBytes / (256 * 1024))).toFixed(1)}x)`;
      } else {
        legacyStatus.innerHTML = `<span style="color: var(--accent-green);">OK</span>`;
      }
    };

    slider.addEventListener('input', updateCalc);
    updateCalc();
  }

  /* ---------------- 2. UI PREVIEW TAB SWITCHER ---------------- */
  initPreviewTabs() {
    const tabs = document.querySelectorAll('.preview-tab-btn');
    const container = document.getElementById('preview-tab-content');
    if (!tabs.length || !container) return;

    const views = {
      dashboard: `
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 20px;">
          <div style="background: #111; border: 1px solid var(--border-subtle); padding: 16px; border-radius: 8px;">
            <div style="font-size: 11px; color: var(--text-tertiary); text-transform: uppercase;">Download Speed</div>
            <div style="font-size: 26px; font-weight: 800; color: var(--accent-green); font-family: var(--font-mono);">23.84 MB/s</div>
            <div style="font-size: 11px; color: var(--accent-blue); margin-top: 4px;">Line Saturation: 99.8% [V200]</div>
          </div>
          <div style="background: #111; border: 1px solid var(--border-subtle); padding: 16px; border-radius: 8px;">
            <div style="font-size: 11px; color: var(--text-tertiary); text-transform: uppercase;">Swarm Health</div>
            <div style="font-size: 26px; font-weight: 800; color: #fff; font-family: var(--font-mono);">84 Peers</div>
            <div style="font-size: 11px; color: var(--accent-cyan); margin-top: 4px;">11 Tier-1 Trackers Active</div>
          </div>
          <div style="background: #111; border: 1px solid var(--border-subtle); padding: 16px; border-radius: 8px;">
            <div style="font-size: 11px; color: var(--text-tertiary); text-transform: uppercase;">V-FORCE Cache</div>
            <div style="font-size: 26px; font-weight: 800; color: #fff; font-family: var(--font-mono);">1.5 GB Pool</div>
            <div style="font-size: 11px; color: var(--accent-green); margin-top: 4px;">90% SSD WAF Reduction</div>
          </div>
        </div>
        <div style="background: #111; border: 1px solid var(--border-subtle); border-radius: 8px; padding: 16px;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
            <div style="font-weight: 600; font-size: 13px;">Cyberpunk.2077.v2.12.Repack-VELOCITY</div>
            <span style="font-size: 11px; font-family: var(--font-mono); color: var(--accent-green);">DOWNLOADING (78.4%)</span>
          </div>
          <div style="height: 6px; background: #222; border-radius: 3px; overflow: hidden; margin-bottom: 10px;">
            <div style="width: 78.4%; height: 100%; background: var(--accent-blue);"></div>
          </div>
          <div style="display: flex; justify-content: space-between; font-size: 11px; color: var(--text-secondary); font-family: var(--font-mono);">
            <span>67.2 GB / 85.7 GB · ETA: 12m 45s</span>
            <span>24.1 MB/s · 42 Seeds / 68 Leechers</span>
          </div>
        </div>
      `,
      gamehub: `
        <div style="display: flex; flex-direction: column; gap: 14px;">
          <div style="background: #111111; border: 1px solid var(--border-subtle); border-radius: 8px; padding: 18px; display: flex; justify-content: space-between; align-items: center;">
            <div>
              <div style="font-weight: 700; color: #fff; font-size: 14px; display: flex; align-items: center; gap: 8px;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="6" y1="12" x2="10" y2="12"></line><line x1="8" y1="10" x2="8" y2="14"></line><line x1="15" y1="13" x2="15.01" y2="13"></line><line x1="18" y1="11" x2="18.01" y2="11"></line><rect x="2" y="6" width="20" height="12" rx="2"></rect></svg>
                Game Repack Optimization Advisor
              </div>
              <div style="font-size: 12px; color: var(--text-secondary); margin-top: 4px;">
                "Yes! The game will run 100% smoothly in English without optional language files."
              </div>
            </div>
            <span style="background: rgba(0, 229, 153, 0.1); color: var(--accent-green); font-size: 11px; padding: 4px 10px; border-radius: 999px; font-family: var(--font-mono); font-weight: 600;">
              Saves 24.5 GB Bandwidth
            </span>
          </div>
          <div style="background: #111; border: 1px solid var(--border-subtle); border-radius: 8px; padding: 18px; display: flex; justify-content: space-between; align-items: center;">
            <div>
              <div style="font-weight: 700; color: #fff; font-size: 14px; display: flex; align-items: center; gap: 8px;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path><path d="m9 12 2 2 4-4"></path></svg>
                Anti-ISDone.dll Cryptographic Checksum Armor
              </div>
              <div style="font-size: 12px; color: var(--text-secondary); margin-top: 4px;">Multi-threaded background verification of .sfv & .md5 game archive digests.</div>
            </div>
            <span style="color: var(--accent-green); font-size: 12px; font-weight: 700; display: inline-flex; align-items: center; gap: 4px;">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
              ZERO CORRUPT BITS
            </span>
          </div>
          <div style="background: #111; border: 1px solid var(--border-subtle); border-radius: 8px; padding: 18px; display: flex; justify-content: space-between; align-items: center;">
            <div>
              <div style="font-weight: 700; color: #fff; font-size: 14px; display: flex; align-items: center; gap: 8px;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                Sub-10ms Win32 Gaming QoS Detector
              </div>
              <div style="font-size: 12px; color: var(--text-secondary); margin-top: 4px;">Auto-throttles to 2 MB/s during CS2/Valorant matches; restores 200 Mbps saturation on exit.</div>
            </div>
            <span style="color: var(--accent-cyan); font-size: 12px; font-family: var(--font-mono);">STATUS: SENSOR ACTIVE</span>
          </div>
        </div>
      `,
      peers: `
        <div style="background: #111; border: 1px solid var(--border-subtle); border-radius: 8px; overflow: hidden;">
          <table style="width: 100%; border-collapse: collapse; font-size: 12px; text-align: left;">
            <thead>
              <tr style="background: #181818; color: var(--text-tertiary); font-size: 11px; text-transform: uppercase;">
                <th style="padding: 10px 16px;">Peer IP & Port</th>
                <th style="padding: 10px 16px;">Client Software</th>
                <th style="padding: 10px 16px;">VSE-X Score</th>
                <th style="padding: 10px 16px;">Down Rate</th>
                <th style="padding: 10px 16px;">RTT Latency</th>
              </tr>
            </thead>
            <tbody style="color: var(--text-secondary); font-family: var(--font-mono);">
              <tr style="border-bottom: 1px solid rgba(255, 255, 255, 0.04);">
                <td style="padding: 10px 16px; color: #fff;">185.220.101.4:51413</td>
                <td style="padding: 10px 16px;">libtorrent/2.0.9</td>
                <td style="padding: 10px 16px; color: var(--accent-green); font-weight: 700;">PUS: 98/100</td>
                <td style="padding: 10px 16px; color: #fff;">8.4 MB/s</td>
                <td style="padding: 10px 16px;">24 ms</td>
              </tr>
              <tr style="border-bottom: 1px solid rgba(255, 255, 255, 0.04);">
                <td style="padding: 10px 16px; color: #fff;">94.130.82.12:6881</td>
                <td style="padding: 10px 16px;">qBittorrent/4.6.2</td>
                <td style="padding: 10px 16px; color: var(--accent-green); font-weight: 700;">PUS: 94/100</td>
                <td style="padding: 10px 16px; color: #fff;">6.1 MB/s</td>
                <td style="padding: 10px 16px;">38 ms</td>
              </tr>
              <tr>
                <td style="padding: 10px 16px; color: #fff;">192.168.1.105:49152</td>
                <td style="padding: 10px 16px;">Transmission/4.0.3</td>
                <td style="padding: 10px 16px; color: var(--accent-green); font-weight: 700;">PUS: 89/100</td>
                <td style="padding: 10px 16px; color: #fff;">4.8 MB/s</td>
                <td style="padding: 10px 16px;">12 ms</td>
              </tr>
            </tbody>
          </table>
        </div>
      `,
      security: `
        <div style="background: #111; border: 1px solid var(--border-subtle); border-radius: 8px; padding: 24px;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
            <div style="font-weight: 700; color: #fff; font-size: 15px;">V-Shield Live Security Monitor</div>
            <span style="background: rgba(0, 229, 153, 0.1); color: var(--accent-green); border: 1px solid rgba(0, 229, 153, 0.3); padding: 4px 12px; border-radius: 999px; font-size: 11px; font-weight: 700;">
              34/34 DEFENSE VERIFIED
            </span>
          </div>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; font-size: 12px; font-family: var(--font-mono);">
            <div style="background: #161616; padding: 12px; border-radius: 6px; border-left: 3px solid var(--accent-green);">
              <div style="color: #fff; font-weight: 600;">Path Traversal Jail</div>
              <div style="color: var(--text-tertiary); font-size: 11px; margin-top: 2px;">Canonical root enforcement · 100% blocked</div>
            </div>
            <div style="background: #161616; padding: 12px; border-radius: 6px; border-left: 3px solid var(--accent-green);">
              <div style="color: #fff; font-weight: 600;">Win32 Reserved Devices</div>
              <div style="color: var(--text-tertiary); font-size: 11px; margin-top: 2px;">CON, PRN, AUX, NUL, COM1-9 · 100% blocked</div>
            </div>
            <div style="background: #161616; padding: 12px; border-radius: 6px; border-left: 3px solid var(--accent-green);">
              <div style="color: #fff; font-weight: 600;">NTFS ADS Stripping</div>
              <div style="color: var(--text-tertiary); font-size: 11px; margin-top: 2px;">Zone.Identifier & hidden streams · Neutralized</div>
            </div>
            <div style="background: #161616; padding: 12px; border-radius: 6px; border-left: 3px solid var(--accent-green);">
              <div style="color: #fff; font-weight: 600;">OS Command Injection</div>
              <div style="color: var(--text-tertiary); font-size: 11px; margin-top: 2px;">Zero shell execution · Direct Win32 API parameters</div>
            </div>
          </div>
        </div>
      `
    };

    tabs.forEach(tab => {
      tab.addEventListener('click', () => {
        tabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        const viewKey = tab.getAttribute('data-view');
        if (views[viewKey]) {
          container.innerHTML = views[viewKey];
        }
      });
    });

    // Default to dashboard
    container.innerHTML = views.dashboard;
  }

  /* ---------------- 3. CLIPBOARD COPY UTILITIES ---------------- */
  initCopyButtons() {
    const copyBtns = document.querySelectorAll('[data-copy-target]');
    copyBtns.forEach(btn => {
      btn.addEventListener('click', () => {
        const textToCopy = btn.getAttribute('data-copy-text');
        if (textToCopy) {
          navigator.clipboard.writeText(textToCopy).then(() => {
            this.showToast('Copied to clipboard!');
          }).catch(() => {
            this.showToast('Failed to copy');
          });
        }
      });
    });
  }

  /* ---------------- 4. FAQ ACCORDION LOGIC ---------------- */
  initFaqAccordion() {
    const items = document.querySelectorAll('.faq-item');
    items.forEach(item => {
      const trigger = item.querySelector('.faq-trigger');
      if (!trigger) return;
      trigger.addEventListener('click', () => {
        const wasActive = item.classList.contains('active');
        // Close other items
        items.forEach(i => {
          i.classList.remove('active');
          const t = i.querySelector('.faq-trigger');
          if (t) t.setAttribute('aria-expanded', 'false');
        });
        if (!wasActive) {
          item.classList.add('active');
          trigger.setAttribute('aria-expanded', 'true');
        }
      });
    });
  }

  /* ---------------- 5. FLOATING BACK TO TOP ---------------- */
  initBackToTop() {
    const btn = document.getElementById('back-to-top');
    if (!btn) return;
    window.addEventListener('scroll', () => {
      if (window.scrollY > 400) {
        btn.classList.add('visible');
      } else {
        btn.classList.remove('visible');
      }
    }, { passive: true });

    btn.addEventListener('click', () => {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  showToast(msg) {
    let toast = document.getElementById('landing-toast');
    if (!toast) {
      toast = document.createElement('div');
      toast.id = 'landing-toast';
      toast.className = 'landing-toast';
      document.body.appendChild(toast);
    }
    toast.textContent = msg;
    toast.classList.add('show');
    setTimeout(() => {
      toast.classList.remove('show');
    }, 2500);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  window.velocityLanding = new VelocityLanding();
});
