# Start with the latest Alpine image
FROM alpine:latest

# Install necessary packages including MySQL
RUN apk --no-cache add \
    mysql \
    mysql-client \
    bash \
    tini \
    su-exec \
    tzdata

# Create MySQL data directory
RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Initialize MySQL data directory
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Copy MySQL configuration (optional, if you want to customize MySQL settings)
COPY my.cnf /etc/my.cnf

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=mydatabase
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword

# Expose MySQL port
EXPOSE 3306

# Set entrypoint
ENTRYPOINT ["/sbin/tini", "--"]

# Run MySQL server
CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql"]

# Health check (optional, to ensure MySQL is running)
HEALTHCHECK --interval=30s --timeout=10s --retries=5 \
    CMD mysqladmin ping --silent --connect-timeout=10 || exit 1
