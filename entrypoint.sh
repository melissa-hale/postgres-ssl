#!/bin/bash
set -e

# Set PGPORT to 5432
export PGPORT=5432

# Call the original entrypoint script
exec /usr/local/bin/docker-entrypoint.sh "$@"

# Set PGPORT to Proxy Port
export PGPORT=$RAILWAY_TCP_PROXY_PORT
