#!/bin/bash

usermod -u $HOST_USER_ID www-data
groupmod -g $HOST_USER_ID www-data

chgrp -hR www-data /var/www/html

if [ ! -f /usr/local/etc/php/php.ini ]; then
	cat <<-EOF > /usr/local/etc/php/php.ini
		date.timezone = "${PHP_INI_DATE_TIMEZONE}"
		memory_limit = "${PHP_MEMORY_LIMIT}"
		upload_max_filesize = "${PHP_MAX_UPLOAD}"
		max_execution_time = "${PHP_MAX_EXECUTION_TIME}"
		sendmail_path = /usr/sbin/sendmail -t -i
    display_errors = Off

    zend_extension="/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so"
    xdebug.remote_autostart=0
    xdebug.remote_enable=1
    xdebug.default_enable=0
    xdebug.remote_host=docker.host
    xdebug.remote_port=9000
    xdebug.remote_connect_back=0
    xdebug.profiler_enable=0
    xdebug.remote_log="/tmp/xdebug.log"
		EOF
fi

echo "###### Creating dir /var/www/html/conf/"
rm -r /var/www/html/conf

#if [ ! -d /var/www/html/conf ]; then
	mkdir -p /var/www/html/conf
  chmod g+rwx /var/www/html/conf
#	chown apache:root /var/www/html/conf
#	chmod 750 /var/www/html/conf
#fi

# Create a default config
if [ ! -f /var/www/html/conf/conf.php ]; then
	echo "###### Creating /var/www/html/conf/conf.php"

	cat <<-EOF > /var/www/html/conf/conf.php
		<?php
		// Config file for Dolibarr ${DOLI_VERSION} ($(date))

		// ###################
		// # Main parameters #
		// ###################
		\$dolibarr_main_url_root='${DOLI_URL_ROOT}';
		\$dolibarr_main_document_root='/var/www/html';
		\$dolibarr_main_url_root_alt='/custom';
		\$dolibarr_main_document_root_alt='/var/www/html/custom';
		\$dolibarr_main_data_root='/var/www/documents';
		\$dolibarr_main_db_host='${DOLI_DB_HOST}';
		\$dolibarr_main_db_port='${DOLI_DB_PORT}';
		\$dolibarr_main_db_name='${DOLI_DB_NAME}';
		\$dolibarr_main_db_prefix='${DOLI_DB_PREFIX}';
		\$dolibarr_main_db_user='${DOLI_DB_USER}';
		\$dolibarr_main_db_pass='${DOLI_DB_PASSWORD}';
		\$dolibarr_main_db_type='${DOLI_DB_TYPE}';
		\$dolibarr_main_db_character_set='${DOLI_DB_CHARACTER_SET}';
		\$dolibarr_main_db_collation='${DOLI_DB_COLLATION}';

		// ##################
		// # Login          #
		// ##################
		\$dolibarr_main_authentication='${DOLI_AUTH}';
		\$dolibarr_main_auth_ldap_host='${DOLI_LDAP_HOST}';
		\$dolibarr_main_auth_ldap_port='${DOLI_LDAP_PORT}';
		\$dolibarr_main_auth_ldap_version='${DOLI_LDAP_VERSION}';
		\$dolibarr_main_auth_ldap_servertype='${DOLI_LDAP_SERVERTYPE}';
		\$dolibarr_main_auth_ldap_login_attribute='${DOLI_LDAP_LOGIN_ATTRIBUTE}';
		\$dolibarr_main_auth_ldap_dn='${DOLI_LDAP_DN}';
		\$dolibarr_main_auth_ldap_filter ='${DOLI_LDAP_FILTER}';
		\$dolibarr_main_auth_ldap_admin_login='${DOLI_LDAP_ADMIN_LOGIN}';
		\$dolibarr_main_auth_ldap_admin_pass='${DOLI_LDAP_ADMIN_PASS}';
		\$dolibarr_main_auth_ldap_debug='${DOLI_LDAP_DEBUG}';

		// ##################
		// # Security       #
		// ##################
		\$dolibarr_main_prod='${DOLI_PROD}';
		\$dolibarr_main_force_https='${DOLI_HTTPS}';
		\$dolibarr_main_restrict_os_commands='mysqldump, mysql, pg_dump, pgrestore';
		\$dolibarr_nocsrfcheck='${DOLI_NO_CSRF_CHECK}';
		\$dolibarr_main_cookie_cryptkey='$(openssl rand -hex 32)';
		\$dolibarr_mailing_limit_sendbyweb='0';
		EOF

	#chown apache:root /var/www/html/conf/conf.php
	chmod 7777 /var/www/html/conf/conf.php
fi

if [ ! -f /var/www/documents/install.lock ]; then
		# Create forced values for first install
		cat <<-EOF > /var/www/html/install/install.forced.php
			<?php
			// Forced install config file for Dolibarr ${DOLI_VERSION} ($(date))

			/** @var bool Hide PHP informations */
			\$force_install_nophpinfo = true;

			/** @var int 1 = Lock and hide environment variables, 2 = Lock all set variables */
			\$force_install_noedit = 2;

			/** @var string Information message */
			\$force_install_message = 'Dolibarr installation';

			/** @var string Data root absolute path (documents folder) */
			\$force_install_main_data_root = '/var/www/documents';

			/** @var bool Force HTTPS */
			\$force_install_mainforcehttps = !empty('${DOLI_HTTPS}');

			/** @var string Database name */
			\$force_install_database = '${DOLI_DB_NAME}';

			/** @var string Database driver (mysql|mysqli|pgsql|mssql|sqlite|sqlite3) */
			\$force_install_type = '${DOLI_DB_TYPE}';

			/** @var string Database server host */
			\$force_install_dbserver = '${DOLI_DB_HOST}';

			/** @var int Database server port */
			\$force_install_port = '${DOLI_DB_PORT}';

			/** @var string Database tables prefix */
			\$force_install_prefix = '${DOLI_DB_PREFIX}';

			/** @var string Database username */
			\$force_install_databaselogin = '${DOLI_DB_USER}';

			/** @var string Database password */
			\$force_install_databasepass = '${DOLI_DB_PASSWORD}';

			/** @var bool Force database user creation */
			\$force_install_createuser = !empty('${DOLI_DB_ROOT_LOGIN}');

			/** @var bool Force database creation */
			\$force_install_createdatabase = !empty('${DOLI_DB_ROOT_LOGIN}');

			/** @var string Database root username */
			\$force_install_databaserootlogin = '${DOLI_DB_ROOT_LOGIN}';

			/** @var string Database root password */
			\$force_install_databaserootpass = '${DOLI_DB_ROOT_PASSWORD}';

			/** @var string Dolibarr super-administrator username */
			\$force_install_dolibarrlogin = '${DOLI_ADMIN_LOGIN}';

			/** @var bool Force install locking */
			\$force_install_lockinstall = true;

			/** @var string Enable module(s) (Comma separated class names list) */
			\$force_install_module = '${DOLI_MODULES}';
			EOF

		echo "You shall complete Dolibarr install manually at '${DOLI_URL_ROOT}/install'"
	fi

exec apache2-foreground
