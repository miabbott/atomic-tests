This playbook is a basic functional test for runc.  It is not intended test
all features of runc.

Core Functionality
- runc create
- runc delete
- runc exec
- runc init
- runc kill
- runc list
- runc ps
- runc run
- runc start
- runc state
- runc update

### Prerequisites
  - Ansible version 2.2 (other versions are not supported)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscribe/tasks/main.yaml](roles/redhat_subscribe/tasks/main.yaml)
    for additional details.

  - Configure the required variables to your liking in [tests/runc/vars.yml](tests/runc/vars.yml).

  - Because these tests are geared towards testing upgrades and rollbacks,
    the system under test should have a new tree available to upgrade to.

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/runc/main.yml
```
