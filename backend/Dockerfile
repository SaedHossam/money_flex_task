# Use CLI instead of FPM since we're not using Nginx
FROM php:8.2-cli  

# Install system dependencies + PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    unzip \
    && docker-php-ext-install pdo pdo_mysql mbstring zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy only composer files first (for caching)
COPY composer.json composer.lock ./
RUN composer install --no-interaction --no-scripts

# Copy the rest of the app
COPY . .

# Fix Laravel permissions (optional but recommended)
RUN chmod -R 775 storage bootstrap/cache

# Generate Laravel key (if .env doesn't exist)
RUN if [ ! -f ".env" ]; then cp .env.example .env && php artisan key:generate; fi

# Start Laravel development server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]