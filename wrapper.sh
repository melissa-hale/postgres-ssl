#!/bin/bash

# Ensure necessary environment variables are available
SSL_DIR="/var/lib/postgresql/data/certs"
INIT_SSL_SCRIPT="/usr/local/bin/init-ssl.sh"

# Check if certificates need to be regenerated
if [ "$REGENERATE_CERTS" = "true" ] || [ ! -f "$SSL_DIR/server.key" ] || [ ! -f "$SSL_DIR/server.crt" ] || [ ! -f "$SSL_DIR/root.crt" ]; then
    echo "Running init-ssl.sh to generate new certificates..."
    bash "$INIT_SSL_SCRIPT"
else
    echo "Certificates already exist and REGENERATE_CERTS is not set to true. Skipping certificate generation."
fi

# Unset PGHOST and PGPORT to force psql to use Unix socket path
unset PGHOST
unset PGPORT

# Call the entrypoint script with the appropriate arguments
exec /usr/local/bin/docker-entrypoint.sh "$@"
