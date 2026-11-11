# VELOCITY — Visual Design Research

## Executive Design Direction
VELOCITY is styled with a world-class, developer-first minimalist aesthetic inspired by Vercel's public design philosophy and the Swiss typography movement. Torrent clients have historically suffered from cluttered, garish, and chaotic interfaces laden with colorful icons, confusing tab walls, and outdated Windows XP-era controls. VELOCITY sets a new benchmark for visual elegance, restraint, and information density.

---

## 1. Visual Research Findings (Vercel Geist Interface Principles)

### A. The Principle of Restraint ("Restraint is the Product")
- **Monochrome Foundation**: Color is treated as a scarce, deliberate resource. Primary surfaces are absolute pitch black (`#000000`) or clean white (`#ffffff`). Contrast is achieved through subtle stepped gray values rather than saturated colors.
- **Micro-Accents Over Washes**: Status indicators (Active, Seeding, Throttled, Quarantined) use tiny, high-precision status dots (`size: 8px`) or subtle badge borders rather than loud full-cell background fills.
- **Zero Decorative Noise**: Every visual component serves a direct functional purpose. No glossy skeuomorphic buttons, gratuitous drop shadows, or decorative gradients.

### B. Typography Discipline (Geist Sans & Geist Mono)
- **Geist Sans (Interface & Labels)**:
  - Tight tracking (negative letter-spacing `-1.5%` to `-2.5%` on display headings) to create dense, confident typography.
  - Weights strictly limited to Regular (400), Medium (500), and Semi-Bold (600).
- **Geist Mono (Technical Metadata & Telemetry)**:
  - Monospaced tabular figures used for all rates (`23.4 MB/s`), completion percentages (`94.2%`), piece indices, swarm sizes, IP addresses, and SHA hashes.
  - Aligns numbers vertically across high-density tables without jitter as values change.

### C. Surface & Elevation Architecture
- **Hairline Borders (1px)**: Hierarchy is established primarily via crisp 1px borders (`#222222` in dark mode, `#eaeaea` in light mode) and surface contrast shifts rather than heavy drop shadows.
- **Card Radius Scale**: Deliberate, modern corner rounding (`6px` for small controls, `8px` for cards, `12px` for modals).
- **Subtle Layered Depth**: Card backgrounds sit at `#0a0a0a` or `#111111` against the `#000000` canvas, creating depth through delicate contrast steps.

### D. Layout & Spacing Rhythm
- **4px Systematic Grid Scale**:
  - `space4` (4px): Micro padding inside chips and badges.
  - `space8` (8px): Icon-to-text spacing, compact table padding.
  - `space12` (12px): Standard control padding, gap between card items.
  - `space16` (16px): Card interior padding.
  - `space24` (24px): Section gaps.
  - `space32` (32px): Major layout margins.
- **Generous Section Whitespace**: Dense tabular rows are balanced by clear, generous spacing between major view sections, creating high readability.

---

## 2. Competitive Interface Audit

| Product | Strengths | Severe Deficiencies | VELOCITY Advantage |
| :--- | :--- | :--- | :--- |
| **qBittorrent** | Functional, familiar layout | Outdated Qt5/Windows 7 look, tiny icons, cluttered tab walls, jarring dark theme | Modern Geist monochrome aesthetic, high-density clean tables, integrated V200 diagnostics. |
| **Transmission** | Minimalist, clean | Lacks deep performance analytics, limited Windows integration | Deep V200 bottleneck telemetry, V-FORCE performance profiles, and V-SHIELD security center. |
| **uTorrent (Modern)** | Web-based | Heavy advertising, bloatware installers, privacy invasion | 100% free, zero ads, zero accounts, zero cloud dependencies, pure local C++20/Qt6. |
| **PicoTorrent** | Native Win32 feel | Discontinued/stagnant, very limited feature set | Actively engineered, C++20, 200 Mbps pipeline optimization, Thermal Guardian. |

---

## 3. Visual Acceptance Criteria
1. **Pixel-Perfect Alignment**: All table headers, rows, and card margins align to the 4px grid.
2. **Tabular Metric Stability**: Speeds and piece counts never cause horizontal layout jitter during updates.
3. **Instant Theme Shift**: Switching between Dark and Light mode occurs within 1 frame with zero reload flicker.
4. **WCAG AA Compliance**: All text and foreground controls maintain $\ge 4.5:1$ contrast ratio against their respective backgrounds.
5. **No Decorative Fake Controls**: 100% of visible buttons, charts, and metrics connect to active C++ engine data.
