#!/bin/bash

# Якщо змінна MYSQL_ROOT_PASSWORD не передана - беремо значення за замовчуванням
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-rootpassword}

echo "Перевіряємо, чи потрібно ініціалізувати базу даних..."

# Цикл очікування, поки MySQL (db) не стане доступним
until mysql -h db -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" &>/dev/null; do
    echo "Очікуємо запуск MySQL..."
    sleep 2
done

echo "База даних доступна, продовжуємо..."

# Перевіряємо, чи є таблиця wp_options у базі wordpress
TABLE_EXISTS=$(mysql -h db -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE wordpress; SHOW TABLES LIKE 'wp_options';" 2>/dev/null | grep "wp_options" | wc -l)

if [ "$TABLE_EXISTS" -eq 0 ]; then
    echo "Таблиці WordPress відсутні. Створюємо..."
    # Створюємо базу, якщо її немає
    mysql -h db -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS wordpress;"
    # Створюємо користувача, якщо він не існує
    mysql -h db -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED BY 'password';"
    # Надаємо всі права
    mysql -h db -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';"
    mysql -h db -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

    # Якщо існує дамп initial_db.sql, імпортуємо його
    if [ -f /var/www/html/initial_db.sql ]; then
        echo "Імпортуємо початкові дані..."
        mysql -h db -u root -p"$MYSQL_ROOT_PASSWORD" --binary-mode=1 wordpress < /var/www/html/initial_db.sql
        echo "Імпорт завершено!"
    else
        echo "Файл дампу initial_db.sql не знайдено, пропускаємо імпорт."
    fi
else
    echo "Таблиці WordPress вже існують, пропускаємо створення."
fi

echo "Ініціалізація завершена!"
exec "$@"
