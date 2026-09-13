---
name: EasyPC Content Dashboard
description: A hard-edged black/white performance instrument with one green signal accent, built for a single static index.html.
colors:
  black-chrome: "#000000"
  white-surface: "#FFFFFF"
  surface2: "#F5F5F5"
  border-hairline: "rgba(0,0,0,0.12)"
  border-hairline-strong: "rgba(0,0,0,0.22)"
  chrome-border: "rgba(255,255,255,0.14)"
  text-primary: "#000000"
  text-secondary: "#757575"
  chrome-text: "#FFFFFF"
  chrome-text2: "#a7a7a7"
  chrome-text3: "#898989"
  nvidia-green: "#76b900"
  nvidia-green-light: "#bff230"
  accent-text: "#4d7a00"
  cyan-info: "#0046A4"
  purple: "#4d1368"
  green-success: "#3f8500"
  orange: "#df6500"
  pink: "#8c1c55"
  yellow: "#ef9100"
  yellow-text: "#b35400"
  red-alert: "#e52020"
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
    textColor: "#000000"
    typography: "{typography.label}"
    rounded: "{rounded.standard}"
    padding: "11px 24px"
  sidebar-item-active:
    backgroundColor: "transparent"
    textColor: "{colors.chrome-text}"
    rounded: "{rounded.standard}"
    padding: "11px 12px"
  kpi-card:
    backgroundColor: "{colors.white-surface}"
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

**Creative North Star: "The Instrument Panel"**

The dashboard reads as a precision measuring instrument, not a decorative product page: true-black chrome (sidebar, header, tabs bar) frames true-white data surfaces (cards, tables, charts), with a single NVIDIA-green (`#76b900`) accent doing all the signaling — active nav item, focused input, primary-action border. This directly replaces an earlier dark-glass, radial-glow, heavily-rounded theme; that incumbent look is confirmed rejected by the shipped code (no gradients, no blur, no radius above 2px anywhere in the stylesheet). The Meta-brand-token reference (design.hagicode.com/designs/nvidia) was the pinned starting point, but the shipped system is not a literal copy of it: two tokens were deliberately darkened for on-white text contrast, and the type scale settled on a font the spec didn't call for.

Density is high and functional — three different audiences (contributors, the content manager, leadership) read tables, KPI cards, and calendars packed at a small type scale, and the shipped system accepted that density rather than inflating it for legibility theater. Color is otherwise reserved: outside the semantic quality-tier badges (see Colors → Named Rules), the only saturated color on any screen is the one green accent.

**Key Characteristics:**
- True-black chrome / true-white data-surface split, never mixed on the same panel.
- One accent (`#76b900`) reserved for active/focus/primary-border states only.
- A five-tier semantic color ramp (green/cyan/purple/orange-text/red) is the one deliberate exception to "one accent" — it carries real Hook Rate/Hold Rate quality meaning, not decoration.
- Flat by default: no gradients, no blur; the one shadow token appears only on hover-lift and open modals.
- 2px corner radius everywhere; no exceptions found in the shipped CSS.

## Colors

The palette is a strict two-surface system (true black / true white) plus one signal accent and a small semantic set; there is no decorative color anywhere in the shipped stylesheet.

### Primary
- **NVIDIA Green** (`#76b900`): the single accent. Used for the active sidebar item's 1px border, active-tab-adjacent focus rings, primary-button border (`#generateBtn` and `.hook-1`/rank-1 badges), and `.dot-green`/status-good indicators. Never used as a text color on white directly — see Named Rules.
- **Accent Text (darkened green)** (`#4d7a00`): a contrast-safe substitute used wherever the accent needs to render as legible text on white (e.g. `.fb-link`, the "info" chart-status-badge). The raw `#76b900` fails WCAG AA as text-on-white; this token exists specifically to carry the brand hue into text without that failure.
- **NVIDIA Green Light** (`#bff230`): a lighter accent variant present in `:root` (`--accent-light`) for accent-on-black contexts (e.g. hover glows on black chrome), not used as a text color.

