This playbook aims to be an improved version of the sanity tests.  It is
initially targeted at the [CAHC stream](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel)

The focus of this set of tests are things like:
  - adding users
  - modifying `/etc`
  - adding data to `/var`
  - `/tmp` permissions

...and the interaction of these actions during upgrades and rollbacks.

In the future, the playbook can be expanded with similar small and focused
tests.

### Prerequisites
  - Ansible version 2+ (the playbook was tested using Ansible 2.1)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscribe/tasks/main.yaml](roles/redhat_subscribe/tasks/main.yaml)
    for additional details.

  - Configure the required variables to your liking in [tests/improved-sanity-tests/vars.yml](tests/improved-sanity-tests/vars.yml).

  - Because these tests are geared towards testing upgrades and rollbacks,
    the system under test should have a new tree available to upgrade to.

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/improved-sanity-test/main.yml
```

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.
