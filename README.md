Stream | Version/Status | Log File
:--- | :---: | :---:
Centos Atomic Host Continuous | ![cahc status](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/cahc/latest/status.png) | [log](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/cahc/latest/improved-sanity-test.log)
Fedora Atomic Host Continuous | ![fahc status](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fahc/latest/status.png) | [log](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fahc/latest/improved-sanity-test.log)
Fedora 24 Atomic Host | ![fedora 24 atomic status](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-24-atomic/latest/status.png) | [log](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-24-atomic/latest/improved-sanity-test.log)
Fedora 25 Atomic Host | ![fedora 25 atomic status](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-25-atomic/latest/status.png) | [log](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-25-atomic/latest/improved-sanity-test.log)
Fedora 25 Atomic Testing | ![fedora 25 atomic testing status](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-25-atomic-testing/latest/status.png) | [log](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-25-atomic-testing/latest/improved-sanity-test.log)
Fedora 25 Atomic Updates | ![fedora 25 atomic updates status](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-25-atomic-updates/latest/status.png) | [log](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-25-atomic-updates/latest/improved-sanity-test.log)
Fedora 26 Atomic Host | ![fedora 26 atomic status](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-26-atomic/latest/status.png) | [log](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-26-atomic/latest/improved-sanity-test.log)
Fedora 26 Atomic Testing | ![fedora 26 atomic testing status](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-26-atomic-testing/latest/status.png) | [log](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-26-atomic-testing/latest/improved-sanity-test.log)
Fedora Rawhide Atomic Host | ![fedora rawhide atomic status](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-rawhide/latest/status.png) | [log](https://s3.amazonaws.com/aos-ci/atomic-host-tests/improved-sanity-test/fedora-rawhide/latest/improved-sanity-test.log)

---

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
- [Docker Build httpd](tests/docker-build-httpd/main.yml)
  - Attempts to build a `httpd` container using various base images
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
- [Runc](tests/runc/main.yml)
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

```
pip install virtualenv
virtualenv my_env
source my_env/bin/activate
pip install -r requirements.txt
```

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

### Log Options
By default Ansible logs to stdout.  Atomic host tests has a custom callback
plugin that makes the output more human readable.  In addition there are a few
custom log options described below.

#### Capture failure details

If the environment variable AHT_RESULT_FILE is set, Ansible will save the
details of the failed task into file named after the value of the environment
variable in the current working directory.

```
export AHT_RESULT_FILE=my_failure_file
```

In this example the failure details will be saved to ./my_failure_file

#### Capture journal on failure

Ansible handlers are used to capture the journal on failure.  This feature can
be enabled using a role or an include which must be called in every block of
pre_tasks, post_tasks, tasks, roles, or plays.  Force_handlers must be set to
true regardless of which method is used.

```
force_handlers: true
```

##### To use journal capture as role:
```
- role: handler_notify_on_failure
  handler_name: h_get_journal
```

##### To use journal capture as include:
```
- include: 'atomic-host-tests/roles/handler_notify_on_failure/task/main.yml'
  handler_name: h_get_journal
```

In addition, the handler must be included since using include doesn't automatically
pull in the handler.  This is typically done at the end of the block.

```
handlers:
  - include: 'atomic-host-tests/roles/handler_notify_on_failure/handlers/main.yml'
```
**NOTE** The path should be relative to the path of the playbook

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