### Neutral
- **True Black** (`#000000`): chrome background (sidebar, header, tabs bar, mobile nav) and primary text on white surfaces.
- **True White** (`#FFFFFF`): every data-panel surface — `.card`, `.kpi-card`, `.chart-card`, modals, the active tab pill.
- **Surface Gray** (`#F5F5F5`): secondary surface fill (`--surface2`), e.g. select-hover backgrounds.
- **Text Secondary** (`#757575`): the sole secondary-text gray on white surfaces (`--text2` and `--text3` share this value — see Named Rules).
- **Chrome Text Secondary** (`#a7a7a7`) and **Chrome Text Tertiary** (`#898989`): the two secondary grays used for text on black chrome (sidebar labels, subtitle, idle dots).
- **Hairline Border** (`rgba(0,0,0,0.12)`) and **Hairline Border Strong** (`rgba(0,0,0,0.22)`): dividers and card borders on white; strengthens on hover.
- **Chrome Border** (`rgba(255,255,255,0.14)`): dividers on black chrome (sidebar/header bottom borders).

### Semantic quality ramp (used on Hook Rate / Hold Rate tiers, chart status badges, KPI status)
- **Excellent / Good status** — Green `#3f8500` (`--green`), background tint `rgba(63,133,0,0.1)`.
- **Very Strong / info** — Cyan `#0046A4` (`--cyan`), background tint `rgba(0,70,164,0.1)`.
- **Good (mid-tier)** — Purple `#4d1368` (`--purple`), background tint `rgba(77,19,104,0.1)`.
- **Average / at-risk / warn** — rendered in the darkened **Yellow Text** `#b35400` (`--yellow-text`) over a tint of the raw `--yellow` (`#ef9100`), for the same contrast reason as Accent Text. The raw `#ef9100` is never used as text, only as the KPI-card top accent stripe.
- **Weak / behind / alert** — Red `#e52020` (`--red`), background tint `rgba(229,32,32,0.1)`.
- **Orange** (`#df6500`) and **Pink** (`#8c1c55`) appear only as KPI-card top accent stripes (`.kpi-card.orange::before`, `.kpi-card.pink::before`), not as text or badge colors.

### Named Rules
**The One Signal Rule.** `#76b900` marks exactly one thing per screen: what is active, focused, or primary. It never appears as a text color on a white surface — text-on-white uses `#4d7a00` instead.

**The Two-Gray Compromise Rule.** The white-surface system has only two grays, not three: `--text2` and `--text3` are both `#757575`. This was a deliberate accessibility trade — the NVIDIA reference's literal Gray-400 (`#898989`) fails WCAG AA as text on white, and no compliant lighter alternative was substituted, so the third tier collapsed into the second. Do not reintroduce a distinct `--text3` value without confirming it clears AA contrast on white; this is an accepted, disclosed limitation, not a target to silently "fix" by finding a third gray without re-checking contrast.

**The Semantic-Only Saturation Rule.** Outside the five-tier Hook/Hold Rate quality ramp and the KPI-card top-accent stripes, no color renders except black, white, gray, and the one green accent. A new surface introducing a new saturated color without a data-meaning reason breaks this system.

## Typography

**Body Font:** Archivo (weights 400/700 only), with Arial, Helvetica, sans-serif fallback — loaded via `@import url('https://fonts.googleapis.com/css2?family=Archivo:wght@400;700&display=swap')`. This is the shipped substitute for the proprietary NVIDIA-EMEA face named in the direction contract; no distinct display or mono face is used anywhere in the file.

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

Two-region app shell: a 248px fixed black sidebar (`.sidebar`, sticky, full-height, collapses to a horizontal `.mobile-nav` scroll strip under 900px) plus a flexible `.main-area` carrying a 72px sticky black `.header` (logo + subtitle), a sticky black `.tabs` bar (segmented white pill for the active tab, plus a month `<select>`), and `.content` (max-width 1600px, centered, 40px padding, reduced under mobile breakpoints).

