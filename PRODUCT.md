# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

Existing codebase: a single static `index.html` (vanilla JS/CSS, Chart.js for charts, MSAL.js for Microsoft sign-in), deployed as-is to Cloudflare Pages (`content-dashboard-2ki.pages.dev`). No build step, no framework. This is a fixed constraint (see Capabilities and Constraints), not a greenfield choice.

## Users

Three audiences share the same dashboard:
- **Individual contributors** (creators/designers) checking their own performance numbers and assignments.
- **A content/social media manager** who plans the content calendar, assigns creative job orders, and reviews cross-creator performance.
- **Leadership/stakeholders** who review KPI performance and content direction without doing the day-to-day data entry.

All are internal EasyPC staff, authenticated via an EasyPC Microsoft account (MSAL/Entra ID SSO gate on every page).

## Product Purpose

Tracks and improves EasyPC's video content performance (Facebook Page videos, Instagram Reels) for the content/social team. It serves two equally important jobs:
1. **Reporting** — consolidates KPI, hook rate, hold rate, pillar (Know/Like/Trust), and creator-level performance data that was previously scattered across manual Google Sheets review.
2. **Forward planning** — AI-generated performance insights, viral topic ideas, and a content/creative calendar with job-order assignment, so the team plans what to make next rather than only reviewing what already shipped.

## Positioning

Purpose-built internal tool combining Meta Graph API-synced performance data with AI-generated analysis and planning tools (topic ideation, insights, job-order tracking) in one dashboard — not a generic analytics export or a bare spreadsheet.

## Operating Context

- Data originates from Facebook Page videos and Instagram Reels via the Meta Graph API, synced into a Google Sheet ("Meta Auto-Sync" tab) by a Google Apps Script backend (`Meta Sync Backend.txt`), then read into the dashboard.
- Manual/judgment fields (creator, pillar, hook type, "AI integrated?", "authentic?") are tagged by hand since the Meta API can't supply them.
- "Winning content" is auto-computed from a views threshold.
- Content Calendar and Creative Calendar (job orders) are managed inside the dashboard and saved back to a Google Sheet.
- Confidential internal tool — the sign-in screen states "EasyPC Content Dashboard · Confidential."

## Capabilities and Constraints

- **Frontend must stay a single static HTML file** — vanilla JS/CSS, no framework migration, deployed as-is to Cloudflare Pages.
- **Backend must stay Google Sheets + Apps Script** — including the Meta Graph API sync — no backend replacement.
- Authentication is Microsoft SSO (MSAL.js) with no dev/test bypass; every session must sign in with a real EasyPC Microsoft account.
- Key terminology: Hook Rate, Hold Rate, KPI Progress vs Target, Pillar (Know/Like/Trust), Hook Bank, Content Calendar, Creative Calendar (job orders), AI Insights, Viral Topic Ideas, Tech News, Winning Content.

## Brand Commitments

Internal EasyPC tool (EasyPC / Tech It Easy). The dashboard's own established visual identity is a dark theme with blue/purple/cyan accents (distinct from EasyPC's external document house style of green/black/white) — treat this as the incumbent visual system to preserve, not replace, absent an explicit redesign request.

## Evidence on Hand

- Live deployment: `https://content-dashboard-2ki.pages.dev/`.
- Backend source: `Meta Sync Backend.txt` (Google Apps Script), `meta-sync-preview.html`.
- No customer-facing testimonials, pricing, or external marketing claims apply — this is an internal ops tool, not a marketed product.

## Product Principles

1. Reporting and planning are equally weighted — don't let one crowd out the other.
2. Preserve the single-file static frontend and Sheets/Apps Script backend; do not introduce a framework or a new backend as a side effect of design work.
3. Respect the real gate: no feature should assume a signed-in state is fake or bypassable.
4. Serve all three audiences (contributors, manager, leadership) from the same views rather than forking into separate apps.
5. Manual/judgment data (creator, pillar, hook type, authenticity) is tagged by humans, not inferred — design should make that tagging fast and low-friction, not hide it.

## Accessibility & Inclusion

No product-specific accessibility requirement was established beyond general web accessibility good practice.
