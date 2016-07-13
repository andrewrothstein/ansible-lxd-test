#!/usr/bin/env bash
set +x

function launch {
    IMAGE=$1
    VM=$2
    lxc launch images:$IMAGE $VM
}

function key {
    VM=$1
    lxc exec $VM -- mkdir -p /root/.ssh
    lxc file --uid=0 --gid=0 push ~/.ssh/authorized_keys $VM/root/.ssh/authorized_keys
}

function launch_sshd_systemd {
    VM=$1
    lxc exec $VM -- systemctl start sshd
    lxc exec $VM -- systemctl enable sshd
}

function launch_sshd_service {
    VM=$1
    lxc exec $VM -- service ssh start
}

function launch_sshd {
    INIT=$1
    VM=$2
    launch_sshd_$INIT $VM
}

# the tee is a hack for Fedora: https://bugzilla.redhat.com/show_bug.cgi?id=1224908
function install_sshd {
    PKG=$1
    VM=$2
    lxc exec $VM -- bash -l -c "$PKG update -y | tee"
    lxc exec $VM -- bash -l -c "$PKG upgrade -y | tee"
    lxc exec $VM -- bash -l -c "$PKG install -y openssh-server | tee"
}

function boot {
    IMAGE=$1
    VM=$2
    launch $IMAGE $VM
    key $VM
}

function configure {
    VM=$1
    PKG=$2
    INIT=$3
    install_sshd $PKG $VM
    launch_sshd $INIT $VM
}

function launch {
    IMAGE=$1
    VM=$2
    PKG=$4
    INIT=$5
    boot $IMAGE $VM
    sleep 5
    configure $VM $PKG $INIT
}

function launch_all {
    boot ubuntu/trusty/amd64 ubuntu-trusty-amd64
    boot ubuntu/xenial/amd64 ubuntu-xenial-amd64
    boot fedora/23/amd64 fedora-23-amd64
    boot centos/7/amd64 centos-7-amd64
    sleep 5
    configure ubuntu-trusty-amd64 apt service
    configure ubuntu-xenial-amd64 apt systemd
    configure fedora-23-amd64 dnf systemd
    configure centos-7-amd64 yum systemd
}

launch_all
