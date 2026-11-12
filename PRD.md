# PRD: VELOCITY Flagship Website Overhaul

## Objective
Elevate the VELOCITY product showcase website (`http://127.0.0.1:8080/landing`) to world-class enterprise SaaS standards (Cloudflare / Vercel grade), resolve excessive whitespace gaps, integrate Google Font Inter across all platforms, ensure strict mobile and laptop responsiveness, and introduce all universal website essentials (FAQ accordion, mobile drawer, platform requirements, back-to-top).

## Acceptance Criteria
1. **Typography**: Google Font Inter (400, 500, 600, 700, 800) and JetBrains Mono loaded via preconnect CDN with `font-display: swap`.
2. **Spacing Normalization**: Section padding normalized to 48px–60px (desktop) and 36px–44px (mobile), eliminating cavernous gaps.
3. **Cloudflare-Grade Navbar**:
   - 60px height, sticky frosted glass (`backdrop-filter: blur(20px)`), hairline borders.
   - Dedicated brand identity, desktop navigation links, GitHub star button, and persistent "Launch Web Client" CTA.
   - Animated 3-bar mobile hamburger toggle with full-screen slide-down drawer supporting escape key, link click auto-close, and backdrop dismiss.
4. **Universal Website Essentials**:
   - Interactive FAQ Accordion (6 critical questions with smooth CSS grid expansion & chevron rotation).
   - Platform Support & System Requirements Strip (Windows 10/11, macOS, Linux, Python 3.10+).
   - Privacy & Local Operation commitment in footer.
   - Floating Back-to-Top button appearing after 400px scroll.
5. **Strict Responsiveness**:
   - Mobile (320px–480px), Tablet (768px–1024px), Laptop (1025px–1440px), Desktop (1441px+).
   - Cross-browser support including Firefox `::-moz-range-thumb`.
6. **Automated Verification**:
   - Multi-viewport headless Chrome CDP test verifying mobile hamburger, FAQ accordion, slider calculations, and responsive layout without console errors.

## Tasks
- [x] Task 1: Typography Overhaul — Load Inter & JetBrains Mono fonts and update global stacks
- [x] Task 2: Spacing & Gap Normalization — Normalize padding and margins across all sections in CSS
- [x] Task 3: Cloudflare-Grade Navbar & Mobile Hamburger Drawer — Header markup, styles, and drawer logic
- [x] Task 4: Universal Website Essentials — FAQ Accordion, Platform strip, Back-to-Top, and Legal statements
- [ ] Task 5: Responsive Architecture & Cross-Browser Controls — Mobile grid stacking, table scroll, and Firefox slider styling
- [ ] Task 6: Multi-Viewport Automated CDP Verification & Testing — Automated tests on Mobile (375px), Tablet (768px), and Desktop (1920px)
