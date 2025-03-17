#!/bin/bash
if [ "$MYSQL_INTERNAL" = "true" ]; then
    service mysql start

    # Перевіряємо, чи БД вже ініціалізована
    if [ ! -d "/var/lib/mysql/wordpress" ]; then
        mysql -u root -e "CREATE DATABASE wordpress;"
        mysql -u root -e "CREATE USER 'wordpress'@'%' IDENTIFIED BY 'password';"
        mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';"
        mysql -u root -e "FLUSH PRIVILEGES;"

        # Імпортуємо початковий SQL, якщо потрібно
        if [ -f /var/www/html/initial_db.sql ]; then
            mysql -u root wordpress < /var/www/html/initial_db.sql
        fi
    fi
fi

exec "$@"
