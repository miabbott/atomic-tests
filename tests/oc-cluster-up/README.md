This playbook performs a sanity test of 'oc cluster up'

Test Cases
  - install oc binaries
  - oc cluster up
  - oc login
  - oc project
  - oc status
  - oc cluster down

### Prerequisites
  - Ansible version 2.4 (other versions are not supported)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscription/tasks/main.yml](roles/redhat_subscription/tasks/main.yml)
    for additional details.

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/oc-cluster-up/main.yml
```

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.
