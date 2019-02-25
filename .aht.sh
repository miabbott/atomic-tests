#!/bin/bash
if [ -z "$TEST_PATH" ]; then
        echo "No test provided; please supply a value for TEST_PATH"
        exit 1
fi
if [ ! -f "/atomic-host-tests/$TEST_PATH" ]; then
        echo "The value for TEST_PATH does not exist"
        exit 1
fi
env ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook "/atomic-host-tests/$TEST_PATH" "$@"
