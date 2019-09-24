#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

setupSchlixENV() {
    echo "==> Load Schlix env vars"
    source $installdir/.schlix-env
}

main() {
    readonly installdir='/var/www/html'

    if [ ! -f $installdir/multisite-config.inc.php ]; then
        setupSchlixENV
    else
        rm -f $installdir/.schlix-env
    fi

    echo "==> Starting Apache..."
    scl enable httpd24 'httpd -DFOREGROUND'
}

main

