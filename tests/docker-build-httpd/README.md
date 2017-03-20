### Docker Base Image Testing

This playbook validates changes made to the Atomic Host platform does not
interfere with users ability to use build/run images built on top of various
base images.

The playbook pulls a number of base images, builds a simple `httpd` image on
top of them, runs the `httpd` image, and verifies the content returned is
correct. After the content is verified, the container and `httpd` image are
removed.

The following base images are tested:
  - docker.io/alpine
  - docker.io/busybox
  - docker.io/centos
  - docker.io/debian
  - docker.io/httpd
  - registry.fedoraproject.org/fedora24
  - registry.fedoraproject.org/fedora25
  - docker.io/nginx
  - registry.access.redhat.com/rhel6 (RHEL only)
  - registry.access.redhat.com/rhel7 (RHEL only)
  - registry.access.redhat.com/rhel7-atomic (RHEL only)
  - docker.io/ubuntu

### Prerequisites
  - Ansible version 2.2 (other versions of Ansible are not supported)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscribe/tasks/main.yaml](roles/redhat_subscribe/tasks/main.yaml)
    for additional details.

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/docker-build-httpd/main.yml
```

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.
