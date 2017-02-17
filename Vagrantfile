# -*- mode: ruby -*-
# vi: set ft=ruby :

# !!!NOTE!!!! This Vagrantfile requires the 'vagrant-reload' plugin
# https://github.com/aidanns/vagrant-reload

# This Vagrantfile defines multiple boxes that are tooled to test/run the
# sanity playbook in 'tests/improved-sanity-test/main.yml'.
#
# Each box boots into the OS, deploys HEAD^ of a particular tree, then runs
# the playbook (which currently includes upgrading to HEAD of the same tree).
#
# The playbook is configurable using the $playbook_file variable right before
# the 'Vagrant.configure()' stanza.

# Define scripts to deploy HEAD^ of various trees
# - HEAD^ of CAHC
# - HEAD^ of base CentOS AH
# - HEAD^ of Fedora 24 AH
# - HEAD^ of Fedora 25 AH
#
$cahc = <<CAHC
#!/bin/bash
set -xeuo pipefail
sudo rpm-ostree deploy $(ostree rev-parse centos-atomic-host/7/x86_64/devel/continuous^)
CAHC

$centos = <<CENTOS
#!/bin/bash
set -xeuo pipefail
current=$(ostree rev-parse centos-atomic-host/7/x86_64/standard)
sed -i 's|true|false|' /etc/ostree/remotes.d/centos-atomic-host.conf
sudo ostree pull --commit-metadata-only --depth=1 centos-atomic-host:centos-atomic-host/7/x86_64/standard
sed -i 's|false|true|' /etc/ostree/remotes.d/centos-atomic-host.conf
minusone=$(ostree rev-parse centos-atomic-host/7/x86_64/standard^)
if [ "$current" != "$minusone" ] ; then
    sudo rpm-ostree deploy $minusone
fi
CENTOS

$fedora24 = <<FEDORA24
#!/bin/bash
set -xeuo pipefail
sudo ostree pull --commit-metadata-only --depth=1 fedora-atomic:fedora-atomic/24/x86_64/docker-host
sudo rpm-ostree deploy $(ostree rev-parse fedora-atomic/24/x86_64/docker-host^)
FEDORA24

$fedora25 = <<FEDORA25
#!/bin/bash
set -xeuo pipefail
sudo ostree pull --commit-metadata-only --depth=1 fedora-atomic:fedora-atomic/25/x86_64/docker-host
sudo rpm-ostree deploy $(ostree rev-parse fedora-atomic/25/x86_64/docker-host^)
FEDORA25

# Define the Ansible playbook you want to run here
# Alternately, you can set the 'PLAYBOOK_FILE' environment variable to
# override this value
$playbook_file = ENV['PLAYBOOK_FILE'] || "tests/improved-sanity-test/main.yml"

Vagrant.configure(2) do |config|
    config.vm.define "cahc", autostart: false do |cahc|
        cahc.vm.box = "centos/7/atomic/continuous"
        cahc.vm.box_url = "https://ci.centos.org/artifacts/sig-atomic/centos-continuous/images/cloud/latest/images/centos-atomic-host-7-vagrant-libvirt.box"
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

    config.vm.define "fedora24", autostart: false do |fedora24|
        fedora24.vm.box = "fedora/24-atomic-host"
        fedora24.vm.hostname = "fedora24ah-dev"
        fedora24.vm.provision "shell", inline: $fedora24
        fedora24.vm.provision :reload
        # Change folder sync
        # https://pagure.io/pungi-fedora/issue/26
        fedora24.vm.synced_folder "./", "/vagrant", disabled: 'true'
        fedora24.vm.synced_folder "./", "/var/vagrant"
        # Because Vagrant enforces outside-in ordering with the provisioner
        # we have to specify the same playbook in multiple places
        fedora24.vm.provision "ansible" do |ansible|
            ansible.playbook = $playbook_file
        end
    end

    config.vm.define "fedora25", autostart: false do |fedora25|
        fedora25.vm.box = "fedora/25-atomic-host"
        fedora25.vm.hostname = "fedora25ah-dev"
        fedora25.vm.provision "shell", inline: $fedora25
        fedora25.vm.provision :reload
        # Change folder sync
        # https://pagure.io/pungi-fedora/issue/26
        fedora25.vm.synced_folder "./", "/vagrant", disabled: 'true'
        fedora25.vm.synced_folder "./", "/var/vagrant"
        # Because Vagrant enforces outside-in ordering with the provisioner
        # we have to specify the same playbook in multiple places
        fedora25.vm.provision "ansible" do |ansible|
            ansible.playbook = $playbook_file
        end
    end
end
