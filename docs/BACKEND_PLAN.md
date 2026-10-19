# Backend Plan — Supabase + Vercel (recommended)

This plan is targeted for the Helper note-capture app MVP and covers persistence, auth, sync, and secure OpenAI integration.

Why this stack
- Supabase provides Postgres + Auth + Storage and is easier to migrate from than proprietary BaaS.
- Vercel serverless functions give an easy place to hold secrets (OpenAI key), run transforms, and offer custom endpoints.

Architecture overview
- iOS client: SwiftUI + local persistence (Core Data or SQLite/GRDB) for offline-first UX.
- Supabase Postgres: main source of truth for notes and user metadata.
- Vercel functions: authenticated server-side endpoints to call OpenAI, perform enrichment (summaries/tags), and other business logic.

Core API endpoints (examples)
- POST /api/notes
  - Request: { user_id, id, content, updated_at }
  - Upserts a note for the user.
- GET /api/notes?since=TIMESTAMP
  - Returns notes updated since TIMESTAMP (for incremental sync).
- PATCH /api/notes/:id
  - Update metadata or content.
- POST /api/openai/enrich
  - Server-side proxy: accepts note id or raw text, calls OpenAI with server-side key, returns enrichment (summary, tags).

Supabase schema (simple)

CREATE TABLE notes (
  id uuid PRIMARY KEY,
  user_id uuid REFERENCES auth.users(id),
  content text NOT NULL,
  updated_at timestamptz DEFAULT now(),
  is_deleted boolean DEFAULT false
);

Sync strategy (MVP)
- Local-first: persist notes to a local DB (Core Data / SQLite) immediately.
- Background sync: on app foreground or network restoration, push local changes to Supabase via /api/notes and pull remote changes since last sync timestamp.
- Conflict resolution: last-write-wins on updated_at for MVP. Introduce per-field merge later if needed.

Auth
- Use Supabase Auth and enable Sign In with Apple for App Store compliance.
- Store the Supabase session token in iOS Keychain; refresh tokens in client or use Vercel endpoints to refresh.

OpenAI integration
- Never call OpenAI directly from the iOS client.
- Create a Vercel serverless endpoint (/api/openai/enrich) that accepts a note id or text, validates the requesting user's auth (via Supabase JWT), and calls OpenAI. The server returns the result to the client and optionally writes enrichments back to Supabase.

Security & cost considerations
- Rate-limit OpenAI calls on the server. Use job queues or ephemeral caching for repeated requests.
- Monitor reads/writes to Supabase. Batch sync operations when possible to reduce RPCs.

Next steps for backend MVP
1. Create a Supabase project and enable Sign In with Apple.
2. Implement simple REST endpoints (Vercel functions) that authenticate and upsert/get notes.
3. Implement a minimal client sync flow that pushes local notes and pulls updates.
4. Add an OpenAI proxy endpoint behind server-side auth.
