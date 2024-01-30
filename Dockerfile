FROM postgres:latest

# Install OpenSSL and sudo
RUN apt-get update && apt-get install -y openssl sudo

# Allow the postgres user to execute certain commands as root without a password
RUN echo "postgres ALL=(root) NOPASSWD: /usr/bin/mkdir, /bin/chown" > /etc/sudoers.d/postgres

# Add scripts
COPY init-ssl.sh /docker-entrypoint-initdb.d/
COPY set-config.sh /docker-entrypoint-initdb.d/
COPY wrapper.sh /usr/local/bin/wrapper.sh

# Add cert conf, required to generate v3 certs
COPY ssl-extensions.conf /etc/ssl/certs/

# Set permissions
RUN chmod +x /docker-entrypoint-initdb.d/init-ssl.sh
RUN chmod +x /docker-entrypoint-initdb.d/set-config.sh
RUN chmod +x /usr/local/bin/wrapper.sh

ENTRYPOINT ["wrapper.sh"]
CMD ["postgres", "--port=5432"]
