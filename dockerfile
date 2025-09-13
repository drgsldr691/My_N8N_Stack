FROM php:8.2-apache

# Install PostgreSQL extension
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# Enable Apache mod_rewrite (useful for dashboards later)
RUN a2enmod rewrite

# Copy your code
COPY ./www /var/www/html/

# Set working directory
WORKDIR /var/www/html

FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache docker-cli
USER node