KPI cards sit in a 4-column grid (`.kpi-grid`, `repeat(4, 1fr)`, 16px gap, collapsing per breakpoint under 900px). Chart and data cards use `.chart-card`/`.card` at 24–32px internal padding. Spacing steps observed: 16px (grid gap), 24px (card padding, small), 28px (KPI card padding), 32px (chart card padding), 40px (section margin, content padding). No fractional or unusual off-scale spacing values were found.

## Elevation & Depth

The system is flat at rest: `.card`, `.kpi-card`, and `.chart-card` carry only a 1px hairline border, no shadow, at rest. The one shadow token, `--shadow: 0 0 5px rgba(0,0,0,0.3)`, appears in two contexts as actually shipped: (1) open modals and dialogs (calendar entry, creative job order, reassign, and all confirm dialogs), matching the direction contract's "real elevation" intent, and (2) as a hover-response on interactive cards and the primary generate button (`.kpi-card:hover`, `.hookbank-card:hover`, `#generateBtn:hover`) alongside a small `translateY` lift. This second use is a mild extension beyond the contract's literal "modals/menus only" wording, but it is consistent with the system's own logic — the shadow still only ever appears as a response to a state change (open, hover), never at rest — so it is recorded here as the actual rule rather than repaired to match the stricter original wording.

### Shadow Vocabulary
- **Interaction shadow** (`box-shadow: 0 0 5px rgba(0,0,0,0.3)`): the only shadow in the system. Used on hover-lift for `.kpi-card`, `.hookbank-card`, and `#generateBtn`, and on all open modal/dialog surfaces.

### Named Rules
**The Flat-at-Rest Rule.** No card, panel, or button carries a shadow in its default state. Shadow is always a response to open/hover, never a resting decoration.

## Shapes

Corner radius is fixed at 2px (`--radius` / `--radius-sm`, both `2px`) across every rounded element in the file — cards, buttons, badges, inputs, chips, the active-tab pill. No larger radius value exists anywhere in the stylesheet; this directly replaces the incumbent's 14–24px rounded-everything system named in the direction contract. Borders are hairline 1px throughout (`rgba(0,0,0,0.12)` on white surfaces, `rgba(255,255,255,0.14)` on black chrome), strengthening to `rgba(0,0,0,0.22)` on hover/emphasis. The one exception to hairline weight is the active sidebar item and rank-1 badge, which use a 1–2px solid accent-green border to mark state, not decoration.

## Components

### Buttons
- **Shape:** 2px radius (`--radius`), 1–2px border, no fill by default.
- **Primary:** transparent background, black text, 2px solid `#76b900` border, `11px 24px` padding, 13px/700 label type (e.g. `#generateBtn`, "Generate Insights"). Icon-in-button uses the shared inline-SVG icon set at 1em.
- **Hover / Focus:** opacity dims to 0.92, `translateY(-1px)` lift, interaction shadow (`0 0 5px rgba(0,0,0,0.3)`) applied; disabled state drops to 0.5 opacity with `cursor: not-allowed`.

### Chips / Badges
- **Style:** tinted background at 10% opacity of the semantic color, 1px border at 20% opacity of the same color, text in the full-strength (or contrast-safe darkened) semantic color, 2px radius, 10–10.5px/700 type, `3px 9–10px` padding.
- **State:** no interactive/selected state — these are read-only status indicators (pillar tags, win/AI tags, quality-tier badges, chart-status badges), not filter controls.

