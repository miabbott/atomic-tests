This playbook tests the admin unlock feature provided by ostree.

Core Functionality
-  Verify rpms can installed and uninstalled after ostree admin unlock
-  Verify overlayfs is created after running ostree admin unlock
    (use mount command verify presence of overlayfs mount)
-  Verify ostree admin status indicates "Unlocked: development" after running
    ostree admin unlock
-  Verify that changes to deployment after ostree admin unlock do not persist
    through reboot.
-  Verify overlayfs is removed (use mount command verify absence of overlayfs
      mount)
-  Verify ostree admin status does not show locked deployment
-  Verify rpms can be installed and uninstalled after ostree admin unlock
    --hotfix and changes persist through reboot.
-  Verify ostree admin status indicates "Unlocked: hotfix"
-  Verify a clone of the current deployment is added to the deployment
-  Use rpm-ostree status to verify there are two deployments with the same
    commit ID
-  Verify overlayfs is created (use mount command verify presence of overlayfs
     mount)
-  Verify rpms can still be installed and uninstalled after reboot
-  Verify ostree admin unlock --hotfix overwrites any other deployment already
     on the system
-  Verify rollback between hotfixed deployment and regular deployment
NOT TESTED:
-  Verify upgrade from hotfixed deployment
    Upgrade should be successful
-  Packages installed in previous unlocked deployment should not be present
     in the upgraded deployment

Negative Testing
-  Verify rpms cannot be installed without ostree admin unlock
-  Run ostree admin unlock twice.  Verify that an error message specifying
    that the deployment is already in an unlocked state: development
-  Run ostree admin unlock, then ostree admin unlock --hotfix.  Verify that
    an error message specifying that the deployment is already in an unlocked
    state: development
-  Run ostree admin unlock --hotfix twice.  Verify that an error message
    specifying that the deployment is already in an unlocked state: hotfix
-  Run ostree admin unlock --hotfix then ostree admin unlock.  Verify that an
    error message specifying that the deployment is already in an unlocked
    state: hotfix

### Prerequisites
  - Ansible version 2.2 (other versions are not supported)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscribe/tasks/main.yaml](roles/redhat_subscribe/tasks/main.yaml)
    for additional details.

  - Configure the required variables to your liking in [tests/admin-unlock/vars.yml](tests/admin-unlock/vars.yml).
    There are two variables g_rpm_name and g_rpm_name_2.  These should be set to
    rpm names from the EPEL repo that have no dependencies and install a binary
    with the same name as the package.

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/admin-unlock/main.yml
```

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.

*NOTE*: This playbook must be run as a whole.  Do not run individual plays.
