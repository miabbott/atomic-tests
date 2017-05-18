This playbook builds the docker-latest RPMs, installs them,
then verifies the basic docker functions.

Core Functionality
  - Building RPMs from spec + source
  - Building RPMs from spec + alternate source (e.g. a PR)
  - Install the built RPMs
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

  - A RHEL or Fedora system

  - Configure subscription data

    If running against a RHEL, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [roles/redhat_subscription/tasks/main.yml](roles/redhat_subscription/tasks/main.yml)
    for additional details.

  - Some other stuff

  - Configure the required variables to your liking in [tests/docker-rpm/vars.yml](vars.yml).

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory tests/docker-rpm/main.yml -e subscription_file="/path/to/subscription_data.csv"  -e @/path/to/vars.yml
```

By default, this test will test docker-latest.  If you would like to test the
out-of-box release of docker, set `g_docker_latest` to false
in [tests/docker-rpm/vars.yml](vars.yml).

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.
