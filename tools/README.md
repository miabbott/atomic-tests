Small tools container for use with [atomic-host-tests](https://github.com/projectatomic/atomic-host-tests)

As of 09-Jan-2017, the following utilities/packages are installed
  - `jq`

To run the container:

`# docker run -i docker.io/miabbott/aht-tools <command> <cmd_args>`

For example:

`# rpm-ostree status --json | docker run -i docker.io/miabbott/aht-tools jq '.'`
