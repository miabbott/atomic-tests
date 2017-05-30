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

### Writing Your First Role

When writing a role for to be used in a test, you should attempt to make it
fairly generic, so that it can be re-used by other users.  To show this, let's
look at an existing role which is **NOT** generic and could be modified.

The `docker_build_httpd` role was made to support building a specific Docker
image.  It is shown in its entirety below (from [roles/docker_build_httpd](/roles/docker_build_httpd/tasks/main.yml)):

```yaml
---
# vim: set ft=ansible:
#
- name: Fail if g_osname not set
  fail:
    msg: "The g_osname variable is not defined"
  when: g_osname is not defined

- name: Fail if g_httpd_name not set
  fail:
    msg: "The g_httpd_name variable is not defined"
  when: g_httpd_name is not defined

- name: Create temp directory for building
  command: mktemp -d
  register: m

- name: Set build_dir fact
  set_fact:
    build_dir: "{{ m.stdout }}"

- name: Copy Dockerfile to temp directory
  copy:
    src: "{{ g_httpd_name }}_Dockerfile"
    dest: "{{ build_dir }}"
    owner: root
    group: root
    mode: 0644

- name: Copy makecache.sh to temp directory
  copy:
    src: makecache.sh
    dest: "{{ build_dir }}"
    owner: root
    group: root
    mode: 0744
  when: ansible_distribution != 'RedHat'

- name: Copy rhel_makecache.sh to temp directory
  copy:
    src: rhel_makecache.sh
    dest: "{{ build_dir }}"
    owner: root
    group: root
    mode: 0744
  when: ansible_distribution == 'RedHat'

- name: Build httpd image
  command: "docker build -t {{ g_httpd_name }} -f {{ build_dir }}/{{ g_httpd_name }}_Dockerfile {{ build_dir }}"

- name: Get docker images after build
  command: docker images
  register: build_images

- name: Fail if httpd image not present
  fail:
    msg: "The {{ g_httpd_name }} image is not present"
  when: "'{{ g_httpd_name }}' not in build_images.stdout"
```

In this example, the role makes an assumption about the name of the Dockerfile,
the existence of a `makecache.sh` script, and relies on a global variable
throughout.

This role could be improved by removing the assumption about the `makecache.sh`
script, parameterizing more of the tasks, and separating out tasks that
manipulate files/directories into separate roles/tasks.  The improved version
should focus on just the `docker build` command.

An improved version would live in `roles/docker_build/tasks/main.yml` and
could look like this:

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

This completely simplifies the role to handle the building of a Docker image
when given the required parameters.  In this simplified version, you would
have to have separate roles/tasks that would handle the creation of any
required directories and copying the Dockerfile to the host.

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
declaration.  The name is up to the test developer, but we almost always use
`hosts: all` and `become: yes`.  The `hosts: all` allows the executor of the
test some flexibility in how they define the inventory passed to the
playbook.  And since most of our test operations require root privileges,
the `become: yes` declaration ensures that we have those privileges.

The playbook should be tagged via a `tag` value.  This allows the test
executor the ability to skip the entire playbook, if they were to try to run
multiple playbooks via a script or other framework.

If the playbook requires additional variables to be defined, they can be
specified via the `vars_files` or `vars` declaration.

Often a tests will require some tasks to be performed that are not covered
by any existing roles.  In this situation, one would use the `pre_tasks`
statement to define the tasks that should be executed ahead of the roles.

After any required `pre_tasks` the test should be built using the roles
available in the top-level directory.

Finally, any tasks that need to be run after the roles can be specified
in the `post_tasks` section.

#### Example Playbook

In the example playbook, we are going to copy a couple of Dockerfiles to the
host and then run the `docker build` command using those files.  Afterwards,
we will remove the Docker images that have been built.

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

### Documenting Your Playbook

After testing your playbook successfully, it would be a good time to write
up some simple documentation about your playbook/tests.  At a minimum, you
should include a `README.md` in your test directory that describes the tests
that are run, any prerequisites for your playbook, and an example invocation
of the playbook.

Additionally, you may include an `info.txt` file that minimially describes
the tests covered in your playbook and those features that are not covered.

### Asking for Feedback

There are two ways to solicit feedback about your work.  First, you can open
an issue in the repo to discuss how you would like to test a certain feature.
This allows other contributors to weigh in on the design of the test and
provide some pointers on how to best accomplish your goals.

If you feel your work is ready to be reviewed, you can submit your changes
as a pull request and wait for feedback from the contributors.

We strive to be friendly and helpful with contributors, so do not be afraid
to ask for help or guidance at any point during the process.
