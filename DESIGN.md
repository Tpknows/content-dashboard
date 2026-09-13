---
name: EasyPC Content Dashboard
description: A hard-edged black/near-black performance instrument with one green signal accent, built for a single static index.html.
colors:
  black-chrome: "#000000"
  dark-surface: "#1A1A1A"
  surface2: "#242424"
  border-hairline: "rgba(255,255,255,0.12)"
  border-hairline-strong: "rgba(255,255,255,0.22)"
  chrome-border: "rgba(255,255,255,0.14)"
  text-primary: "#FFFFFF"
  text-secondary: "#a7a7a7"
  text-tertiary: "#898989"
  chrome-text: "#FFFFFF"
  chrome-text2: "#a7a7a7"
  chrome-text3: "#898989"
  nvidia-green: "#76b900"
  nvidia-green-light: "#bff230"
  cyan-info: "#4d9fff"
  purple: "#b48cff"
  green-success: "#5cb800"
  orange: "#df6500"
  pink: "#f472b6"
  yellow: "#ef9100"
  red-alert: "#ff5c5c"
  fill-safe-red: "#e52020"
  fill-safe-blue: "#0046a4"
typography:
  kpi-value:
    fontFamily: "Archivo, Arial, Helvetica, sans-serif"
    fontSize: "32px"
    fontWeight: 700
    letterSpacing: "-0.5px"
  stat-value:
    fontFamily: "Archivo, Arial, Helvetica, sans-serif"
    fontSize: "26px to 30px"
    fontWeight: 700
    letterSpacing: "-0.5px to -0.8px"
  title:
    fontFamily: "Archivo, Arial, Helvetica, sans-serif"
    fontSize: "17px to 20px"
    fontWeight: 700
  card-title:
    fontFamily: "Archivo, Arial, Helvetica, sans-serif"
    fontSize: "13px to 16px"
    fontWeight: 600
  body:
    fontFamily: "Archivo, Arial, Helvetica, sans-serif"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "Archivo, Arial, Helvetica, sans-serif"
    fontSize: "10px to 12.5px"
    fontWeight: 600
    letterSpacing: "0.3px to 1px"
rounded:
  standard: "2px"
spacing:
  card-padding-sm: "24px"
  card-padding-md: "28px"
  card-padding-lg: "32px"
  grid-gap: "16px"
  section-gap: "40px"
components:
  button-primary:
    backgroundColor: "transparent"
    textColor: "#FFFFFF"
    typography: "{typography.label}"
    rounded: "{rounded.standard}"
    padding: "11px 24px"
  sidebar-item-active:
    backgroundColor: "transparent"
    textColor: "{colors.chrome-text}"
    rounded: "{rounded.standard}"
    padding: "11px 12px"
  kpi-card:
    backgroundColor: "{colors.dark-surface}"
    textColor: "{colors.text-primary}"
    rounded: "{rounded.standard}"
    padding: "{spacing.card-padding-md}"
  tab-active:
    backgroundColor: "#FFFFFF"
    textColor: "#000000"
    rounded: "{rounded.standard}"
    padding: "10px 18px"
---

# Design System: EasyPC Content Dashboard

## Overview

**Creative North Star: "The Instrument Panel" (dark variant)**

The dashboard reads as a precision measuring instrument, not a decorative product page: true-black chrome (sidebar, header, tabs bar) frames near-black `#1A1A1A` data surfaces (cards, tables, charts), with a single NVIDIA-green (`#76b900`) accent doing all the signaling — active nav item, focused input, primary-action border. The system shipped light-first (white `#FFFFFF` data surfaces), then was converted to a permanent dark variant on user request, using NVIDIA's own documented dark-card alternative (`#1a1a1a`, per the pinned design.hagicode.com/designs/nvidia reference, which lists "Background: #ffffff or #1a1a1a" for cards). This is not a toggle — there is no light mode left in the shipped file; dark is the only surface state.

