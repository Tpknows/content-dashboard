---
version: 1
slug: "index-html"
primary_target: "index.html"
related_targets: []
---

# Surface: index.html (EasyPC Content Dashboard, whole app)

## Scope & Mode

Whole dashboard (sidebar + every tab: Overview/KPI, Hook Rate, Hold Rate, Hook Bank, Content Calendar, Creative Calendar, Viral Topics, Monthly Results, AI Insights, Tech News) plus all modals (calendar entry, creative job order, reassign). Mode: **Operate** — task completion, scanability, and native/familiar affordances outrank expression.

## Audience, job, action, proof, constraints

- Audience: three groups sharing one surface — individual contributors (creators/designers) checking their numbers/assignments; the content/social manager planning the calendar and job orders; leadership reviewing KPI performance.
- Job: read performance (hook/hold rate, views, KPI vs target) and plan forward (calendar, job orders, AI topic ideas) without the two competing for attention.
- Action: filter/sort tables, open and fill calendar/job-order modals, generate/save AI insights, mark items used.
- Proof/content: real synced data (Meta Graph API → Google Sheets), no invented metrics.
- Constraints: single static `index.html` file (no framework migration), Google Sheets/Apps Script backend untouched, MSAL sign-in gate untouched, all existing JS logic/data-binding preserved — this is a visual reskin, not a functional rewrite.

## Chosen direction & memorable moment

Pinned by explicit user direction (reference: `design.hagicode.com/designs/nvidia`, an NVIDIA-inspired design-token reference), not the dice roll. `impeccable concept-seed --scope direction --mode operate` (seed key `4204843a`) assigned index 7 as its own top-ranked grounded candidate; the user's pin overrides it per the tool's own contract ("a user- or brief-pinned decision beats the roll, always"). Memorable moment: the single green accent is the only color that moves — every screen reads as calm black/white instrument until something needs the user's attention.

## Direction contract

THESIS: Replace the current dark-glass, radial-glow, heavily-rounded dashboard with a hard-edged, high-contrast operating instrument — true black and white fields carrying the data, with one green accent doing all the signaling, refusing the incumbent's soft glassmorphism and rounded-everything defaults.

OWN-WORLD: True black (`#000000`) chrome/nav surfaces, white (`#ffffff`) data-panel surfaces, black/white text pairing per surface. Single accent NVIDIA Green `#76b900` (borders, active/focus states only) plus the documented semantic set used for meaning, never decoration: Red `#e52020` (alerts/errors), Blue `#0046a4` (links/info), Gray scale `#a7a7a7 → #1a1a1a` (secondary text, hairline borders). Bold sans substitute for the proprietary NVIDIA-EMEA face (weights 400/700 only) at the documented scale: 36/24/22/20/18/16/15/14/12/10-11px roles. Corner radius 2px standard (never the incumbent's 14–24px), hairline 1px borders replacing soft drop shadows, one flat shadow (`0 0 5px rgba(0,0,0,.3)`) only for real elevation (open modals/menus). Every emoji-as-icon (🪝⏱️🎣🗓️🎨🔥📊📈✦💾☁🗑️🤖✏️🔁 etc.) is replaced by a real single-stroke SVG icon set.

STORY: A contributor, manager, or leadership viewer opens the dashboard and reads it as a precise instrument, not a decorative panel: every chart, table, and status is legible at a glance, the one green accent marks exactly what's active or actionable, and nothing decorative competes with the data.

FIRST VIEWPORT: Sidebar becomes a true-black column, white/gray-scale text, green marks the active nav item (replacing today's frosted-glass blurred sidebar). Main canvas moves from the dark radial-gradient background to a white data surface with black text and hairline dividers between panels. The Overview header keeps its title + subtitle but drops blur/soft-shadow chrome for flat, hairline-bordered panels. Primary buttons become transparent with a 2px green border per the token spec; hover/active states use the documented blue states, not a glow.

FORM: Pinned by explicit user direction (not the roll). Seed key `4204843a`, assigned index 7 (own top candidate, superseded by the pin).

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance.

## Unresolved decisions

- Exact substitute typeface for NVIDIA-EMEA (open-source, bold geometric sans) — to be chosen during build from the documented weight/scale requirements.
- Whether dark-mode charts (Chart.js) need a parallel light-mode palette or keep true-black/white per NVIDIA's two-mode surface architecture — resolved during build per section being edited.
