#!/bin/sh

. env.sh

# update sources
update_sources_and_spec ()
{
    pushd $REPO_DIR/$PACKAGE
    git remote add $USER git://github.com/$USER/$USER_REPO.git
    git fetch $USER
    git checkout $USER/$BRANCH
    export COMMIT_DOCKER=$(git show --pretty=%H -s $USER/$BRANCH)
    export SHORTCOMMIT_DOCKER=$(c=$COMMIT_DOCKER; echo ${c:0:7})
    export VERSION=$(sed -e 's/-.*//' VERSION)
    popd

    #pushd $REPO_DIR/$PACKAGE-storage-setup
    #git fetch origin
    #export DSS_COMMIT=$(git show --pretty=%H -s origin/master)
    #export DSS_SHORTCOMMIT=$(c=$DSS_COMMIT; echo ${c:0:7})
    #popd

    pushd $REPO_DIR/$PACKAGE-novolume-plugin
    git fetch origin
    export COMMIT_NOVOLUME=$(git show --pretty=%H -s origin/master)
    export SHORTCOMMIT_NOVOLUME=$(c=$COMMIT_NOVOLUME; echo ${c:0:7})
    popd

    pushd $REPO_DIR/rhel-push-plugin
    git fetch origin
    export COMMIT_RHEL_PUSH=$(git show --pretty=%H -s origin/master)
    export SHORTCOMMIT_RHEL_PUSH=$(c=$COMMIT_RHEL_PUSH; echo ${c:0:7})
    popd

    pushd $REPO_DIR/$PACKAGE-lvm-plugin
    git fetch origin
    export COMMIT_LVM=$(git show --pretty=%H -s origin/master)
    export SHORTCOMMIT_LVM=$(c=$COMMIT_LVM; echo ${c:0:7})
    popd

    pushd $REPO_DIR/runc
    git remote add projectatomic git://github.com/projectatomic/runc.git
    git fetch --all
    export COMMIT_RUNC=$(git show --pretty=%H -s projectatomic/$UPSTREAM_BRANCH)
    export SHORTCOMMIT_RUNC=$(c=$COMMIT_RUNC; echo ${c:0:7})
    popd

    pushd $REPO_DIR/containerd
    git remote add projectatomic git://github.com/projectatomic/containerd.git
    git fetch --all
    export COMMIT_CONTAINERD=$(git show --pretty=%H -s projectatomic/$UPSTREAM_BRANCH)
    export SHORTCOMMIT_CONTAINERD=$(c=$COMMIT_CONTAINERD; echo ${c:0:7})
    popd

    if [ $UPSTREAM_BRANCH == "docker-1.13.1" ]; then
        pushd $REPO_DIR/tini
        git fetch origin
        export COMMIT_TINI=$(git show --pretty=%H -s origin/master)
        export SHORTCOMMIT_TINI=$(c=$COMMIT_TINI; echo ${c:0:7})
        popd

        pushd $REPO_DIR/libnetwork
        git fetch origin
        export COMMIT_LIBNETWORK=$(git show --pretty=%H -s origin/master)
        export SHORTCOMMIT_LIBNETWORK=$(c=$COMMIT_LIBNETWORK; echo ${c:0:7})
        popd
    fi

    pushd $PKG_DIR/$PACKAGE
    git checkout $DIST_GIT_TAG
    sed -i "s/\%global git_docker.*/\%global git_docker https:\/\/github.com\/$USER\/$USER_REPO/" $PACKAGE.spec
    sed -i "s/\%global commit_docker.*/\%global commit_docker $COMMIT_DOCKER/" $PACKAGE.spec
    #sed -i "s/\%global commit_dss.*/\%global commit_dss $DSS_COMMIT/" $PACKAGE.spec
    sed -i "s/\%global commit_novolume.*/\%global commit_novolume $COMMIT_NOVOLUME/" $PACKAGE.spec
    sed -i "s/\%global commit_rhel_push.*/\%global commit_rhel_push $COMMIT_RHEL_PUSH/" $PACKAGE.spec
    sed -i "s/\%global commit_lvm.*/\%global commit_lvm $COMMIT_LVM/" $PACKAGE.spec
    sed -i "s/\%global commit_runc.*/\%global commit_runc $COMMIT_RUNC/" $PACKAGE.spec
    sed -i "s/\%global commit_containerd.*/\%global commit_containerd $COMMIT_CONTAINERD/" $PACKAGE.spec

    echo "- built docker @$USER/$BRANCH commit $SHORTCOMMIT_DOCKER" > /tmp/$PACKAGE.changelog
    #echo "- built d-s-s commit $SHORTCOMMIT_DSS" >> /tmp/$PACKAGE.changelog
    echo "- built docker-novolume-plugin commit $SHORTCOMMIT_NOVOLUME" >> /tmp/$PACKAGE.changelog
    echo "- built rhel-push-plugin commit $SHORTCOMMIT_RHEL_PUSH" >> /tmp/$PACKAGE.changelog
    echo "- built docker-lvm-plugin commit $SHORTCOMMIT_LVM" >> /tmp/$PACKAGE.changelog
    echo "- built docker-runc @projectatomic/$UPSTREAM_BRANCH commit $SHORTCOMMIT_RUNC" >> /tmp/$PACKAGE.changelog
    echo "- built docker-containerd @projectatomic/$UPSTREAM_BRANCH commit $SHORTCOMMIT_CONTAINERD" >> /tmp/$PACKAGE.changelog

    if [ $UPSTREAM_BRANCH == "docker-1.13.1" ]; then
        sed -i "s/\%global commit_tini.*/\%global commit_tini $COMMIT_TINI/" $PACKAGE.spec
        sed -i "s/\%global commit_libnetwork.*/\%global commit_libnetwork $COMMIT_LIBNETWORK/" $PACKAGE.spec
        echo "- built docker-init commit $SHORTCOMMIT_TINI" >> /tmp/$PACKAGE.changelog
        echo "- built libnetwork commit $SHORTCOMMIT_LIBNETWORK" >> /tmp/$PACKAGE.changelog
    fi

    popd
}
