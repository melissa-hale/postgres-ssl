FROM postgres:latest

# Install OpenSSL
RUN apt-get update && apt-get install -y openssl

# Add our init script
COPY init-ssl.sh /docker-entrypoint-initdb.d/

# Set permissions
RUN chmod +x /docker-entrypoint-initdb.d/init-ssl.sh

# set user to postgres to allow running entrypoint
USER postgres