# VELOCITY — Design System Specification

## 1. Color Palette Tokens

VELOCITY provides full, reactive dual-theme support (Dark Mode default; Light Mode toggleable).

### Dark Theme Tokens (Default)
| Token Name | Value | Purpose |
| :--- | :--- | :--- |
| `colorCanvas` | `#000000` | Application background canvas |
| `colorSurfaceCard` | `#0a0a0a` | Elevated card and container background |
| `colorSurfaceCardHover` | `#141414` | Hover state for interactive cards |
| `colorSurfaceSubtle` | `#111111` | Table row hover, input field background |
| `colorBorderHairline` | `#222222` | Standard 1px divider and container border |
| `colorBorderHover` | `#383838` | Interactive control hover border |
| `colorBorderFocused` | `#0070f3` | Keyboard focus ring |
| `colorInkPrimary` | `#ffffff` | Primary headings, prominent values |
| `colorInkSecondary` | `#888888` | Secondary labels, descriptions, column headers |
| `colorInkTertiary` | `#555555` | Disabled text, subtle timestamps |
| `colorAccentBlue` | `#0070f3` | Electric Accent Blue: primary CTA buttons, active tab indicators |
| `colorAccentGreen` | `#00e599` | Emerald: seeding status, healthy swarm, clean security scan |
| `colorAccentAmber` | `#f5a623` | Amber: thermal throttle warning, slow peer warning |
| `colorAccentRed` | `#ff3333` | Crimson: path traversal blocked, malware quarantined, error |

### Light Theme Tokens
| Token Name | Value | Purpose |
| :--- | :--- | :--- |
| `colorCanvas` | `#ffffff` | Application background canvas |
| `colorSurfaceCard` | `#fafafa` | Elevated card and container background |
| `colorSurfaceCardHover` | `#f0f0f0` | Hover state for interactive cards |
| `colorSurfaceSubtle` | `#f5f5f5` | Table row hover, input field background |
| `colorBorderHairline` | `#eaeaea` | Standard 1px divider and container border |
| `colorBorderHover` | `#cccccc` | Interactive control hover border |
| `colorBorderFocused` | `#0070f3` | Keyboard focus ring |
| `colorInkPrimary` | `#000000` | Primary headings, prominent values |
| `colorInkSecondary` | `#666666` | Secondary labels, descriptions, column headers |
| `colorInkTertiary` | `#999999` | Disabled text, subtle timestamps |
| `colorAccentBlue` | `#0070f3` | Electric Accent Blue: primary CTA buttons |
| `colorAccentGreen` | `#10b981` | Emerald: seeding status, clean scan |
| `colorAccentAmber` | `#d97706` | Amber: warning indicators |
| `colorAccentRed` | `#dc2626` | Crimson: error indicators |

---

## 2. Typography Hierarchy

| Style Token | Font Family | Size | Weight | Line Height | Tracking | Usage |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `typeDisplay` | Geist Sans / System Sans | 24px | 600 (SemiBold)| 32px | -2.0% | Major page titles |
| `typeHeading` | Geist Sans / System Sans | 18px | 600 (SemiBold)| 24px | -1.5% | Card section headings |
| `typeSubheading`| Geist Sans / System Sans | 14px | 500 (Medium) | 20px | -1.0% | Group headers, modal titles |
| `typeBody` | Geist Sans / System Sans | 13px | 400 (Regular)| 18px | 0.0% | Standard UI body text |
| `typeCaption` | Geist Sans / System Sans | 11px | 400 (Regular)| 16px | +0.5% | Secondary hints, footnotes |
| `typeMonoMetric`| Geist Mono / Consolas | 13px | 500 (Medium) | 18px | 0.0% | Speeds, ETA, file sizes |
| `typeMonoHash` | Geist Mono / Consolas | 11px | 400 (Regular)| 16px | 0.0% | SHA-1 / SHA-256 info-hashes |
| `typeBadge` | Geist Sans / System Sans | 10px | 600 (SemiBold)| 12px | +1.5% | Status badges (UPPERCASE) |

---

## 3. Spacing Scale

The spacing scale is derived from a 4px baseline rhythm:
- `space4`: 4px (badge internal padding)
- `space8`: 8px (compact gap, table cell vertical padding)
- `space12`: 12px (button horizontal padding, card interior gap)
- `space16`: 16px (standard card padding, grid margin)
- `space24`: 24px (section vertical spacing)
- `space32`: 32px (major layout margins)
- `space48`: 48px (empty-state hero padding)

---

## 4. Reusable Geist QML Component Architecture

1. **`GeistButton`**:
   - Variants: `Primary` (Solid white/black fill), `Secondary` (Transparent with 1px hairline border), `Danger` (Crimson accent).
   - Micro-transitions on hover and click; visible keyboard focus indicator.
2. **`GeistCard`**:
   - Surface container with 1px hairline border (`#222222`), 8px border radius, and subtle hover transition.
3. **`GeistBadge`**:
   - Compact status indicator featuring a colored status dot (`8px`) and 10px uppercase tracking label.
4. **`GeistProgressBar`**:
   - Ultra-slim 4px height bar with rounded ends; dynamic color based on state (Green for downloading/seeding, Amber for checking, Blue for complete).
5. **`GeistTableView`**:
   - High-density tabular layout with fixed-width numeric columns, interactive sort headers, and subtle row highlight on hover.
6. **`GeistChart`**:
   - Hardware-accelerated 60 FPS area chart visualizing network throughput (Download / Upload) over 60 seconds with gradient fill and dashed grid lines.
