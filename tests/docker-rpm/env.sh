#!/bin/sh

export REPO_DIR=~/repositories
export PKG_DIR=~/repositories/pkgs
export DIST=$(rpm --eval %{?dist})
if [ $DIST == '.el7' ]; then
    export DISTRO="rhel"
    export DIST_PKG="rhpkg"
    export BUILDDEP="yum-builddep"
else
    export DISTRO="fedora"
    export DIST_PKG="fedpkg"
    export BUILDDEP="dnf builddep"
fi

while getopts ":t:p:u:r:b:d:f:k:" opt; do
    case $opt in
        t)
            export BUILDTYPE=$OPTARG
            ;;
        p)
            export PACKAGE=$OPTARG
            ;;
        u)
            export USER=$OPTARG
            ;;
        r)
            export USER_REPO=$OPTARG
            ;;
        b)
            export BRANCH=$OPTARG
            ;;
        d)
            export UPSTREAM_USER=$OPTARG
            ;;
        f)
            export UPSTREAM_BRANCH=$OPTARG
            ;;
        k)
            export KOJI_TAG=$OPTARG
            if [ $KOJI_TAG = "rawhide" ]; then
                export DIST_GIT_TAG="master"
            else
                export DIST_GIT_TAG=$KOJI_TAG
            fi
            ;;
    esac
done
