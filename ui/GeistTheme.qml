// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15

pragma Singleton

QtObject {
    id: theme

    // Dual-theme toggle: Dark mode by default
    property bool isDark: true

    // Surface & Canvas Palette (VELOCITY Dark Industrial Hierarchy)
    readonly property color canvas: isDark ? "#000000" : "#ffffff"
    readonly property color surfaceCard: isDark ? "#0a0a0a" : "#fafafa"
    readonly property color surfaceCardHover: isDark ? "#141414" : "#f0f0f0"
    readonly property color surfaceSubtle: isDark ? "#111111" : "#f5f5f5"
    readonly property color surfaceElevated: isDark ? "#171717" : "#ebebeb"

    // 1px Hairline Borders (Crisp Precision Borders)
    readonly property color borderHairline: isDark ? "#222222" : "#eaeaea"
    readonly property color borderCard: isDark ? "#2a2a2a" : "#e5e5e5"
    readonly property color borderHover: isDark ? "#444444" : "#cccccc"
    readonly property color borderFocused: "#0070f3"

    // Typographic Ink Palette (Restrained Monochromatic High Contrast)
    readonly property color inkPrimary: isDark ? "#ffffff" : "#000000"
    readonly property color inkSecondary: isDark ? "#a1a1a1" : "#666666"
    readonly property color inkTertiary: isDark ? "#737373" : "#888888"
    readonly property color inkMuted: isDark ? "#525252" : "#a1a1a1"

    // Restrained Purpose-Driven Accents (Strictly for Interaction & Status)
    readonly property color accentBlue: "#0070f3"       // Electric Industrial Blue
    readonly property color accentBlueHover: "#0060df"
    readonly property color accentGreen: "#00e599"      // Status: Connected/Active
    readonly property color accentAmber: "#f5a623"      // Status: Warning/Elevated
    readonly property color accentRed: "#ff3333"        // Status: Error/Critical

    // Typography: Official Inter Font Family
    readonly property string fontSans: "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"
    readonly property string fontMono: "Geist Mono, 'Cascadia Code', Consolas, 'Courier New', monospace"

    // Typography Scale (Strict MINIMUM 12px for High Readability)
    readonly property int fontSizeMicro: 12      // Minimum allowed anywhere (badges, fine metadata)
    readonly property int fontSizeCaption: 12    // Small captions, timestamps
    readonly property int fontSizeSub: 13        // Subtext, pill badges, secondary labels
    readonly property int fontSizeBody: 14       // Standard body, table items, inputs, buttons
    readonly property int fontSizeMedium: 16     // Card headers, section summaries, prominent metrics
    readonly property int fontSizeHeading: 20    // Major view headers, modal titles
    readonly property int fontSizeTitle: 24      // Page title
    readonly property int fontSizeDisplay: 32    // Large hero throughput metrics (e.g. 23.4 MB/s)

    // Spacing 4px Rhythm Scale
    readonly property int space4: 4
    readonly property int space8: 8
    readonly property int space12: 12
    readonly property int space16: 16
    readonly property int space20: 20
    readonly property int space24: 24
    readonly property int space32: 32
    readonly property int space48: 48

    // Radii (VELOCITY Industrial Radius Standards)
    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 6
    readonly property int radiusCard: 8
    readonly property int radiusPill: 9999
    readonly property int radiusModal: 12
}
