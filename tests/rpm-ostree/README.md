This playbook tests the basic rpm-ostree commands and options.

Core Functionality
  - rpm-ostree compose
  - rpm-ostree cleanup
  - rpm-ostree db
  - rpm-ostree deploy
  - rpm-ostree rebase
  - rpm-ostree rollback
  - rpm-ostree status
  - rpm-ostree upgrade
  - rpm-ostree reload
  - rpm-ostree initramfs

To be Covered
  - rpm-ostree db

Covered In Another Test
  - rpm-ostree install
  - rpm-ostree uninstall

### Prerequisites
  - Ansible version 2.2 (other versions are not supported)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscription/tasks/main.yml](roles/redhat_subscription/tasks/main.yml)
    for additional details.

  - Configure the required variables to your liking in [tests/rpm-ostree/vars.yml](vars.yml).

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/rpm-ostree/main.yml
```

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.
