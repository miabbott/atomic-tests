# -*- mode: ruby -*-
# vi: set ft=ruby :

# !!!NOTE!!!! This Vagrantfile requires the 'vagrant-reload' plugin
# https://github.com/aidanns/vagrant-reload

# This Vagrantfile defines multiple boxes that are tooled to test/run the
# sanity playbook in 'tests/improved-sanity-test/main.yml'. As part of the
# provisioning step, the box will be updated to the latest commit available
# on the stream it is tracking.  Unfortunately, the box will always reboot
# regardless if it has been updated or not.
#
# The playbook is configurable using the $playbook_file variable right before
# the 'Vagrant.configure()' stanza.

# These scripts are used to bring the box up to date with the latest commit
# available on the stream.
#
$cahc = <<CAHC
#!/bin/bash
set -xeuo pipefail
local=$(ostree rev-parse centos-atomic-host/7/x86_64/devel/continuous)
sudo ostree pull --commit-metadata-only --depth=1 centos-atomic-continuous:centos-atomic-host/7/x86_64/devel/continuous
remote=$(ostree rev-parse centos-atomic-host/7/x86_64/devel/continuous)
if [ "$local" != "$remote" ]; then
    sudo rpm-ostree deploy $remote
fi
CAHC

$centos = <<CENTOS
#!/bin/bash
set -xeuo pipefail
local=$(ostree rev-parse centos-atomic-host/7/x86_64/standard)
sudo ostree pull --commit-metadata-only --depth=1 centos-atomic-host:centos-atomic-host/7/x86_64/standard
remote=$(ostree rev-parse centos-atomic-host/7/x86_64/standard)
if [ "$local" != "$remote" ]; then
    sudo rpm-ostree deploy $remote
fi
CENTOS

$fedora27 = <<FEDORA27
#!/bin/bash
set -xeuo pipefail
local=$(ostree rev-parse fedora/27/x86_64/atomic-host)
sudo ostree pull --commit-metadata-only --depth=1 fedora-atomic:fedora/27/x86_64/atomic-host
remote=$(ostree rev-parse fedora/27/x86_64/atomic-host)
if [ "$local" != "$remote" ]; then
    sudo rpm-ostree deploy $remote
fi
FEDORA27

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


    config.vm.define "fedora27", autostart: false do |fedora27|
        fedora27.vm.box = "fedora/27-atomic-host"
        fedora27.vm.hostname = "fedora27ah-dev"
        fedora27.vm.provision "shell", inline: $fedora27
        fedora27.vm.provision :reload
        # Because Vagrant enforces outside-in ordering with the provisioner
        # we have to specify the same playbook in multiple places
        fedora27.vm.provision "ansible" do |ansible|
            ansible.playbook = $playbook_file
        end
    end
end
