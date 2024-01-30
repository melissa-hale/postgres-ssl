#!/bin/bash
set -e

# Set default values for environment variables if they are not set
: ${MAX_CONNECTIONS:=150}
: ${SHARED_BUFFERS:="128MB"}
: ${CONNECTION_CHECK_INTERVAL:=0}

# Use SQL commands to set the configurations
psql -U postgres -c "ALTER SYSTEM SET client_connection_check_interval = ${CONNECTION_CHECK_INTERVAL};"
psql -U postgres -c "ALTER SYSTEM SET max_connections = ${MAX_CONNECTIONS};"
psql -U postgres -c "ALTER SYSTEM SET shared_buffers = '${SHARED_BUFFERS}';"

# Reload the PostgreSQL configuration
psql -U postgres -c "SELECT pg_reload_conf();"
