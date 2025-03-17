FROM wordpress:latest

# Встановлення необхідних залежностей
RUN apt-get update && apt-get install -y mariadb-server mariadb-client && rm -rf /var/lib/apt/lists/*

# Копіюємо нестандартну тему
COPY custom-theme /var/www/html/wp-content/themes/custom-theme

# Копіюємо wp-config.php
COPY wp-config.php /var/www/html/wp-config.php

# Додаємо скрипт ініціалізації БД
COPY init-db.sh /init-db.sh
RUN chmod +x /init-db.sh

# Виставляємо права
RUN chown -R www-data:www-data /var/www/html/wp-content/themes/custom-theme

# Запуск внутрішньої БД при старті контейнера
CMD service mysql start && bash /init-db.sh && apache2-foreground
