# Prompts — PWA deployment bundle

This folder is a complete, installable PWA. To go live:

1. Upload these files to any static host, keeping the folder structure exactly as-is:
   - `index.html`
   - `manifest.json`
   - `service-worker.js`
   - `icons/` (4 PNGs)
2. Serve it over **HTTPS** (required for service workers) — e.g. Vercel, Netlify, Cloudflare Pages, GitHub Pages all work out of the box.
3. Open the site on a phone: browsers will offer "Add to Home Screen" / an install prompt automatically once the manifest + service worker are detected.

## What makes it fast
- **Service worker (cache-first app shell):** after the first visit, HTML/CSS/JS/icons load instantly from cache — no network round-trip, and it works offline.
- **Stale-while-revalidate for fonts:** Google Fonts are served instantly from cache while a background request quietly refreshes them for next time.
- **`preconnect` hints** to the font origins so the connection is warmed up before the stylesheet is even requested.
- **`content-visibility: auto`** on cards so the browser skips layout/paint work for cards that are off-screen.
- **Debounced search** so typing doesn't force a re-render on every keystroke.
- **No build step, no framework runtime** — it's plain HTML/CSS/JS, so there's nothing to download beyond the page itself.
- **Everything else self-contained** — no external JS libraries, minimal DOM writes (one `innerHTML` swap per render), single stylesheet, no render-blocking scripts.

## Storage
Data is stored in the browser's `localStorage`, scoped to whichever device/browser it's opened on. There's no backend by default — if you want prompts to sync across devices, wire this up to the Supabase schema provided earlier (`supabase-schema.sql`) by swapping the `load()` / `persist()` functions in `index.html` for `supabase-js` calls.

## Note on the in-chat preview
The version you see rendered inside this chat (the "stacks" artifact) runs in a sandboxed iframe that can't register a service worker or load a manifest — that preview is for design/interaction purposes only. This `index.html` bundle is the real, installable version.
