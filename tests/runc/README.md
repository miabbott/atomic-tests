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
  - Ansible version 2+ (the playbook was tested using Ansible 2.1)

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

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.

#### Vagrant

Alternatively, you can see how the playbook would run by using the supplied
Vagrantfile which defines multiple boxes to test with. The Vagrantfile
requires a 'vagrant-reload' plugin - see the Vagrantfile for additional
information.

With the plugin installed, you should be able to choose a CentOS AH box, a
Fedora 24 AH box, or a CAHC box.

```
$ vagrant up centos

or

$ vagrant up fedora24

or

$ vagrant up cahc
```

