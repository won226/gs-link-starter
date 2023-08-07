#!/bin/bash
set -e

function error() {
    local message=$1
    echo -e "[ERROR] $message"
    exit 1
}

function info() {
    local message=$1
    echo -e "[INFO] $message"    
}

ROOT_DIR=$(realpath $(pwd))
ROOT_PARENT_DIR=$(dirname $ROOT_DIR)
SCRIPT_DIR=$ROOT_DIR/scripts
PKG_DIR=$ROOT_DIR/packages
CONTAINERD_CRI_PKG_DIR=$PKG_DIR/containerd-cri
SSU_DCN_POD_MIGRATION_PKG_DIR=$PKG_DIR/podmigration-operator
SSU_DCN_CRIU_PKG_DIR=$SSU_DCN_POD_MIGRATION_PKG_DIR/criu-3.14
SSU_DCN_DEP_KUBERNETES_PKG_DIR=$PKG_DIR/kubernetes

info "Clean containerd-cri"
if [[ -d $CONTAINERD_CRI_PKG_DIR ]]; then
    cd $CONTAINERD_CRI_PKG_DIR
    make clean || true
fi

info "Clean podmigration-operator"
if [[ -d $SSU_DCN_CRIU_PKG_DIR ]]; then
    cd $SSU_DCN_CRIU_PKG_DIR
    make clean || true
fi

info "rm -rf $CONTAINERD_CRI_PKG_DIR"
rm -rf $CONTAINERD_CRI_PKG_DIR

info "rm -rf $SSU_DCN_POD_MIGRATION_PKG_DIR"
rm -rf $SSU_DCN_POD_MIGRATION_PKG_DIR

info "rm -rf $SSU_DCN_DEP_KUBERNETES_PKG_DIR"
rm -rf $SSU_DCN_DEP_KUBERNETES_PKG_DIR
