This playbook tests the system containers feature provided through the atomic and runc commands

Test Cases
Core Functionality
- Verify system containers can be installed through atomic command
- Verify system containers can be uninstalled through the atomic command
- Verify user can specify name for system containers
- Verify system containers can be listed
- Verify environment variables can be pass to the container
- Verify update/rollback of system containers
- Verify commands can be run in the system container
- Verify specification of rootfs for system containers
- Verify setting RUN_DIRECTORY and STATE_DIRECTORY
- Verify system containers are started on reboot
- Verify system containers persist through reboot

Upgrade Tests
- Verify the system container persists through ostree upgrade
- Verify the system container persists through ostree rollback

Flannel & Etcd Tests
- Verify installation of flannel and etcd containers

Negative Testing
- Verify uninstalling a system container that does not exist fails
- Verify installing a system container that does not exist fails
- Verify DESTDIR, NAME, EXEC_START, EXEC_STOP, HOST_UID, and HOST_GID
  cannot be set

NOT COVERED
Upgrade Tests
- Verify the system container persists through ostree upgrade
- Verify the system container persists through ostree rollback

### Prerequisites
  - Ansible version 2+ (the playbook was tested using Ansible 2.1)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscribe/tasks/main.yaml](roles/redhat_subscribe/tasks/main.yaml)
    for additional details.

  - Configure the required variables to your liking in [tests/system-containers/vars.yml](tests/system-containers/vars.yml).

  - Because these tests are geared towards testing upgrades and rollbacks,
    the system under test should have a new tree available to upgrade to.

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/system-containers/main.yml
```

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.

#### Vagrant

Alternatively, you can see how the playbook would run by using the supplied
Vagrantfile which defines multiple boxes to test with. The Vagrantfile
requires a 'vagrant-reload' plugin - see the Vagrantfile for additional
information.

With the plugin installed, you should be able to choose a CentOS AH box, a
Fedora 23 AH box, or a CAHC box.

```
$ vagrant up centos

or

$ vagrant up fedora23

or

$ vagrant up cahc
```

