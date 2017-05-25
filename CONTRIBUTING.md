### Submitting Issues

Please feel free to submit a new issue to highlight a problem with the tests
or to start a discussion about a feature or test you would like to add.  We
don't want to waste anyone's time, so these early discussions can be useful
to figuring out the right approach for a new feature or test.

When submitting an issue about a problem with the tests, please be specific
about the circumstances of the problem.  Verbose output from a playbook run
is usually most helpful.  You can include the relevant snippet in the issue
and link to the full logs on a pastebin service such as https://fpaste.org

### Submitting Patches

We welcome PRs to this project.  Please have a look at `git log` and try
to match the commit log style.  (Note: we aren't strict about style, but
it would be nice if the commit messages were well constructed and
informative.)  The [7 Rules of a great Git commit message](https://chris.beams.io/posts/git-commit/#seven-rules) are a great set of guidlines to follow.

Before submitting any PRs, you should verify that the changes you have
made will successfully run on CentOS Atomic Host, Fedora Atomic Host, and
RHEL Atomic Host.  If you don't have access to RHEL Atomic Host, please
note it in a comment to your PR.

During the PR review process, please use separate commits when making
requested changes to your outstanding PR.  It is useful to preserve the
history of the changes to a PR during the review process.  Please don't
force-push a new commit on your PR unless absolutely necessary.  The use
of `git commit --fixup` is encouraged as it can make squashing commits
easier.  

### Reviewing Patches

In addition to welcoming PRs to this project, we also encourage users to
review incoming PRs as a way to become more familiar with the project
itself.

### Coding Style

We try to follow the same best-practices and style guidelines from the
OpenShift Ansible team:
  - [Ansible Best Practices](https://github.com/openshift/openshift-ansible/blob/master/docs/best_practices_guide.adoc#ansible)
  - [Ansible Style Guide](https://github.com/openshift/openshift-ansible/blob/master/docs/style_guide.adoc#ansible)