### Cards / Containers
- **Corner Style:** 2px radius throughout.
- **Background:** white (`--card`/`--surface`, `#FFFFFF`).
- **Shadow Strategy:** flat at rest; interaction shadow on hover only (see Elevation & Depth).
- **Border:** 1px hairline (`rgba(0,0,0,0.12)`), strengthening to `rgba(0,0,0,0.22)` on hover.
- **Internal Padding:** 24px (`.card`), 28px (`.kpi-card`), 32px (`.chart-card`).
- **Signal stripe:** `.kpi-card` carries a 2px colored top border (`::before`) keyed to its semantic role (cyan/purple/green/orange/pink/yellow) — a decorative-but-role-coded accent unique to KPI cards.

### Inputs / Fields
- **Style:** white/surface background, 1px border (`--border2` at rest), 2px radius, 12px/600 type, `9px 16px` padding (e.g. `.tabs select`, `#monthSelect`).
- **Focus:** border shifts to solid accent green (`border-color: var(--accent)`) — no glow, no ring, consistent with the flat/hairline system.

### Navigation
- **Sidebar:** true-black background, 12.5px/400 items in chrome-text3 gray by default; hover shifts to chrome-text2 with a faint white-on-black background tint; the active item gets full chrome-text white, 700 weight, and a 1px solid accent-green border (no fill) — the sidebar's only use of color. Collapses to a horizontal `.mobile-nav` scroll strip under 900px using the same active-border convention.
- **Tabs:** a white segmented pill (`.tabs > div:first-child`) sits on the black tabs bar; the active tab becomes a solid white/black pill (`.tab.active`), inactive tabs are gray text on transparent.

### Status Dots & Rank Badges (signature components)
- **Status dot** (`.dot`, 8px circle): five fixed color roles — red (`.dot-red`), orange (`.dot-orange`), idle gray (`.dot-idle`, `#a7a7a7`), green (`.dot-green`), blue (`.dot-blue`) — used for at-a-glance status in tables/lists without a text label.
- **Rank badge** (`.rank-badge`): an 18px min-width white chip with a 1px gray border (`#5e5e5e`), 700/11px black text, used for leaderboard rank numbers; rank 1 gets a 2px solid accent-green border and green (`#3f8500`) text instead of the default gray/black, marking the single top performer.

## Do's and Don'ts

### Do:
- **Do** keep the accent (`#76b900`) reserved for active/focus/primary-border states; use `#4d7a00` (Accent Text) whenever the brand hue needs to render as legible text on a white surface.
- **Do** keep the 2px radius and 1px hairline-border convention on every new card, button, chip, or input; there is no larger radius anywhere in the shipped system.
- **Do** use the five-tier quality ramp (green/cyan/purple/yellow-text/red) whenever a new surface needs to communicate a graded quality/performance signal — it is the one sanctioned exception to the single-accent rule because it carries real data meaning.
- **Do** treat the interaction shadow (`0 0 5px rgba(0,0,0,0.3)`) as a state response only: hover-lift or an open modal, never a resting card or button.
- **Do** render every icon as an inline SVG from the shared 24x24, `stroke="currentColor"`, `stroke-width="1.75"`, round-cap/join set — this is now the only icon system in the file.

### Don't:
- **Don't** introduce a third distinct gray tier for text-on-white without checking it clears WCAG AA contrast — the system currently has only two (`#757575`) precisely because the spec's literal third gray (`#898989`) failed that check.
- **Don't** reintroduce gradients, glassmorphism blur, or radii above 2px — these were the explicitly rejected incumbent visual system and none remain in the shipped CSS.
- **Don't** treat the 9–11.5px functional label sizes (table headers, filter chips, calendar weekday labels) as a defect to silently "fix" by bumping type size on a new surface; it's a disclosed, accepted density characteristic of this specific Operate-mode dashboard, not a system-wide minimum to violate or a virtue to expand into a general design principle.
- **Don't** treat the plain Unicode checkmark (✓) still used in a handful of transient save/copy toast `textContent` strings as the icon convention — the actual convention is the inline-SVG set; the checkmark is a known, disclosed leftover in low-visibility transient text, not a pattern to extend.
