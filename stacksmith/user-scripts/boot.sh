#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

waitForMySQL() {
    CA_FILE='/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem'
    if [ -f "$CA_FILE" ]; then
        SSL_OPT="--ssl-ca=$CA_FILE"
    else
        SSL_OPT=''
    fi
    while ! mysql -h $DATABASE_HOST -P $DATABASE_PORT -u $DATABASE_USER -p$DATABASE_PASSWORD -e "SELECT 1;" $SSL_OPT $DATABASE_NAME >/dev/null 2>&1; do
        echo "==> Waiting for database to become available."
        sleep 2
    done
}

setupSchlixENV() {
    echo "==> Adding Schlix env file"

    ENV_FILE="$installdir/.schlix-env"
    echo 'export SCHLIX_INSTALL_USE_ENV="1"' >> $ENV_FILE
    echo "export SCHLIX_INSTALL_DB_HOST=\"$DATABASE_HOST\"" >> $ENV_FILE
    echo "export SCHLIX_INSTALL_DB_DATABASE=\"$DATABASE_NAME\"" >> $ENV_FILE
    echo "export SCHLIX_INSTALL_DB_USERNAME=\"$DATABASE_USER\"" >> $ENV_FILE
    echo "export SCHLIX_INSTALL_DB_PORT=\"$DATABASE_PORT\"" >> $ENV_FILE

    CA_FILE='/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem'
    if [ -f "$CA_FILE" ]; then
        echo "export SCHLIX_INSTALL_DB_SSL_CA=\"$CA_FILE\"" >> $ENV_FILE
    fi
}

main() {
    readonly installdir='/var/www/html'

    waitForMySQL

    if [ ! -f $installdir/multisite-config.inc.php ]; then
        setupSchlixENV
    fi

    chown -R apache:apache $installdir/
}

main
