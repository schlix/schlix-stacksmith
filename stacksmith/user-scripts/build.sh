#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

installDependencies() {
    echo "==> Installing dependencies"

    yum install -y \
        git \
        wget \
        nano

    yum -y install centos-release-scl.noarch

    yum -y install \
        rh-php71 \
        rh-php71-php \
        rh-php71-php-bcmath \
        rh-php71-php-cli \
        rh-php71-php-common \
        rh-php71-php-xml \
        rh-php71-php-gd \
        sclo-php71-php-pecl-imagick \
        rh-php71-php-intl \
        rh-php71-php-json \
        rh-php71-php-ldap \
        rh-php71-php-mbstring \
        rh-php71-php-mysqlnd \
        rh-php71-php-zip \
        rh-php71-php-opcache \
        httpd24-mod_ssl
}

configureApache() {
    HTTPD_ROOT='/opt/rh/httpd24/root'
    HTTPD_HTML="$HTTPD_ROOT/var/www/html"
    HTTPD_CONF="$HTTPD_ROOT/etc/httpd/conf/httpd.conf"

    echo "==> Configuring Apache"

    cat >>$HTTPD_CONF <<EOF
<Directory "$HTTPD_HTML">
    AllowOverride all
</Directory>
EOF

    mkdir -p $(dirname $installdir)
    ln -sfF $HTTPD_HTML $installdir

    # Update the PHP.ini file, enable <? ?> tags and quieten logging.
    sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/opt/rh/rh-php71/php.ini
    sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/opt/rh/rh-php71/php.ini

    ########################
    sed -i "s/max_execution_time = 30/max_execution_time = 180/" /etc/opt/rh/rh-php71/php.ini
    sed -i "s/post_max_size = .*$/post_max_size = 128M/" /etc/opt/rh/rh-php71/php.ini
    sed -i "s/upload_max_filesize = .*$/upload_max_filesize = 16M/" /etc/opt/rh/rh-php71/php.ini
    sed -i "s/display_errors = .*$/display_errors = On/" /etc/opt/rh/rh-php71/php.ini
    sed -i "s/max_input_time = .*$/max_input_time = 120/" /etc/opt/rh/rh-php71/php.ini
    sed -i "s/expose_php = .*$/expose_php = Off/" /etc/opt/rh/rh-php71/php.ini
}

downloadSchlix() {
    echo "==> Downloading Schlix"
    
    wget -O /tmp/schlix-cms-latest.zip 'https://www.schlix.com/cmsservices/action/get-cms-latest-zip-download-file'
}

installSchlix() {
    echo "==> Installing Schlix"

    if [ -f $UPLOADS_DIR/schlix-cms*.zip ]; then
        echo "==> Using uploaded Schlix CMS zip file"
        unzip -q $UPLOADS_DIR/schlix-cms*.zip -d /tmp
    else
        downloadSchlix
        if [ -f /tmp/schlix-cms-latest.zip ]; then
            unzip -q /tmp/schlix-cms-latest.zip -d /tmp
        else
            echo "Failed to download Schlix CMS."
        fi
    fi
    cp -R /tmp/schlix/. $installdir
}


main() {
    readonly installdir='/var/www/html'

    installDependencies
    configureApache
    installSchlix
}

main