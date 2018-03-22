Small tools container for use with [atomic-host-tests](https://github.com/projectatomic/atomic-host-tests)

As of 22-Mar-2018, the following utilities/packages are installed
  - `jq`  added to remove package list from rpm-ostree json output
  - `git` added to clone repo for rpm-ostree compose test
  - `python` added to start http server to serve local repo for rpm-ostree install gpg test
  - `createrepo_c` added to create a local repo for rpm-ostree install gpg test

To run the container:

`# docker run -i docker.io/miabbott/aht-tools <command> <cmd_args>`

For example:

`# rpm-ostree status --json | docker run -i docker.io/miabbott/aht-tools jq '.'`
