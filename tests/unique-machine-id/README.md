This playbook verifies that the `/etc/machine-id` file is unique across
hosts that have booted up a freshly pressed cloud image.  See bug
[1189847](https://bugzilla.redhat.com/show_bug.cgi?id=1189847) or
[1198700](https://bugzilla.redhat.com/show_bug.cgi?id=1198700) for details
of the impact of this value being unique.

### Prerequisites

This playbook is intended to be run using two hosts of the same distribution
and version.

### Running the Playbook

`ansible-playbook -i inventory tests/unique-machine-id/main.yml`

### Example Inventory File

```
$ cat inventory
host1 ansible_ssh_host=192.168.122.140 ansible_ssh_user=cloud-user
host2 ansible_ssh_host=192.168.122.142 ansible_ssh_user=cloud-user
```
