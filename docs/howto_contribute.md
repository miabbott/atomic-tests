### Before We Get Started...

This document assumes that you have some basic familiarity with the following
topics:

  - general `git` usage
  - submitting and reviewing pull requests (PRs) on GitHub
  - general Ansible usage (tasks, roles, playbooks)
  - have previously read though [CONTRIBUTING.md](https://github.com/projectatomic/atomic-host-tests/blob/master/CONTRIBUTING.md)

The intention is for the repo to not have any exotic requirements and be
relatively easy to use and to contribute to.  If you feel this is not the
case, feel free to open an [issue](https://github.com/projectatomic/atomic-host-tests/issues/new) to discuss how it can be improved.

### A Brief Introduction to the Repo

At the top-level of the repository, we have five directories.  Of these five
directories, the `roles` and `tests` directories are where the majority of
the development happens.

The `callback_plugins` directory is where we have a single plugin that
provides improved output formatting from the Ansible playbooks.  It also
provides some functionality that allows the tests to collect the journal
from a system after a failure.

The `common` directory contains pieces of Ansible playbooks/roles that did
not fit in with the other roles and tests that exist, but are still used
in parts of the repository.

The `docs` directory contains documentation important to using the repo
and developing for the repo.

The `roles` directory is the traditional `roles` directory that is often
used in Ansible playbooks.  We have placed the directory at the top-level
of the repo, so that we can re-use the roles across multiple tests.

The `tests` directory contains playbooks which execute tests using a mix
of roles and tasks.

### Setting up your Environment/Tools

As stated in the opening of this doc, the repo does not have any exotic
requirements and should be easy to use and develop for.

You are free to use any code editor that you are most familiar with, as long
as it does not cause any breakage in the roles/tests or distrupts the overall
style of the repo.

That being said, `vim` users would probably be interested in the the
[Ansible plugin](https://github.com/pearofducks/ansible-vim) which enables syntax highlighting.
This `vim` plugin is also why many of the `.yml` files in the repo have the
following comment at the head of file:

`# vim: set ft=ansible:`

### Writing Your First Role

The main goal when writing a new role for the repo is to create something
that is generic enough that can be used by other users.  This means that
the role should have a limited scope in terms of what is intends to do and
is not unique to your particular test.

As an example, there is a role defined below that verifies the `docker build`
operation is successful.


```yaml
---
- name: Fail if required variables are not set
  fail:
    msg: "The required variables are not set."
  when: image_name is not defined or
        build_path is not defined or
        dockerfile_name is not defined

- name: Build Docker image
  command: "docker build -t {{ image_name }} -f {{ build_path }}/{{ dockerfile_name }} {{ build_path }}"

- name: Verify Docker image was built
  command: docker images
  register: docker_images
  failed_when: "'{{ image_name }}' not in docker_images.stdout"
```

This role is very flexible as it allows users the ability to define the
location of the Dockerfile, the name of the Dockerfile, and the name of the
image being built.  Other roles or tasks will need to be used to land the
Dockerfile on the host, which allows this role to stay simple in its
definition.

### Writing Your First Test

Now you have a new role created, let's put it to use in a new test playbook.

#### Directory Setup

Firstly, you will have to create a new sub-directory under `tests` and create
symlinks to the top-level `callback_plugins` and `roles` directories.  This
allows the test to reference the available roles and have its output nicely
formatted by the callback plugin.  In this example, we are going to pretend we
are creating a test playbook for the `docker build` command.

```bash
$ mkdir -p tests/docker-build/
$ ln -s ../../callback_plugins/ tests/docker-build/callback_plugins
$ ln -s ../../roles/ tests/docker-build/roles
```

Additional directories such as `files`, `templates` or `vars` may be required
for your test.  Please reference the [Ansible documentation](http://docs.ansible.com/ansible/playbooks_best_practices.html#content-organization) about
content organization about when and how to use these directories.

During this phase, it would be wise to setup any RHEL subscription data under
`/roles/redhat_subscription/files`.  The `redhat_subscription` role defaults
to looking for subscription data in the `/roles/redhat_subscription/files/subscription_data.csv`
file.  You can use the sample data in [subscription_data.csv.sample](/roles/redhat_subscription/files/subscription_data.csv.sample) to see how
the file is structured.

#### Playbook Structure + System State

Now we can start developing the actual playbook.  When running an Ansible
playbook, the operations are mostly executed in serial, so there is a sense
of state of the host under test.  This means you can structure your playbook
to assume certain conditions of the host during the execution of the playbook.

A simple playbook will have a list of tasks or roles defined in a single file
and that is all that will be required.  Sometimes, it is desirable to create
multiple playbooks in a single file for the purposes of providing delineation
between certain features being tested.  This can be seen in [tests/admin-unlock](/tests/admin-unlock/main.yml)
where each set of features is separated into their own playbooks.

For our example, we will use the simple case of a single playbook in a single
file.

#### Playbook Sections

All of the playbooks should start with a `name`, `hosts`, and `become`
declaration.

The `name` is up to the test developer, but should be somewhat descriptive
of what the test is doing.

For the `host` value, we recommend the following:

`- hosts: "{{ testnodes | default('all') }}"`

This allows users to supply simple inventory data to `ansible-playbook`, but
retains the flexibility to support multi-node tests in the future.
(Almost all of the tests in the repo are single-node tests.)

Since most of our test operations require root privileges, the `become: yes`
declaration ensures that we have those privileges.

The playbook should be tagged via a `tag` value.  This allows the test
executor the ability to skip the entire playbook, if they were to try to run
multiple playbooks via a script or other framework.  Typically, this value
is the name of the test being run.

If the playbook requires additional variables to be defined, they can be
specified via the `vars_files` or `vars` declaration.

The bulk of your test will then be constructed using the various roles that
are available in the `roles` directory.  Remember to tag each role with its
name to allow users running your test to skip roles if they choose to.  (If
you are re-using the roles multiple times in the same test, you should tag
each role with a unique value.)

#### Example Playbook

In the example playbook, we are going to copy a couple of Dockerfiles to the
host and the use our `docker_build` role to build Docker images with those
Dockerfiles.  Afterwards, we will remove the Docker images that have been
built.

Before we start to write out any YAML, it is helpful to start by documenting
your test in a README.md file.  In addtion to providing useful information to
users running the tests, it can also help to provide a general structure to
the test you want to write.

We require new tests to minimally include a README.md that covers which kind
of testing the playbook will perform, any kind of prerequisites for running
the playbook, and an example invocation of the playbook.  You can reference
the [README.md](/tests/improved-sanity-test/README.md) from the `improved-sanity-test`
as an example.

Since we are going to be copying multiple Dockerfiles, we will need to create
a `files` directory to hold them.  See below for the directory structure and
some simple example Dockerfiles.

```bash
$ mkdir -p tests/docker-build/files/
$ cat tests/docker-build/files/centos-httpd-Dockerfile
FROM registry.centos.org/centos/centos:7
RUN yum -y install httpd

$ cat tests/docker-build/files/fedora-httpd-Dockerfile
FROM registry.fedoraproject.org/fedora:25
RUN dnf -y install httpd
```

With the files in place, we can edit our playbook at `tests/docker-build/main.yml`.
While it is not required to use the name `main.yml`, it is the standard file name
we have used thusfar.

```yaml
---
- name: Docker Build
  hosts: all
  become: yes

  tags:
    - docker_build

  pre_tasks:
    - name: Make temp directory to hold Dockerfiles
      command: mktemp -d
      register: temp_dir

    - name: Copy Dockerfiles to temp directory
      synchronize:
        src: files/
        dest: "{{ temp_dir.stdout }}/"
        recursive: yes

  roles:
    - role: ansible_version_check
      avc_major: "2"
      avc_minor: "2"
      tags:
        - ansible_version_check

    - role: docker_build
      build_path: "{{ temp_dir.stdout }}"
      dockerfile_name: "centos-httpd-Dockerfile"
      image_name: "centos-httpd"
      tags:
        - centos_docker_build

    - role: docker_build
      build_path: "{{ temp_dir.stdout }}"
      dockerfile_name: "fedora-httpd-Dockerfile"
      image_name: "fedora-httpd"
      tags:
        - fedora_docker_build

  post_tasks:
    - name: Remove all docker images
      shell: docker rmi -f $(docker images -qa)
```

Here we've made a temporary directory, copied the Dockerfiles to the directory,
built the images using the `docker_build` role from the earlier example, and
then cleaned up after the test.

Note, we used the `ansible_version_check` role to verify that the version of
Ansible being used to execute the playbook is what we currently support.  This
is suggested for all playbooks.

Each role is tagged in the same way the whole playbook is tagged - to enable
users to skip certain roles during test execution.

Additionally, it is good practice to clean up any artifacts from the test
which may interfere with other tests that are run afterwards.

### Testing Your Playbook

After you have finished with your playbook, it is important to test that it can
successfully run against the Atomic Host variant of CentOS, Fedora, and RHEL.
If one of those platforms does not run successfully, you'll need to make the
necessary adjustments before submitting a pull request with your changes.

### Following Established Style

The [CONTRIBUTING.md](https://github.com/projectatomic/atomic-host-tests/blob/master/CONTRIBUTING.md) doc points out that the members of the repo try to follow the best
practices and style guidelines that are used by the [openshift-ansible](https://github.com/openshift/openshift-ansible) project.
The are noted here again:

  - [OpenShift Ansible Best Practices](https://github.com/openshift/openshift-ansible/blob/master/docs/best_practices_guide.adoc#ansible)
  - [OpenShift Ansible Style Guide](https://github.com/openshift/openshift-ansible/blob/master/docs/style_guide.adoc#ansible)

You should familiarize yourself with these practices and rules, and try to
follow them as you work on your own changes.

The enforcement of these best practices and rules is not stringent, but be
aware that changes may be requested to comply where it makes sense.

Generally, the YAML structure used in the repo favors the 'multi-line' approach
when writing out tasks or roles:

```yaml
- name: my task
  module_name:
    arg1: "val1"
    arg2: "val2"
  when: something == "foobar"
  register: output_var
```

If you need to run a command that has multiple arguments, you can break them
across multiple lines:

```yaml
- name: long command
  command: >
    long_foobar -v
    --arg1 val1
    --arg2 val2
    --arg3 val3
    some_file_name
```

Finally, on the subject of tabs vs. spaces, the repo uses spaces throughout.

### Asking for Feedback

There are two ways to solicit feedback about your work.  First, you can open
an issue in the repo to discuss how you would like to test a certain feature
or to discuss some changes you would like to make to a repo/test. This allows
other contributors to weigh in on the proposed changes and provide some
feedback on how to best accomplish your goals.

If you feel your work is ready to be reviewed, you can submit your changes
as a pull request and wait for feedback from the contributors.

#### PR Submission Checklist

If your pull request makes any changes to the roles or tests of the repo, the
following checklist may be useful to follow in order to minimize any extra
changes that may be requested:

- [ ] role/test has successfully run against the following platforms
  - [ ] Fedora 25 Atomic Host
  - [ ] CentOS 7 Atomic Host
  - [ ] [CentOS AH Continuous](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel) or [Fedora AH Continuous](https://pagure.io/fedora-atomic-host-continuous)
  - [ ] RHEL 7 Atomic Host (if available)
- [ ] best effort was made to make changes meet [best practices](https://github.com/openshift/openshift-ansible/blob/master/docs/best_practices_guide.adoc#ansible) and [style guidelines](https://github.com/openshift/openshift-ansible/blob/master/docs/style_guide.adoc#ansible)
- [ ] commit message clearly explains changes and rationale for changes

The members of this repo strive to be friendly and helpful with contributors,
so do not be afraid to ask for help or guidance at any point during the process.
