FROM postgres:latest

# Install OpenSSL
RUN apt-get update && apt-get install -y openssl

# set user to postgres to allow running entrypoint
USER postgres

# Add our init script
COPY init-ssl.sh /docker-entrypoint-initdb.d/

# Set permissions
RUN chmod +x /docker-entrypoint-initdb.d/init-ssl.sh
