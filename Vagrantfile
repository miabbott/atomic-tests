# -*- mode: ruby -*-
# vi: set ft=ruby :

# !!!NOTE!!!! This Vagrantfile requires the 'vagrant-reload' plugin
# https://github.com/aidanns/vagrant-reload

# This Vagrantfile defines multiple boxes that are tooled to test/run the
# sanity playbook in 'tests/cach-sanity-test/main.yml'.
#
# Each box boots into the OS, deploys HEAD^ of a particular tree, then runs
# the playbook (which currently includes upgrading to HEAD of the same tree).
#
# The playbook is configurable using the $playbook_file variable right before
# the 'Vagrant.configure()' stanza.

# Define scripts to deploy HEAD^ of various trees
# First one deploys HEAD^ of CAHC
# Second, HEAD^ of base CentOS AH
# Third, HEAD^ of Fedora 23 AH
$cahc = <<CAHC
#!/bin/bash
set -xeuo pipefail
current=$(ostree rev-parse centos-atomic-host/7/x86_64/standard)
sudo ostree remote add --set=gpg-verify=false centos-atomic-continuous https://ci.centos.org/artifacts/sig-atomic/rdgo/centos-continuous/ostree/repo/
sudo ostree pull --commit-metadata-only --depth=1 centos-atomic-continuous:centos-atomic-host/7/x86_64/devel/continuous
sudo sed -i 's|centos-atomic-host:centos-atomic-host/7/x86_64/standard|centos-atomic-continuous:centos-atomic-host/7/x86_64/devel/continuous|' /ostree/deploy/centos-atomic-host/deploy/$current.0.origin
sudo rpm-ostree deploy $(ostree rev-parse centos-atomic-host/7/x86_64/devel/continuous^)
CAHC

$centos = <<CENTOS
#!/bin/bash
set -xeuo pipefail
sudo ostree pull --commit-metadata-only --depth=1 centos-atomic-host:centos-atomic-host/7/x86_64/standard
sudo rpm-ostree deploy $(ostree rev-parse centos-atomic-host/7/x86_64/standard^)
CENTOS

$fedora23 = <<FEDORA23
#!/bin/bash
set -xeuo pipefail
sudo ostree pull --commit-metadata-only --depth=1 fedora-atomic:fedora-atomic/f23/x86_64/docker-host
sudo rpm-ostree deploy $(ostree rev-parse fedora-atomic/f23/x86_64/docker-host^)
FEDORA23

# Define the Ansible playbook you want to run here
$playbook_file = "tests/improved-sanity-test/main.yml"

Vagrant.configure(2) do |config|
    config.vm.define "cahc", autostart: false do |cahc|
        cahc.vm.box = "centos/atomic-host"
        cahc.vm.hostname = "cahc-dev"
        cahc.vm.provision "shell", inline: $cahc
        cahc.vm.provision :reload
        # Because Vagrant enforces outside-in ordering with the provisioner
        # we have to specify the same playbook in multiple places
        cahc.vm.provision "ansible" do |ansible|
            ansible.playbook = $playbook_file
        end
    end

    config.vm.define "centos" do |centos|
        centos.vm.box = "centos/atomic-host"
        centos.vm.hostname = "centosah-dev"
        centos.vm.provision "shell", inline: $centos
        centos.vm.provision :reload
        # Because Vagrant enforces outside-in ordering with the provisioner
        # we have to specify the same playbook in multiple places
        centos.vm.provision "ansible" do |ansible|
            ansible.playbook = $playbook_file
        end
    end

    config.vm.define "fedora23", autostart: false do |fedora23|
        fedora23.vm.box = "fedora/23-atomic-host"
        fedora23.vm.hostname = "fedora23ah-dev"
        fedora23.vm.provision "shell", inline: $fedora23
        fedora23.vm.provision :reload
        # Because Vagrant enforces outside-in ordering with the provisioner
        # we have to specify the same playbook in multiple places
        fedora23.vm.provision "ansible" do |ansible|
            ansible.playbook = $playbook_file
        end
    end
end
