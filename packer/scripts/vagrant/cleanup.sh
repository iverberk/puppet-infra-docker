#!/bin/sh

sudo yum -y remove kernel-headers kernel-devel gcc autoconf
sudo yum -y clean all
sudo rm -rf *.iso *.iso.?
sudo rm -rf /tmp/*

sudo rm /etc/udev/rules.d/70-persistent-net.rules

sudo sed -i 's/^HWADDR.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0
sudo sed -i 's/^UUID.*$//' /etc/sysconfig/network-scripts/ifcfg-eth0

sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -rf /EMPTY