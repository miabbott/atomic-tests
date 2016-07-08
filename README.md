# Atomic Host Tests
This repo will contain a number of Ansible playbooks that can be used to run
tests against an Atomic Host.

The intent is to have a collection of tests that can be used to test the
CentOS, Fedora, and RHEL versions of Atomic Host.

Currently, these tests fall into the category of single host, integration tests.

**NOTE**:  This repo only provides playbooks/tests and does not currently
provide any way for provisioning test resources/infrastructure.

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

### Running Playbooks
All the playbooks should be able to be run without any extra options on the
command line.  Like so:

`# ansible-playbook -i inventory tests/new-tree-smoketest.main.yaml`

However, some tests do accept extra arguments that can change how the test is
run; please see the README for each test for details.

Additionally, certain variables are required to be configured for each test and
the required variables can vary between tests.  There are sensible defaults
provided, but it is up to the user to configure them as they see fit.

**NOTE** The playbooks originally added to the repo were tested using Ansible
1.9.4, but we are beginning to adopt Ansible version 2 (or newer) for future
tests.  See [Issue #28](https://github.com/projectatomic/atomic-host-tests/issues/28)
for discussion.

### Directory Layout

**WARNING** The directory structure described below is in place for some of
the first tests that were added to this repo.  However, newer tests have
begun to adopt the OpenShift Ansible guidelines as described in
[Issue #25](https://github.com/projectatomic/atomic-host-tests/issues/25).
We will have to refactor the original tests to use these new guidelines in
the future.

The directory structure attempts to break out functionality into separate
sub-directories where appropriate.  For example, the `common` directory has
a set tasks that could be run anywhere and the `rhel` directory contains
tasks would only be run on RHEL Atomic Host.

The tests use `include:` to bring in tasks to the playbook rather than using
roles.  This was done in hopes that re-use of tasks could be achieved rather
than copying the same tasks into a role structure for each playbook.

