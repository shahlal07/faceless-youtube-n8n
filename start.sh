#!/bin/sh
# Render injects PORT and RENDER_EXTERNAL_HOSTNAME for every web service —
# map them into the env vars n8n actually reads, so generated webhook/form
# URLs point at the real public host instead of localhost:5678.
export N8N_PORT="$PORT"
export N8N_PROTOCOL=https
export N8N_HOST="$RENDER_EXTERNAL_HOSTNAME"
export WEBHOOK_URL="https://$RENDER_EXTERNAL_HOSTNAME/"
exec n8n start
