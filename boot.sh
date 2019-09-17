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

printDBSetup() {
    echo "---------------------------------------------------"
    echo "SCHLIX CMS can now be set up with the following database information"
    echo "- Host: $DATABASE_HOST"
    echo "- Database: $DATABASE_NAME"
    echo "- User: $DATABASE_USER"
    echo "---------------------------------------------------"
}

main() {
    readonly installdir='/var/www/html'

    waitForMySQL

    if [ ! -f $installdir/multisite-config.inc.php ]; then
        printDBSetup
        # TODO: automated installation
    fi

    chown -R apache:apache $installdir/
}

main
