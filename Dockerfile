FROM php:8.2-apache

# Sets the document root director for the webserver to 'public/'
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf


# install dependencies and cleanup (needs to be one step, as else it will cache in the layer)
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    default-jdk wget git iproute2 libcurl4-openssl-dev libxml2-dev libzip-dev zip unzip sudo \
    unzip xvfb libxi6 libgconf-2-4 jq libjq1 libonig5 libxkbcommon0 libxss1 libglib2.0-0 libnss3 \
    libfontconfig1 libatk-bridge2.0-0 libatspi2.0-0 libgtk-3-0 libpango-1.0-0 libgdk-pixbuf-2.0-0 libxcomposite1 \
    libxcursor1 libxdamage1 libxtst6 libappindicator3-1 libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libxfixes3 \
    libdbus-1-3 libexpat1 libgcc1 libnspr4 libgbm1 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxext6 \
    libxrandr2 libxrender1 gconf-service ca-certificates fonts-liberation libappindicator1 lsb-release xdg-utils \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql zip \
    && apt-get clean \
    && apt-get autoremove -y \
    && apt-get purge -y --auto-remove libcurl4-openssl-dev libjpeg-dev libpng-dev libxml2-dev libmemcached-dev \
    &&  rm -rf /var/lib/apt/lists/*


# install Chrome
RUN wget -N https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/119.0.6045.105/linux64/chrome-linux64.zip -P ~/ \
    && unzip ~/chrome-linux64.zip -d ~/ \
    && mv ~/chrome-linux64 ~/chrome \
    && ln -s ~/chrome/chrome /usr/local/bin/chrome \
    && chmod +x ~/chrome \
    && rm ~/chrome-linux64.zip
RUN wget https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/119.0.6045.105/linux64/chromedriver-linux64.zip -P ~/ \
    && unzip ~/chromedriver-linux64.zip -d /usr/local/bin/


# Install node and npm
# Installing a specific version of node directly is dificult. Use `nvm` to
# install it (which installs both `node` and `npm`)

# Set this to any desired version
ENV NODE_VERSION 20.9.0
# Can be anything, but this is a good default
ENV NVM_DIR /usr/local/nvm
# Must match one of the tag versions on https://github.com/nvm-sh/nvm/tags
ENV NVM_VERSION 0.39.5

RUN mkdir -p $NVM_DIR \
  && curl https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  && node -v \
  && npm -v \
  && npm install selenium-standalone -g \
  && selenium-standalone install

# Update the $PATH to make your installed `node` and `npm` available!
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


# configure PHP
RUN touch /usr/local/etc/php/conf.d/php.ini \
    && echo "date.timezone = Europe/Berlin" >> /usr/local/etc/php/conf.d/timezone.ini \
    && echo "memory_limit = -1" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "max_execution_time = 0" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "log_errors = On" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "error_log = /dev/null" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "xdebug.client_port = 9003" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "xdebug.output_dir = /var/www/html/log/" >> /usr/local/etc/php/conf.d/php.ini \
    && echo "xdebug.log = /dev/null" >> /usr/local/etc/php/conf.d/php.ini

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY docker-php-entrypoint /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-php-entrypoint \
    && ln -s /usr/local/bin/docker-php-entrypoint /
