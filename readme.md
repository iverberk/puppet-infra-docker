## Introduction

This repository contains all the scripts and configuration needed to setup a local Puppet development stack (consiting of Puppetmaster, The Foreman and PuppetDB) based on Docker containers. It is fully described in my [blog post](http://www.ivoverberk.nl/docker-tutorial-puppet-and-the-foreman/).

## Usage

There are scripts and configuration files for multiple tools. You need to have the following tools installed on your system and available in your path:

* [Docker](https://www.docker.com/)
* [Packer](https://www.packer.io/)
* [Crane](https://github.com/michaelsauter/crane)
* [Librarian-puppet](https://github.com/rodjek/librarian-puppet)
* [Puppet](http://puppetlabs.com/)

#### Crane

In the root of the repository you will find a [Crane](https://github.com/michaelsauter/crane) configuration file. Use this file to adjust any settings that you would like to make to the container configuration. It is pre-configured to use my docker images but you can change it however you like. Also the DNS settings are configured for my use-case and correspond to the process described in my blog post.

#### Packer

The packer directory contains all the scripts and configuration files to build Docker images for the Puppet stack. The JSON files specify the builders and provisioners that Packer uses. You should not have to change them directly.

There is also a Puppetfile that you can use to install the required Puppet modules with librarian-puppet.

In the packer/scripts directory you will find the main [build script](https://github.com/iverberk/puppet-infra-docker/blob/master/packer/scripts/build_puppet_infra.sh) that automates the whole process of image building. You should run this script to generate new images. It is a very simple script that takes two parameters:

1. The local domain name that you wish to use for your Docker containers
2. The name for the Docker images. This allows you to push the built images to your Docker registry account

To build the images I would run:

```./build_puppet_infra.sh localdomain iverberk```

The other scripts are helpers to the main build script and should not be used directly.

The manifests directory contains Puppet configurations for the containers. There is a configuration file for PuppetDB, The Foreman and the Puppetmaster. Packer uses these scripts to run Puppet in the containers. They contain little tweaks to make everything work in my setup. You can change them however you like.

#### Scripts

In the scripts folder you will find a script that resets the password for The Foreman. It basically runs a command inside the Foreman container and prints the output to your terminal

#### Puppet environments and Hiera

The repository contains two dummy directories that are used by the Puppetmaster to look for environments and Puppet modules. The hiera directory is used to lookup Hiera data files. These directories are mapped to the containers as volumes. The Hiera configuration can be found in the packer/manifests/puppetmaster.pp configuration file. You can change the hierarchy how you want it.

