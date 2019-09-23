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

main() {
    readonly installdir='/var/www/html'

    waitForMySQL

    chown -R apache:apache $installdir/
}

main
