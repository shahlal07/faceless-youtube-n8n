# YouTube OAuth setup — step by step

This unlocks two things: **Phase 10** (real video upload to YouTube) and **Phase 11**
(real analytics pulled back from YouTube). Nothing in Phases 1-9 needs this — they're
all still $0/copy-paste. This is the one piece that needs your own Google account.

## 1. Create a Google Cloud project

1. Go to https://console.cloud.google.com/
2. Top-left project dropdown → **New Project**. Name it something like
   `faceless-youtube-studio`. Create it, then make sure it's selected (top-left
   dropdown shows its name).

## 2. Enable the two APIs you need

1. Go to https://console.cloud.google.com/apis/library
2. Search **YouTube Data API v3** → click it → **Enable**.
3. Search **YouTube Analytics API** → click it → **Enable**.

## 3. Configure the OAuth consent screen

1. Go to https://console.cloud.google.com/apis/credentials/consent
2. User Type: **External** (unless you have a Google Workspace org — then Internal
   is fine and skips verification entirely). Create.
3. Fill in App name (e.g. "Faceless YouTube Studio"), your email as support email
   and developer contact. Save and continue through Scopes (skip, you don't need to
   add scopes here — n8n's credential will request them at connect-time) and Test
   users.
4. **On the Test users step**: add the exact Google account email that owns (or
   manages) your YouTube channel. While the app is in "Testing" mode (the default,
   and what you'll stay in for personal use), only test users you list here can
   complete the OAuth flow.
5. Save. You'll see a warning that the app needs verification to go public — ignore
   it, you're not publishing this app, just using it yourself in Testing mode.

**Note on quota**: an unverified app in Testing mode gets YouTube Data API's default
daily quota (10,000 units — a video upload costs ~1,600 units, so roughly 6
uploads/day). That's fine for a hobby channel. If you outgrow it, Google's
verification process for the `youtube.upload` scope requires a demo video and can
take weeks — cross that bridge later if you need to.

## 4. Create OAuth 2.0 credentials

1. Go to https://console.cloud.google.com/apis/credentials
2. **Create Credentials** → **OAuth client ID**.
3. Application type: **Web application**.
4. Name it anything (e.g. "n8n").
5. **Authorized redirect URIs** — this is the one step that has to match n8n
   exactly. Add:
   ```
   https://faceless-youtube-n8n.onrender.com/rest/oauth2-credential/callback
   ```
6. Create. A dialog shows your **Client ID** and **Client Secret** — copy both
   somewhere safe (you'll paste them into n8n next, and won't be shown the secret
   again from Google's side).

## 5. Wire the credential into n8n

1. Open https://faceless-youtube-n8n.onrender.com
2. Left sidebar → **Personal** → **Credentials** → **Add Credential**.
3. Search for **YouTube OAuth2 API** and select it.
4. Paste your **Client ID** and **Client Secret** from step 4.
5. Click **Sign in with Google** (or **Connect my account**) — this opens a real
   Google login popup. Sign in with the same account you added as a test user in
   step 3, and approve the permissions. This part has to be you; I can't click
   through your own Google login on your behalf.
6. Name the credential **YouTube account** (matches what I'll reference when I wire
   Phase 10/11's nodes to it) and save.
7. Go to **Personal** → **Channels** table in Supabase (or ask me to do it) and set
   `youtube_channel_id` on the `channels` row for whichever channel you're
   connecting — Phase 10/11 need this to know which YouTube channel a Studio
   channel maps to. You can find your channel ID at
   https://www.youtube.com/account_advanced while signed into that channel.

## When you're done

Tell me, and I'll wire the **YouTube account** credential into Phase 10 and Phase
11's nodes (same pattern as every Supabase node so far) and we'll run a real,
live test together — starting with the bees video, since it already has a
`seo_metadata` row from Phase 8 ready to use.
