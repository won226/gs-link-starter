#!/bin/bash
set -e
source scripts/global.sh

info "Remove podmigration operator"

info "Uninstall pod migration CRDs"
cd $SSU_DCN_POD_MIGRATION_PKG_DIR
make uninstall

rm -f $MIGRATION_SERVICE_FILE
systemctl disable migrater
systemctl stop migrater
systemctl daemon-reload
