This playbook tests the basic docker functions.  RHEL and Centos Atomic Host is
shipped with two version of docker--docker-current and docker-latest.  Docker
current is the current stable release of docker while docker-latest is the latest
release of docker available.  The purpose of the docker-latest release is for
developers to try out new docker features but should probably not be used for
production.

Core Functionality
  - docker build
  - docker images
  - docker ps
  - docker pull
  - docker rm
  - docker rmi
  - docker run
  - docker start
  - docker stop

### Prerequisites
  - Ansible version 2.2 (other versions are not supported)

  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscription/tasks/main.yml](roles/redhat_subscription/tasks/main.yml)
    for additional details.

  - Configure the required variables to your liking in [tests/docker/vars.yml](vars.yml).

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/docker/main.yml
```

By default, this test will test docker-latest.  If you would like to test the
out-of-box release of docker, set `g_docker_latest` to false in [tests/docker/vars.yml](vars.yml).

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.
