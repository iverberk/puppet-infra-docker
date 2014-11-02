#!/bin/bash

rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs && \
rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6 &&  \

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm && \
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

yum -y install puppet-3.6.2-1.el6