Converting the surfaces from white to near-black inverted which tokens needed a contrast-safe substitute. In the light build, the raw NVIDIA green and the raw yellow/orange "average" tier both failed WCAG AA as text-on-white, so darkened stand-ins (`#4d7a00`, `#b35400`) carried them as text. On the dark surface the relationship flips: the raw bright tokens (`#76b900`, `#ef9100`) read fine as text on `#1a1a1a`, so those darkened stand-ins were retired — but the semantic blue/purple/pink/green/red tier colors, which were tuned dark enough to read on *white*, now fail badly as text on `#1a1a1a` and were re-tuned brighter. See Colors → Named Rules for the exact before/after mapping and the one place a *darker* literal (not a token) is still deliberately kept for a solid-fill badge.

Density is high and functional — three different audiences (contributors, the content manager, leadership) read tables, KPI cards, and calendars packed at a small type scale, and the shipped system accepted that density rather than inflating it for legibility theater. Color is otherwise reserved: outside the semantic quality-tier badges (see Colors → Named Rules), the only saturated color on any screen is the one green accent.

**Key Characteristics:**
- True-black chrome / near-black (`#1A1A1A`) data-surface split, never mixed on the same panel.
- One accent (`#76b900`) reserved for active/focus/primary-border states only; on this dark surface it also reads fine directly as text (no darkened stand-in needed anymore).
- A five-tier semantic color ramp (green/cyan/purple/yellow/red) is the one deliberate exception to "one accent" — it carries real Hook Rate/Hold Rate quality meaning, not decoration. All five tiers were re-tuned brighter for the dark surface.
- Flat by default: no gradients, no blur; the one shadow token appears only on hover-lift and open modals.
- 2px corner radius everywhere; no exceptions found in the shipped CSS.

## Colors

The palette is a strict two-tone system (true black chrome / near-black `#1A1A1A` card surfaces) plus one signal accent and a small semantic set; there is no decorative color anywhere in the shipped stylesheet.

### Primary
- **NVIDIA Green** (`#76b900`): the single accent. Used for the active sidebar item's 1px border, focus rings, primary-button border (`#generateBtn` and every other primary CTA), `.dot-green`/status-good indicators, and — on this dark build — directly as text color too (`--accent-text` now equals `--accent`; the light build's darkened `#4d7a00` stand-in is retired, since raw green clears AA on `#1a1a1a`).
- **NVIDIA Green Light** (`#bff230`): a lighter accent variant present in `:root` (`--accent-light`), reserved for accent-on-black emphasis, not used as a body text color.

