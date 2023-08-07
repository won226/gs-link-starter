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
CONTAINERD_CRI_BUILD_DIR=$CONTAINERD_CRI_PKG_DIR/_output
SSU_DCN_POD_MIGRATION_PKG_DIR=$PKG_DIR/podmigration-operator
SSU_DCN_CRIU_PKG_DIR=$SSU_DCN_POD_MIGRATION_PKG_DIR/criu-3.14
SSU_DCN_DEP_KUBERNETES_PKG_DIR=$PKG_DIR/kubernetes

# Clone containerd-cri
info "git clone https://github.com/vutuong/containerd-cri.git $CONTAINERD_CRI_PKG_DIR"
git clone https://github.com/vutuong/containerd-cri.git $CONTAINERD_CRI_PKG_DIR
cd $CONTAINERD_CRI_PKG_DIR

# Clone https://github.com/SSU-DCN/podmigration-operator.git
info "git clone https://github.com/SSU-DCN/podmigration-operator.git $SSU_DCN_POD_MIGRATION_PKG_DIR"
git clone https://github.com/SSU-DCN/podmigration-operator.git $SSU_DCN_POD_MIGRATION_PKG_DIR
cd $SSU_DCN_POD_MIGRATION_PKG_DIR
tar -vxf binaries.tar.bz2
cd custom-binaries/
chmod +x containerd kubeadm kubelet
cd $SSU_DCN_POD_MIGRATION_PKG_DIR
tar -vxf criu-3.14.tar.bz2

# Clone git clone https://github.com/vutuong/kubernetes.git
info "git clone https://github.com/vutuong/kubernetes.git $SSU_DCN_DEP_KUBERNETES_PKG_DIR"
git clone https://github.com/vutuong/kubernetes.git $SSU_DCN_DEP_KUBERNETES_PKG_DIR

# Build containerd-cri
info "Build containerd-cri"
info "$CONTAINERD_CRI_PKG_DIR"
cd $CONTAINERD_CRI_PKG_DIR
make clean
go get github.com/containerd/cri/cmd/containerd
make

# Build criu for SSU-DCN(step8)
info "Build criu for SSU-DCN(step8)"
info "$SSU_DCN_CRIU_PKG_DIR"
cd $SSU_DCN_CRIU_PKG_DIR
make clean
make

# Build podmigration operator
info "Build podmigration operator"
info "$SSU_DCN_POD_MIGRATION_PKG_DIR"
cd $SSU_DCN_POD_MIGRATION_PKG_DIR
make manifests
