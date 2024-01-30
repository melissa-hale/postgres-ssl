FROM postgres:latest

# Install OpenSSL and sudo
RUN apt-get update && apt-get install -y openssl sudo

# Allow the postgres user to execute certain commands as root without a password
RUN echo "postgres ALL=(root) NOPASSWD: /usr/bin/mkdir, /bin/chown" > /etc/sudoers.d/postgres

# Add your init script
COPY init-ssl.sh /docker-entrypoint-initdb.d/
COPY ssl-extensions.conf /etc/ssl/certs/
COPY wrapper.sh /usr/local/bin/wrapper.sh

# Set permissions
RUN chmod +x /docker-entrypoint-initdb.d/init-ssl.sh
RUN chmod +x /usr/local/bin/wrapper.sh

ENTRYPOINT ["wrapper.sh"]
CMD ["postgres", "--port=5432"]
