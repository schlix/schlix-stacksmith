#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

echo "==> Starting Apache..."

scl enable httpd24 'httpd -DFOREGROUND'
