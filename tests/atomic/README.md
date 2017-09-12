This playbook tests the atomic commands

Test Cases
Core Functionality
- atomic images delete
- atomic images list
- atomic images update
- atomic pull
- atomic push
- atomic containers list
- atomic containers delete

### Prerequisites
  - Ansible version 2.2 (other versions are not supported)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscription/tasks/main.yml](roles/redhat_subscription/tasks/main.yml)
    for additional details.

  - Configure the required variables to your liking in [tests/atomic/vars.yml](tests/atomic/vars.yml).

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/atomic/main.yml
```

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.
