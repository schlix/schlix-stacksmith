#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

setupSchlixENV() {
    echo "==> Setting up Schlix env vars"
    export SCHLIX_INSTALL_USE_ENV="1"
    export SCHLIX_INSTALL_DB_HOST=$DATABASE_HOST
    export SCHLIX_INSTALL_DB_DATABASE=$DATABASE_NAME
    export SCHLIX_INSTALL_DB_USERNAME=$DATABASE_USER
    export SCHLIX_INSTALL_DB_PORT=$DATABASE_PORT

    CA_FILE='/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem'
    if [ -f "$CA_FILE" ]; then
        export SCHLIX_INSTALL_DB_SSL_CA=$CA_FILE
    fi
}

main() {
    readonly installdir='/var/www/html'

    if [ ! -f $installdir/multisite-config.inc.php ]; then
        setupSchlixENV
    fi

    echo "==> Starting Apache..."
    scl enable httpd24 'httpd -DFOREGROUND'
}

main

