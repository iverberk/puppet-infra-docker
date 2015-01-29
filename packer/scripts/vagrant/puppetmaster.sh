#!/bin/bash

rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs && \
rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6 &&  \

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm && \
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum -y install http://yum.theforeman.org/releases/1.6/el6/x86_64/foreman-release.rpm

yum -y install puppet-3.6.2-1.el6

hostname puppetmaster.localdomain
sed -i 's/^HOSTNAME=.*$/HOSTNAME=puppetmaster.localdomain/' /etc/sysconfig/network-scripts/ifcfg-eth0
echo "127.0.0.1	puppetmaster.localdomain" >> /etc/hosts
service network restart