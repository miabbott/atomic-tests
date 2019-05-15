#!/bin/bash
set -xeou pipefail
retries=5
while [ $retries -gt 0 ]; do
	if yum makecache; then
		break
	fi
	retries=$((retries - 1))
done

