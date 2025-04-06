FROM wordpress:latest
USER root

# Встановлення mysql-клієнта
RUN apt-get update && \
    apt-get install -y --no-install-recommends default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/www/html/* && \
    curl -o wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf wordpress.tar.gz -C /var/www/html --strip-components=1 && \
    rm wordpress.tar.gz

# Копіювання необхідних файлів
COPY initial_db.sql /var/www/html/initial_db.sql
COPY custom-theme /var/www/html/wp-content/themes/
COPY wp-config.php /var/www/html/wp-config.php
COPY init-db.sh /init-db.sh
RUN chmod +x /init-db.sh

# Встановлення правильних прав для директорії з темами
RUN chown -R www-data:www-data /var/www/html/wp-content/themes/

# Повернення до менш привілейованого користувача для запуску контейнера
USER www-data

# Запуск скрипта ініціалізації бази даних і Apache
CMD ["bash", "-c", "/init-db.sh && apache2-foreground"]