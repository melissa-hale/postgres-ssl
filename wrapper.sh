#!/bin/bash

# unset PGHOST to force psql to use Unix socket path
# this is specific to Railway and allows
# us to use PGHOST after the init
unset PGHOST
unset PGPORT

# Call the entrypoint script with the
# approriate PGHOST
/docker-entrypoint.sh "$@"
