#!/bin/bash

whoami
ls -ld /var/lib/postgresql/

# Grant permissions to postgres
chown postgres:postgres /var/lib/postgresql/

SSL_DIR="/var/lib/postgresql/certs"
mkdir -p "$SSL_DIR"

# Check if certificates already exist
if [ ! -f "$SSL_DIR/server.key" ] || [ ! -f "$SSL_DIR/server.crt" ] || [ ! -f "$SSL_DIR/root.crt" ]; then
    # Generate Root CA
    openssl req -new -x509 -days 820 -nodes -text -out "$SSL_DIR/root.crt" -keyout "$SSL_DIR/root.key" -subj "/CN=root-ca"

    # Generate Server Certificates
    openssl req -new -nodes -text -out "$SSL_DIR/server.csr" -keyout "$SSL_DIR/server.key" -subj "/CN=localhost"
    openssl x509 -req -in "$SSL_DIR/server.csr" -text -out "$SSL_DIR/server.crt" -CA "$SSL_DIR/root.crt" -CAkey "$SSL_DIR/root.key" -CAcreateserial

    chown postgres:postgres "$SSL_DIR/server.key"
    chmod 600 "$SSL_DIR/server.key"
fi

# PostgreSQL configuration
cat >> "$PGDATA/postgresql.conf" <<EOF
ssl = on
ssl_cert_file = '$SSL_DIR/server.crt'
ssl_key_file = '$SSL_DIR/server.key'
ssl_ca_file = '$SSL_DIR/root.crt'
EOF
