# faceless-youtube-n8n

Self-hosted n8n, deployed on Render's **free** web service plan, for orchestrating
the [faceless-youtube-studio](https://github.com/shahlal07/faceless-youtube-studio)
pipeline per `/spec/01-ARCHITECTURE.md`.

## Known limitation — read before relying on this

Render's free plan has **no persistent disk**. n8n's default SQLite store (your
imported workflows + encrypted credentials) lives in the container's local
filesystem and is wiped on every redeploy, and possibly when the free instance
is recycled after extended inactivity. This deploy gets you a reachable n8n
editor to import and test workflows — it is **not** yet safe to treat as your
system of record for credentials or workflow history.

Before Phase 2+ depends on this instance, point n8n at a real Postgres database
(`DB_TYPE=postgresdb` and the `DB_POSTGRESDB_*` env vars) instead of the SQLite
default — e.g. a dedicated schema in the same Supabase project this pipeline
already uses, so no new paid service is needed.

## What's here

- `package.json` — installs `n8n` from npm (no Docker, so this works with a
  plain Node buildpack).
- `start.sh` — maps Render's injected `PORT` / `RENDER_EXTERNAL_HOSTNAME` into
  the env vars n8n needs (`N8N_PORT`, `N8N_HOST`, `WEBHOOK_URL`) so generated
  webhook and form URLs point at the real public host.

## Login

Basic auth is enabled (`N8N_BASIC_AUTH_ACTIVE=true`) since this is a public
URL on the free plan — do not disable it without putting some other access
control in front of the editor. Credentials are set as Render env vars, not
committed here.
