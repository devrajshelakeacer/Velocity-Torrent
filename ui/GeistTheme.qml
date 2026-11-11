// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15

pragma Singleton

QtObject {
    id: theme

    // Dual-theme toggle: Dark mode by default
    property bool isDark: true

    // Surface & Canvas Palette
    readonly property color canvas: isDark ? "#000000" : "#ffffff"
    readonly property color surfaceCard: isDark ? "#0a0a0a" : "#fafafa"
    readonly property color surfaceCardHover: isDark ? "#141414" : "#f0f0f0"
    readonly property color surfaceSubtle: isDark ? "#111111" : "#f5f5f5"
    readonly property color surfaceElevated: isDark ? "#1a1a1a" : "#ebebeb"

    // 1px Hairline Borders
    readonly property color borderHairline: isDark ? "#222222" : "#eaeaea"
    readonly property color borderHover: isDark ? "#383838" : "#cccccc"
    readonly property color borderFocused: "#0070f3"

    // Typographic Ink Palette
    readonly property color inkPrimary: isDark ? "#ffffff" : "#000000"
    readonly property color inkSecondary: isDark ? "#888888" : "#666666"
    readonly property color inkTertiary: isDark ? "#555555" : "#999999"

    // Restrained Purpose-Driven Accents
    readonly property color accentBlue: "#0070f3"   // Vercel Blue
    readonly property color accentGreen: isDark ? "#00e599" : "#10b981" // Emerald
    readonly property color accentAmber: isDark ? "#f5a623" : "#d97706" // Warning
    readonly property color accentRed: isDark ? "#ff3333" : "#dc2626"   // Crimson Alert

    // Typography Fonts
    readonly property string fontSans: "Geist, Segoe UI, -apple-system, sans-serif"
    readonly property string fontMono: "Geist Mono, Consolas, Courier New, monospace"

    // Spacing 4px Rhythm Scale
    readonly property int space4: 4
    readonly property int space8: 8
    readonly property int space12: 12
    readonly property int space16: 16
    readonly property int space24: 24
    readonly property int space32: 32
    readonly property int space48: 48

    // Radii
    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 6
    readonly property int radiusCard: 8
    readonly property int radiusModal: 12
}
