#!/usr/bin/env bash
set -x

function del {
    VM=$1
    lxc delete --force $VM;
}

function del_all {
    del ubuntu-trusty-amd64;
    del ubuntu-xenial-amd64
    del fedora-23-amd64;
    del centos-7-amd64;
}

del_all
