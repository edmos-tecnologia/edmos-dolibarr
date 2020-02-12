FROM php:apache

ENV HOST_USER_ID 33
ENV PHP_INI_DATE_TIMEZONE 'UTC'

ENV DOLI_VERSION 10.0.6

ENV DOLI_DB_TYPE mysqli
ENV DOLI_DB_HOST db
ENV DOLI_DB_PORT 3306
ENV DOLI_DB_USER dolibarr
ENV DOLI_DB_PASSWORD dolibarr
ENV DOLI_DB_NAME dolibarr
ENV DOLI_DB_PREFIX llx_
ENV DOLI_DB_CHARACTER_SET utf8
ENV DOLI_DB_COLLATION utf8_unicode_ci

ENV DOLI_DB_ROOT_LOGIN ''
ENV DOLI_DB_ROOT_PASSWORD ''

ENV DOLI_ADMIN_LOGIN admin
ENV DOLI_MODULES ''

ENV DOLI_URL_ROOT 'http://localhost'

ENV DOLI_AUTH dolibarr

ENV DOLI_LDAP_HOST 127.0.0.1
ENV DOLI_LDAP_PORT 389
ENV DOLI_LDAP_VERSION 3
ENV DOLI_LDAP_SERVERTYPE openldap
ENV DOLI_LDAP_LOGIN_ATTRIBUTE uid
ENV DOLI_LDAP_DN ''
ENV DOLI_LDAP_FILTER ''
ENV DOLI_LDAP_ADMIN_LOGIN ''
ENV DOLI_LDAP_ADMIN_PASS ''
ENV DOLI_LDAP_DEBUG false

ENV DOLI_HTTPS 0
ENV DOLI_PROD 0
ENV DOLI_NO_CSRF_CHECK 0

ENV PHP_INI_DATE_TIMEZONE 'Europe/Paris'
ENV PHP_MEMORY_LIMIT 256M
ENV PHP_MAX_UPLOAD 20M
ENV PHP_MAX_EXECUTION_TIME 300

#RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libldap2-dev libzip-dev zlib1g-dev libicu-dev g++\
#	&& rm -rf /var/lib/apt/lists/* \
	#&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
#	&& docker-php-ext-install gd \
#	&& docker-php-ext-install zip \
#	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
#        && docker-php-ext-install ldap \
#        && docker-php-ext-install mysqli \
#        && docker-php-ext-install calendar \
#        && docker-php-ext-configure intl \
#        && docker-php-ext-install intl \
#        && apt-get autoremove --purge -y libjpeg-dev libldap2-dev zlib1g-dev libicu-dev g++

RUN apk add --no-cache \
		bash \
		openssl \
		rsync \
		apache2 \
		php7-apache2 \
		php7-session \
		php7-mysqli \
		php7-pgsql \
		php7-ldap \
		php7-mcrypt \
		php7-openssl \
		php7-mbstring \
		php7-intl \
		php7-gd \
		php7-imagick \
		php7-soap \
		php7-curl \
		php7-calendar \
		php7-xml \
		php7-zip \
		php7-tokenizer \
		php7-simplexml \
		php7 \
		mariadb-client \
		postgresql-client \
		unzip \
	; \

RUN mkdir /var/documents
RUN chown www-data /var/documents

COPY docker-run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-run.sh

COPY htdocs/ /var/www/html

#RUN pecl install xdebug && docker-php-ext-enable xdebug
#RUN echo 'zend_extension="/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so"' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.remote_autostart=0' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.default_enable=0' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.remote_host=docker.host' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.remote_connect_back=0' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.profiler_enable=0' >> /usr/local/etc/php/php.ini
#RUN echo 'xdebug.remote_log="/tmp/xdebug.log"' >> /usr/local/etc/php/php.ini
RUN echo '172.17.0.1 docker.host' >> /etc/hosts

EXPOSE 80

ENTRYPOINT ["docker-run.sh"]
