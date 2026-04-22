# FOREST

A personal live stock portfolio tracker. Public stocks with live quotes, private angel investments with valuation history, in one view.

## Why I built this

I was tired of stitching my portfolio together across a brokerage app, a notes file for angel checks, and a spreadsheet for valuations. I wanted one screen that tells me what I own, what it's worth right now, and how today went — without handing my holdings to another SaaS.

## What it does

**Summary** — total invested, current value, total earnings ($ and %), today's net change ($ and %) across everything you own.

**Holdings** — public and private positions mixed, sorted by current value, with per-row today's change for the public ones.

**Detail page** — tap any holding. For public stocks: ticker, current price vs average cost basis, shares, total cost, current value, gain $/%, today's change, and every lot you bought. For private investments: total invested, latest valuation, gain $/%, the timeline of valuation rounds, and every invest event.

**Add flow** — toggle Public or Private. Public takes a pasted table (Ticker, Shares, Cost, Date), tab- or comma-separated, one row per lot. Or upload a holdings PDF from **Morgan Stanley**, **Fidelity**, **Schwab**, or **Robinhood** and Forest will parse your positions into draft rows for you to review. Private takes a single form.

**Live quotes** — Finnhub under the hood. Manual refresh button plus auto-refresh every 5 minutes while the tab is open.

## Stack

- Vanilla HTML/JS — single file, no build step
- Hosted on GitHub Pages
- Supabase for auth (magic link), database, and row-level security
- Finnhub free tier for live quotes
- IBM Plex Mono

## Setup

1. Create a free project at [supabase.com](https://supabase.com).
2. Open the Supabase SQL editor and run `schema.sql`.
3. Grab a free API key at [finnhub.io](https://finnhub.io).
4. Open `index.html` and fill in the three constants at the top of the `<script>` block:
   ```js
   const SUPA_URL    = 'https://YOUR-PROJECT.supabase.co';
   const SUPA_KEY    = 'YOUR-SUPABASE-ANON-OR-PUBLISHABLE-KEY';
   const FINNHUB_KEY = 'YOUR-FINNHUB-API-KEY';
   ```
   The Supabase anon/publishable key is safe to expose — row-level security is what actually protects the data.
5. In Supabase → Authentication → URL Configuration, add your GitHub Pages URL to the allowed redirect list.
6. Push to GitHub, then Settings → Pages → Source: `main` branch, root.

No build process. No subscriptions.

## Schema

Three tables, all with RLS (`auth.uid() = user_id`):

- `investments` — one row per thing you own. `kind` is `public` or `private`.
- `lots` — one row per buy event. For public lots, `shares` and `cost_basis_per_share` are populated. For private invest events, only `cost_basis_total` is required.
- `valuations` — one row per valuation round (private only). Date, amount, round name, notes.

## Scope (v1)

- No dividends
- No splits
- No sell events — buys and valuations only
- Today's change is computed live from Finnhub (current vs previous close), not from a stored snapshot