### Neutral
- **True Black** (`#000000`): chrome background (sidebar, header, tabs bar, mobile nav) *and* the page canvas behind the cards (`--bg`).
- **Dark Surface** (`#1A1A1A`): every data-panel surface — `.card`, `.kpi-card`, `.chart-card`, modals, the AI Insights snapshot tiles.
- **Surface2** (`#242424`): secondary surface fill (`--surface2`), e.g. select-hover backgrounds, sub-tab pill-group backgrounds.
- **Text Primary** (`#FFFFFF`): primary text on the dark surface and on black chrome alike.
- **Text Secondary** (`#a7a7a7`, NVIDIA Gray-300) and **Text Tertiary** (`#898989`, NVIDIA Gray-400): two *distinct* secondary grays on the dark surface — see Named Rules for why this build has the full three-tier hierarchy the light build could not.
- **Hairline Border** (`rgba(255,255,255,0.12)`) and **Hairline Border Strong** (`rgba(255,255,255,0.22)`): dividers and card borders on the dark surface; strengthens on hover. (The light build's black-tinted hairlines are gone — everything is a light-on-dark hairline now, chrome included.)

### Semantic quality ramp (used on Hook Rate / Hold Rate tiers, chart status badges, KPI status)
All five tiers were re-tuned brighter than their light-build values, because those values were chosen to read on white and are too dark to read as text on `#1a1a1a`.
- **Excellent / Good status** — Green `#5cb800` (`--green`; light-build value was `#3f8500`), background tint `rgba(92,184,0,0.1)`.
- **Very Strong / info** — Blue `#4d9fff` (`--cyan`; light-build value was `#0046A4`), background tint `rgba(77,159,255,0.1)`.
- **Good (mid-tier)** — Purple `#b48cff` (`--purple`; light-build value was `#4d1368`), background tint `rgba(180,140,255,0.1)`.
- **Average / at-risk / warn** — Yellow `#ef9100` (`--yellow` **and** `--yellow-text`, now the same value; the light build's darkened `#b35400` stand-in is retired since raw yellow clears AA on `#1a1a1a`).
- **Weak / behind / alert (text)** — Red `#ff5c5c` (`--red`; light-build value was `#e52020`), background tint `rgba(255,92,92,0.1)`.
- **Orange** (`#df6500`, unchanged from the light build — it happens to clear AA as text on both white and `#1a1a1a`) and **Pink** (`#f472b6`; light-build value was `#8c1c55`) appear only as KPI-card top accent stripes and a couple of decorative labels, not as primary badge text.

### Named Rules
**The One Signal Rule.** `#76b900` marks exactly one thing per screen: what is active, focused, or primary. On this dark build it doubles as a text color too — no darkened stand-in is needed, unlike the light build.

**The Three-Gray Restoration Rule.** The light build had to collapse `--text2`/`--text3` into one shared gray (`#757575`) because the NVIDIA spec's literal Gray-400 (`#898989`) fails AA as text on white. On the dark surface the same Gray-400 clears AA comfortably (`#898989` on `#1a1a1a` ≈ 5:1), so this build restores the full three-tier hierarchy: `--text` white, `--text2` Gray-300 (`#a7a7a7`), `--text3` Gray-400 (`#898989`). Do not collapse these back to one value without re-checking contrast first — the light-mode compromise was a contrast necessity, not a stylistic default to carry forward by habit.

**The Text-Safe vs Fill-Safe Split Rule (new in this build).** Brightening the semantic ramp for text-on-dark readability made those same bright values *fail* white-text-on-solid-fill contrast (e.g. white text on `#ff5c5c` ≈ 3:1). Two solid-fill badge contexts — the sidebar's "overdue creative jobs" count badge and its mobile twin — therefore keep the **original, darker, un-brightened literals** (`#e52020` for red, `#0046a4` for blue) as their `background`, specifically because those are solid fills carrying white text, not text-on-surface. These two hex values are intentionally *not* tokenized to `--red`/`--cyan` and must not be "corrected" to match the brighter semantic-ramp values — doing so would silently reintroduce the exact contrast failure this rule documents. Every other use of red/blue in the file (badge text, chart lines, tier labels, translucent-tint chip text) uses the brighter `--red`/`--cyan` tokens correctly.

**The Semantic-Only Saturation Rule.** Outside the five-tier Hook/Hold Rate quality ramp, the KPI-card top-accent stripes, and the two fill-safe literals above, no color renders except black, white, gray, and the one green accent. A new surface introducing a new saturated color without a data-meaning reason breaks this system.

## Typography

**Body Font:** Archivo (weights 400/700 only), with Arial, Helvetica, sans-serif fallback — loaded via `@import url('https://fonts.googleapis.com/css2?family=Archivo:wght@400;700&display=swap')`. This is the shipped substitute for the proprietary NVIDIA-EMEA face named in the direction contract; no distinct display or mono face is used anywhere in the file. Unaffected by the dark-mode conversion.

**Character:** A bold, geometric grotesque carrying every weight of emphasis in the system — headings, KPI numbers, and badges all use the same family at 700, distinguished only by size and letter-spacing, never by a second typeface.

### Hierarchy
- **Stat/KPI Display** (700, 26–32px, tight tracking -0.5px to -1px): the large numeric readouts — `.kpi-value` (32px), `.ai-stat-val` (30px), `.hookbank-value` (30px, weight 800), `.hook-stat-val`/`.hold-stat-val` (26px).
- **Title** (700, 17–20px): page/section titles — `.logo` (18px), `.monthly-results-title` (20px), `.sidebar-logo` (17px).
- **Card Title** (600, 13–16px): `.chart-title` (13px), `.kpi-card-head` title (16px), `.creator-name` (14px, 700).
- **Body** (400, 14px, line-height 1.5): the base `body` rule; default reading size for prose and table cells.
- **Label** (600–700, 10–12.5px, tracking 0.1px–1px, frequently uppercase): `.sidebar-group-label` (10.5px, uppercase, 1px tracking), `.tab` (12.5px, 600), `.kpi-label`, `.chart-subtitle` (11px), all quality/status/pillar badges (10–11px, 700).

### Named Rules
**The Dense-Operate Rule.** This is an Operate-mode instrument, not an editorial page: functional labels (table headers, filter chips, calendar weekday abbreviations, form field labels) run 9–11.5px throughout, well below comfortable-reading size. This was a disclosed, deliberate density decision for a data-dense internal tool serving three audiences on one screen, not an oversight — see Do's and Don'ts for what NOT to infer from it.

## Layout

Two-region app shell: a 248px fixed black sidebar (`.sidebar`, sticky, full-height, collapses to a horizontal `.mobile-nav` scroll strip under 900px) plus a flexible `.main-area` carrying a 72px sticky black `.header` (logo + subtitle), a sticky black `.tabs` bar (segmented white pill for the active tab, plus a month `<select>`), and `.content` (max-width 1600px, centered, 40px padding, reduced under mobile breakpoints). Unaffected by the dark-mode conversion — only the surfaces inside `.content` changed color, not the shell geometry.

KPI cards sit in a 4-column grid (`.kpi-grid`, `repeat(4, 1fr)`, 16px gap, collapsing per breakpoint under 900px). Chart and data cards use `.chart-card`/`.card` at 24–32px internal padding. Spacing steps observed: 16px (grid gap), 24px (card padding, small), 28px (KPI card padding), 32px (chart card padding), 40px (section margin, content padding). No fractional or unusual off-scale spacing values were found.

## Elevation & Depth

The system is flat at rest: `.card`, `.kpi-card`, and `.chart-card` carry only a 1px hairline border, no shadow, at rest. The one shadow token, `--shadow: 0 0 5px rgba(0,0,0,0.6)` (opacity raised from the light build's `0.3` since a black shadow needs more density to read against an already-dark `#1a1a1a` surface), appears in two contexts as actually shipped: (1) open modals and dialogs (calendar entry, creative job order, reassign, and all confirm dialogs), matching the direction contract's "real elevation" intent, and (2) as a hover-response on interactive cards and every primary button (`.kpi-card:hover`, `.hookbank-card:hover`, `#generateBtn:hover`) alongside a small `translateY` lift. This second use is a mild extension beyond the contract's literal "modals/menus only" wording, but it is consistent with the system's own logic — the shadow still only ever appears as a response to a state change (open, hover), never at rest — so it is recorded here as the actual rule rather than repaired to match the stricter original wording.

### Shadow Vocabulary
- **Interaction shadow** (`box-shadow: 0 0 5px rgba(0,0,0,0.6)`): the only shadow in the system. Used on hover-lift for `.kpi-card`, `.hookbank-card`, and every primary button, and on all open modal/dialog surfaces.

### Named Rules
**The Flat-at-Rest Rule.** No card, panel, or button carries a shadow in its default state. Shadow is always a response to open/hover, never a resting decoration.

## Shapes

Corner radius is fixed at 2px (`--radius` / `--radius-sm`, both `2px`) across every rounded element in the file — cards, buttons, badges, inputs, chips, the active-tab pill. No larger radius value exists anywhere in the stylesheet; this directly replaces the incumbent's 14–24px rounded-everything system named in the direction contract. Borders are hairline 1px throughout (`rgba(255,255,255,0.12)`, strengthening to `rgba(255,255,255,0.22)` on hover/emphasis) — uniform now across chrome and card surfaces, since both are dark. The one exception to hairline weight is the active sidebar item and rank-1 badge, which use a 1–2px solid accent-green border to mark state, not decoration.

## Components

### Buttons
- **Shape:** 2px radius (`--radius`), 1–2px border, no fill by default.
- **Primary:** transparent background, **white** text (flipped from the light build's black text), 2px solid `#76b900` border, `11px 24px` padding, 13px/700 label type (e.g. `#generateBtn` "Generate Insights", `+ Add to Calendar`, `Save to Sheet`). Icon-in-button uses the shared inline-SVG icon set at 1em, inheriting the white text color via `currentColor`.
- **Hover / Focus:** opacity dims to 0.92, `translateY(-1px)` lift, interaction shadow applied; disabled state drops to 0.5 opacity with `cursor: not-allowed`.
- **Self-contained exceptions:** a few controls (the sub-tab active pill in AI Insights/Tech News/Weekly Topics, the "All Year" month pill, `.tab.active`) deliberately keep an explicit **white background + black text** pairing regardless of the surrounding dark surface — these are self-contained (their own bg and text both hardcoded together) and were left as-is because white-on-white-bg is always maximum contrast; do not "fix" these to dark-on-dark, they are not a token miss.

### Chips / Badges
- **Style:** tinted background at 10% opacity of the semantic color, 1px border at 20% opacity of the same color, text in the full-strength semantic color, 2px radius, 10–10.5px/700 type, `3px 9–10px` padding.
- **State:** no interactive/selected state — these are read-only status indicators (pillar tags, win/AI tags, quality-tier badges, chart-status badges), not filter controls.
- **Solid-fill exception:** the sidebar "overdue creative jobs" count badge is a solid fill (not a tint) with white text — see Colors → The Text-Safe vs Fill-Safe Split Rule for why it keeps darker, non-brightened literals.

### Cards / Containers
- **Corner Style:** 2px radius throughout.
- **Background:** near-black (`--card`/`--surface`, `#1A1A1A`).
- **Shadow Strategy:** flat at rest; interaction shadow on hover only (see Elevation & Depth).
- **Border:** 1px hairline (`rgba(255,255,255,0.12)`), strengthening to `rgba(255,255,255,0.22)` on hover.
- **Internal Padding:** 24px (`.card`), 28px (`.kpi-card`), 32px (`.chart-card`).
- **Signal stripe:** `.kpi-card` carries a 2px colored top border (`::before`) keyed to its semantic role (cyan/purple/green/orange/pink/yellow) — a decorative-but-role-coded accent unique to KPI cards, using the same brightened semantic tokens as everywhere else.

### Inputs / Fields
- **Style:** surface background (`#1A1A1A`/`#242424`), 1px border (`--border2` at rest), 2px radius, 12px/600 type, `9px 16px` padding (e.g. `.tabs select`, `#monthSelect`). Text is white.
- **Focus:** border shifts to solid accent green (`border-color: var(--accent)`) — no glow, no ring, consistent with the flat/hairline system.

### Navigation
- **Sidebar:** true-black background, 12.5px/400 items in chrome-text3 gray by default; hover shifts to chrome-text2 with a faint white-on-black background tint; the active item gets full chrome-text white, 700 weight, and a 1px solid accent-green border (no fill) — the sidebar's only use of color. Collapses to a horizontal `.mobile-nav` scroll strip under 900px using the same active-border convention. Unaffected by the dark-mode conversion — the sidebar was always black chrome.
- **Tabs:** a white segmented pill (`.tabs > div:first-child`) sits on the black tabs bar; the active tab becomes a solid white/black pill (`.tab.active`), inactive tabs are gray text on transparent — see Buttons → self-contained exceptions.

### Status Dots & Rank Badges (signature components)
- **Status dot** (`.dot`, 8px circle): five fixed color roles — red (`.dot-red`, `#ff5c5c`), orange (`.dot-orange`, `#df6500`), idle gray (`.dot-idle`, `#a7a7a7`), green (`.dot-green`, `#5cb800`), blue (`.dot-blue`, `#4d9fff`) — used for at-a-glance status in tables/lists without a text label. Dots have no text-contrast requirement (no text inside), so they simply track whatever the current semantic token is.
- **Rank badge** (`.rank-badge`): an 18px min-width white chip with a 1px gray border (`#5e5e5e`), 700/11px black text, used for leaderboard rank numbers — self-contained (own white background), unaffected by the surrounding surface color. Rank 1 gets a 2px solid accent-green border and green text instead of the default gray/black. The separate `.top10-rank-badge` (gold/silver/bronze over a `rgba(0,0,0,0.85)` chip on video thumbnails) uses lightened gold/silver/bronze text (`#ffcb66`/`#d4d4d4`/`#e0a877`) chosen specifically for that dark chip — also self-contained and unaffected by the page-level dark conversion, since it was always dark.

## Do's and Don'ts

### Do:
- **Do** keep the accent (`#76b900`) reserved for active/focus/primary-border states; it is now also safe to use directly as text on the dark surface — no darkened stand-in needed.
- **Do** keep the 2px radius and 1px hairline-border convention on every new card, button, chip, or input; there is no larger radius anywhere in the shipped system.
- **Do** use the five-tier quality ramp (green/cyan/purple/yellow/red, all brightened for this dark build) whenever a new surface needs to communicate a graded quality/performance signal — it is the one sanctioned exception to the single-accent rule because it carries real data meaning.
- **Do** treat the interaction shadow (`0 0 5px rgba(0,0,0,0.6)`) as a state response only: hover-lift or an open modal, never a resting card or button.
- **Do** render every icon as an inline SVG from the shared 24x24, `stroke="currentColor"`, `stroke-width="1.75"`, round-cap/join set — this is the only icon system in the file.
- **Do** keep the two fill-safe literals (`#e52020`, `#0046a4`) exactly as darker, untokenized exceptions on the one solid-fill badge that needs them — see Colors → The Text-Safe vs Fill-Safe Split Rule.

### Don't:
- **Don't** reintroduce gradients, glassmorphism blur, or radii above 2px — these were the explicitly rejected incumbent visual system and none remain in the shipped CSS.
- **Don't** treat the 9–11.5px functional label sizes (table headers, filter chips, calendar weekday labels) as a defect to silently "fix" by bumping type size on a new surface; it's a disclosed, accepted density characteristic of this specific Operate-mode dashboard, not a system-wide minimum to violate or a virtue to expand into a general design principle.
- **Don't** treat the plain Unicode checkmark (✓) still used in a handful of transient save/copy toast `textContent` strings as the icon convention — the actual convention is the inline-SVG set; the checkmark is a known, disclosed leftover in low-visibility transient text, not a pattern to extend.
- **Don't** brighten the two fill-safe literals (`#e52020`, `#0046a4`) to match `--red`/`--cyan` — they are darker on purpose, for white text on a solid fill, and brightening them would silently reintroduce a contrast failure (verified: white on `#ff5c5c` ≈ 3:1, fails; white on `#e52020` ≈ 4.6:1, passes).
- **Don't** assume "dark mode" here means a toggle or a `prefers-color-scheme` branch — there is no light mode left in this file to toggle back to; this is a from-code-shipped permanent replacement of the surface color, not a theme switch.
