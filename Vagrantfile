# -*- mode: ruby -*-
# vi: set ft=ruby :

# This Vagrantfile defines multiple boxes that are tooled to test/run the
# sanity playbook in 'tests/improved-sanity-test/main.yml'.
#
# The playbook is configurable using the $playbook_file variable right before
# the 'Vagrant.configure()' stanza.
#
# Define the Ansible playbook you want to run here
# Alternately, you can set the 'PLAYBOOK_FILE' environment variable to
# override this value
$playbook_file = ENV['PLAYBOOK_FILE'] || "tests/improved-sanity-test/main.yml"

Vagrant.configure(2) do |config|
    config.vm.define "cahc", autostart: false do |cahc|
        cahc.vm.box = "centos/7/atomic/continuous"
        cahc.vm.box_url = "https://ci.centos.org/artifacts/sig-atomic/centos-continuous/images/cloud/latest/images/centos-atomic-host-7-vagrant-libvirt.box"
        cahc.vm.hostname = "cahc-dev"
        # Because Vagrant enforces outside-in ordering with the provisioner
        # we have to specify the same playbook in multiple places
        cahc.vm.provision "ansible" do |ansible|
            ansible.playbook = $playbook_file
        end
    end

    config.vm.define "centos" do |centos|
        centos.vm.box = "centos/atomic-host"
        centos.vm.hostname = "centosah-dev"
        # Because Vagrant enforces outside-in ordering with the provisioner
        # we have to specify the same playbook in multiple places
        centos.vm.provision "ansible" do |ansible|
            ansible.playbook = $playbook_file
        end
    end


    config.vm.define "fedora27", autostart: false do |fedora27|
        fedora27.vm.box = "fedora/27-atomic-host"
        fedora27.vm.hostname = "fedora27ah-dev"
        # Because Vagrant enforces outside-in ordering with the provisioner
        # we have to specify the same playbook in multiple places
        fedora27.vm.provision "ansible" do |ansible|
            ansible.playbook = $playbook_file
        end
    end
end
