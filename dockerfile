# Usamos una imagen base oficial de PHP 7.4 con Apache
FROM php:7.4-apache

# 1. Instalar dependencias del sistema (He añadido las necesarias para gd, intl y zip)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libaio1 \
    libxml2-dev \
    unzip \
    wget \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libicu-dev \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# 2. Copiar archivos de Oracle y el driver local
COPY instantclient-basic-linux.x64-19.6.0.0.0dbru.zip /tmp/
COPY instantclient-sdk-linux.x64-19.6.0.0.0dbru.zip /tmp/
COPY oci8-2.2.0.tgz /tmp/oci8-2.2.0.tgz

# 3. Configurar e instalar Oracle Instant Client
RUN mkdir -p /opt/oracle \
    && unzip /tmp/instantclient-basic-linux.x64-19.6.0.0.0dbru.zip -d /opt/oracle \
    && unzip /tmp/instantclient-sdk-linux.x64-19.6.0.0.0dbru.zip -d /opt/oracle \
    && mv /opt/oracle/instantclient_19_6 /opt/oracle/instantclient \
    && echo "/opt/oracle/instantclient" > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig

# 4. Configurar el entorno para que OCI8 encuentre a Oracle
ENV LD_LIBRARY_PATH="/opt/oracle/instantclient"
ENV ORACLE_HOME="/opt/oracle/instantclient"

# 5. Configurar e instalar la extensión OCI8 correctamente
# La variable PHP_OCI8_INSTANTCLIENT le dice a pecl exactamente dónde mirar
RUN export PHP_OCI8_INSTANTCLIENT=/opt/oracle/instantclient \
    && echo "instantclient,/opt/oracle/instantclient" | pecl install /tmp/oci8-2.2.0.tgz \
    && docker-php-ext-enable oci8 \
    && rm /tmp/oci8-2.2.0.tgz /tmp/instantclient-*.zip

# 6. Instalar extensiones adicionales
# Hemos añadido --with-gd para asegurar que encuentre las librerías de imagen
RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install pdo_mysql gd exif intl zip

# 7. Descargar y preparar el código de OwnCloud
RUN wget https://download.owncloud.com/server/stable/owncloud-complete-latest.zip -O /tmp/owncloud.zip \
    && unzip /tmp/owncloud.zip -d /var/www/html/ \
    && chown -R www-data:www-data /var/www/html/owncloud

# 8. Exponer puerto y configurar entrada
EXPOSE 80

CMD ["apache2-foreground"]
