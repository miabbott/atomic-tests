This playbook is a basic functional test for docker swarm in single node mode.
It is not intended test all features of docker swarm.

Core Functionality
- Initialize docker swarm
- Create docker swarm service
- Scale replicas up and down
- Remove service
- Leave swarm

### Prerequisites
  - Ansible version 2.2 (other versions are not supported)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscription/tasks/main.yml](roles/redhat_subscription/tasks/main.yml)
    for additional details.

  - Configure the required variables to your liking in [tests/docker-swarm/vars.yml](tests/docker-swarm/vars.yml).

  - Because these tests are geared towards testing upgrades and rollbacks,
    the system under test should have a new tree available to upgrade to.

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/docker-swarm/main.yml
```

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.
