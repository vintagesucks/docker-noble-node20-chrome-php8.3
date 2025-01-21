FROM ubuntu:noble
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# install essential packages, repos, Node.js, Yarn and Google Chrome
RUN apt update && apt install -y --no-install-recommends \
    curl \
    gpg-agent \
    software-properties-common \
  && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
  && LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php \
  && apt update && apt install -y --no-install-recommends \
    git \
    nodejs \
    xvfb \
  && corepack enable \
  && curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt install -y ./google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb \
  && apt autoremove && apt clean \
  # smoke tests
  && node --version \
  && npm --version \
  && yarn --version

# install PHP and Composer
ENV PHP_VERSION 8.3.16-*
RUN apt update && apt install -y --no-install-recommends \
    php8.3-bcmath=$PHP_VERSION \
    php8.3-curl=$PHP_VERSION \
    php8.3-fpm=$PHP_VERSION \
    php8.3-gd=$PHP_VERSION \
    php8.3-intl=$PHP_VERSION \
    php8.3-mbstring=$PHP_VERSION \
    php8.3-mysql=$PHP_VERSION \
    php8.3-redis=6.* \
    php8.3-sqlite3=$PHP_VERSION \
    php8.3-xml=$PHP_VERSION \
    php8.3-zip=$PHP_VERSION \
  && apt autoremove && apt clean \
  && curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer \
  # smoke tests
  && [[ $(php --version) == *"PHP 8.3"* ]] \
  && composer --version
