This playbook tests the package layering feature provided through the rpm-ostree install command.

Core Functionality
  - Verify rpms package can be layered through rpm-ostree install
  - Verify multiple rpm packages can be layered through rpm-ostree install
  - Verify rpm packages can be removed through rpm-ostree uninstall
  - Verify multiple rpm packages can be removed through rpm-ostree uninstall
  - Verify rpm-ostree status output displays "Package: <pkg1> <pkg2>.." when packages are layered
  - Verify the -r / --reboot flag reboots the host after rpm-ostree install or rpm-ostree uninstall
  - Verify the -n / --dry-run flag does not perform the package add/remove function and displays a summary of packages to be installed
  - Verify a dry-run of rpm-ostree install|uninstall does not affect an existing package that has been layered, but not rebooted.
  - Verify that after additional repos are enabled (i.e. EPEL), rpm-ostree install|uninstall can be successfully used for packages in those repos.

Negative Testing
  - Verify correct error is displayed removing a package that does not exist
  - Verify correct error is displayed when adding a package that does not exists in the repo
  - Verify correct error message is displayed when adding a package that is already in the deployment
  - Verify packages which have files with non-root ownership cannot be installed
  - Verify that install/uninstall operations cannot be performed by unprivileged users

### Prerequisites
  - Ansible version 2+ (the playbook was tested using Ansible 2.1)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscribe/tasks/main.yaml](roles/redhat_subscribe/tasks/main.yaml)
    for additional details.

  - Configure the required variables to your liking in [tests/pkg-layering/vars.yml](tests/pkg-layering/vars.yml).

  - Because these tests are geared towards testing upgrades and rollbacks,
    the system under test should have a new tree available to upgrade to.

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/pkg-layering/main.yml
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

