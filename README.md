# Atomic Host Tests
This repo contains a number of Ansible playbooks that can be used to run
tests against an Atomic Host.

The intent is to have a collection of tests that can be used to test the
CentOS, Fedora, and RHEL versions of Atomic Host.

Currently, these tests fall into the category of single host, integration tests.

**NOTE**:  This repo only provides playbooks/tests and does not currently
provide any way for provisioning test resources/infrastructure.

### Supported Test Suites
The following test suites are available and supported.  Any other playbooks
found in the repo are currently unmaintained and may not work correctly.

- [ostree admin unlock](tests/admin-unlock/main.yml)
  - Verifies the ability to install packages using `ostree admin unlock`
- [Docker Swarm](tests/docker-swarm/main.yml)
  - Covers the basic functionality of the `docker swarm` commands
- [Docker/Docker Latest](tests/docker/main.yml)
  - Validates basic `docker` operations using either `docker` or `docker-latest`
- [Improved Sanity Test](tests/improved-sanity-test/main.yml)
  - A test suite aimed at providing smoketest-like coverage of an entire
    Atomic Host
- [Kubernetes ](tests/k8-cluster/main.yml)
  - Validates standing up a single-node Kubernetes cluster and deploying a
    simple web+DB application
- [Package Layering](tests/pkg-layering/main.yml)
  - Validates the package layering functionality of `rpm-ostree`
- [System Containers](tests/system-containers/main.yml)
  - Verifies the basic usage of system containers on Atomic Host
- [Runc](test/runc/main.yml)
  - Verifies basic runc functions

### Why Ansible?
The reasons for choosing Ansible playbooks are mainly 1) ease of use, 2)
portability, and 3) simplicity.

1. Ansible is a well-known tool and there is plenty of documentation
available for users to rely on.

1. Ansible requires only a small amount of functionality on the system
under test (basically Python and SSH), so playbooks can be used across multiple
platforms with little changes necessary.

1. Fail fast and early.  When a task in Ansible fails, the whole playbook
fails (for the most part).  Thus, if something fails during the execution,
that is a good indication that something broke.


### Virtual Environment
The preferred environment to run the playbooks is using a virtual environment.
This will ensure the correct version of Ansible is installed and will not
interfere with your current workspace.

To setup a virtualenv, follow the steps below after cloning atomic-host-tests:

`pip install virtualenv`
`virtualenv my_env`
`source my_env/bin/activate`
`pip install -r requirements.txt`

### Running Playbooks
All the playbooks should be able to be run without any extra options on the
command line.  Like so:

`# ansible-playbook -i inventory tests/improved-sanity-tests/main.yml`

However, some tests do accept extra arguments that can change how the test is
run; please see the README for each test for details.

Additionally, certain variables are required to be configured for each test and
the required variables can vary between tests.  There are sensible defaults
provided, but it is up to the user to configure them as they see fit.

**NOTE**:  Playbooks are developed and tested using Ansible 2.2.  Older versions
will not work.

### Vagrant

You can see how the playbooks would run by using the supplied
Vagrantfile which defines multiple boxes to test with. The Vagrantfile
requires a 'vagrant-reload' plugin available from the following GitHub repo:

https://github.com/aidanns/vagrant-reload

With the plugin installed, you should be able to choose a CentOS AH box, a
Fedora 24/25 AH box, or a CentOS AH Continuous (CAHC) box.

```
$ vagrant up centos

or

$ vagrant up {fedora24|fedora25}

or

$ vagrant up cahc
```

By default, the Vagrantfile will run the `tests/improved-sanity-tests/main.yml`
playbook after Vagrant completes the provisioning of the box.  The playbook
which is run can be changed by setting the environment variable `PLAYBOOK_FILE`
to point to a playbook in the repo.

```
$ PLAYBOOK_FILE=tests/docker-swarm/main.yml vagrant up cahc
```

**NOTE**: By default, the Vagrant boxes will provision HEAD-1 of the flavor of
Atomic Host you want to bring up.
