#!/bin/sh

. env.sh

case "$PACKAGE" in
    docker)
        . pkgs/$PACKAGE.sh
        ;;
    docker-latest)
        . pkgs/$PACKAGE.sh
        ;;
    *)
        . pkgs/default.sh
        ;;
esac

update_sources_and_spec

. common.sh
cleanup_stale
fetch_and_build

if [ $BUILDTYPE == "tagged" ]; then
    commit_to_dist_git
fi
