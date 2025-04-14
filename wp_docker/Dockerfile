FROM wordpress:latest

RUN apt-get update && apt-get install -y mariadb-server

COPY custom-theme /var/www/html/wp-content/themes/custom-theme
COPY entrypoint.sh /entrypoint.sh
COPY init-db.sql /init-db.sql

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]