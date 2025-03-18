FROM wordpress:latest
USER root

# Встановлення mysql-клієнта, бо без нього не працюють локальні конекшини
RUN apt-get update && apt-get install -y default-mysql-client && rm -rf /var/lib/apt/lists/*

# Повторне завантаження Wordpress файлів
RUN rm -rf /var/www/html/* && \
    curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf wordpress.tar.gz -C /var/www/html --strip-components=1 && \
    rm wordpress.tar.gz

# Копіювання дампу БД
COPY initial_db.sql /var/www/html/initial_db.sql
# Копіювання нестандартної теми
COPY custom-theme /var/www/html/wp-content/themes/
# Копіювання wp-config.php
COPY wp-config.php /var/www/html/wp-config.php
# Копіювання скрипта ініціалізації
COPY init-db.sh /init-db.sh
RUN chmod +x /init-db.sh

# Встановлення правильних прав доступу до теми
RUN chown -R www-data:www-data /var/www/html/wp-content/themes/

# Повертаємося до користувача www-data (за замовчуванням в образі WordPress)
USER www-data

# Запускаємо скрипт ініціалізації бази даних, а потім Apache
CMD bash /init-db.sh && apache2-foreground
