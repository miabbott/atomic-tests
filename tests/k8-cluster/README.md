This playbook creates a kubernetes cluster on a single system using the
example in the Red Hat documentation.  The cluster contains a database
and a webserver pod with data from the database to present a webpage that 
says "Red Hat Rocks!"

### Prerequisites
  - Configure subscription data (if used)

    If running against a RHEL Atomic Host, you should provide subscription
    data that can be used by `subscription-manager`.  See
    [rhel/subscribe.yaml](/rhel/subscribe.yaml) for addiltional details.

### Running the Playbook

To run the test, simply invoke as any other Ansible playbook:

```
$ ansible-playbook -i inventory main.yaml
```

*NOTE*: You are responsible for providing a host to run the test against and the
inventory file for that host.
