#!/bin/python
#if [ -z "$TEST_PATH" ]; then
#        echo "No test provided; please supply a value for TEST_PATH"
#        exit 1
#fi
#if [ ! -f "/atomic-host-tests/$TEST_PATH" ]; then
#        echo "The value for TEST_PATH does not exist"
#        exit 1
#fi
#env ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook "/atomic-host-tests/$TEST_PATH" "$@"

import os
import sys
import argparse
import subprocess

def parse_args(args=None):
    parser = argparse.ArgumentParser(description='Atomic hosts tests helper script')
    parser.add_argument('-tp', '--testpath',
                        help='Test path relative to \
                        /atomic-host-test folder \
                        inside the container',
                        required='True')
    results = parser.parse_args(args[0:2])
    actual_path = "/atomic-host-tests/tests/{0}".format(results.testpath)
    if not os.path.exists(actual_path):
        print("TESTPATH does not exist Please mention the tests from following") 
        print(os.listdir("/atomic-host-tests/tests/"))
    else:
        print("env ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook {0} {1}".format(actual_path, " ".join(args[2:])))
        os.system("env ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook {0} {1}".format(actual_path, " ".join(args[2:])))
    return(actual_path)

if __name__ == '__main__':
    path = os.path.dirname("/atomic-host-tests/")
    p = subprocess.Popen(["/usr/bin/git", "pull", "origin", "master"], cwd=path)
    p.wait()
    testpath = parse_args(sys.argv[1:])
    print(testpath)
