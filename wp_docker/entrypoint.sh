#!/bin/bash
set -e

if [ "$USE_INTERNAL_DB" = "true" ]; then
    echo "Start MariaDB in the background..."
    #mkdir -p /run/mysqld
    #chown -R mysql:mysql /run/mysqld

    mysqld_safe --datadir=/var/lib/mysql --bind-address=0.0.0.0 &

    echo "Waiting for MariaDB to become available..."
    for i in {1..30}; do
        if mysqladmin ping -uroot --silent; then
            echo "MariaDB is up!"
            break
        fi
        echo "MariaDB not ready yet... ($i)"
        sleep 2
    done

    if ! mysqladmin ping -uroot --silent; then
        echo "MariaDB failed to start"
        exit 1
    fi

    echo "Setting root password for MariaDB..."
    mysqladmin -u root password rootpass || true

    echo "Checking if WordPress table (wp_options) exists..."
    TABLE_EXISTS=$(mysql -uroot -prootpass --protocol=tcp -e "USE ${WORDPRESS_DB_NAME}; SHOW TABLES LIKE 'wp_options';" 2>/dev/null | grep "wp_options" | wc -l)

    if [ "$TABLE_EXISTS" -eq 0 ]; then
        echo "Table not found — initializing database..."

        mysql -uroot -prootpass --protocol=tcp -e "CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME};"

        echo "Creating WordPress DB user '${WORDPRESS_DB_USER}'@'%'..."
        mysql -uroot -prootpass --protocol=tcp -e "CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';"
        mysql -uroot -prootpass --protocol=tcp -e "GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${WORDPRESS_DB_USER}'@'%';"
        mysql -uroot -prootpass --protocol=tcp -e "FLUSH PRIVILEGES;"

        if [ -f /init-db.sql ]; then
            echo "Importing SQL dump..."
            mysql -uroot -prootpass --protocol=tcp ${WORDPRESS_DB_NAME} < /init-db.sql
        else
            echo "init-db.sql not found — skipping import."
        fi
    else
        echo "Table wp_options already exists — skipping import."
    fi

    export WORDPRESS_DB_HOST=127.0.0.1:3306
else
    echo "Connecting to external database at $WORDPRESS_DB_HOST"
fi

echo "Starting WordPress..."
docker-entrypoint.sh apache2-foreground

echo "Done."
