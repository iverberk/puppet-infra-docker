#!/bin/bash -e

echo -e "Building Puppetmaster image..."
packer build puppetmaster.json

echo -e "Importing artifact..."
docker import - iverberk/puppetmaster:packer < puppetmaster.tar > /dev/null

echo -e "Generating certificates for PuppetDB and Foreman..."

docker run --name="foreman_cert" -t iverberk/puppetmaster:packer puppet cert generate foreman.dev.local > /dev/null
docker commit foreman_cert iverberk/puppetmaster:packer > /dev/null

docker run --name="puppetdb_cert" -t iverberk/puppetmaster:packer puppet cert generate puppetdb.dev.local > /dev/null

echo -e "Copying certificates from the container..."
mkdir -p certs
mkdir -p private_keys

docker cp puppetdb_cert:/var/lib/puppet/ssl/certs/ca.pem certs/
docker cp puppetdb_cert:/var/lib/puppet/ssl/certs/foreman.dev.local.pem certs/
docker cp puppetdb_cert:/var/lib/puppet/ssl/certs/puppetdb.dev.local.pem certs/

docker cp puppetdb_cert:/var/lib/puppet/ssl/private_keys/foreman.dev.local.pem private_keys/
docker cp puppetdb_cert:/var/lib/puppet/ssl/private_keys/puppetdb.dev.local.pem private_keys/

docker commit puppetdb_cert iverberk/puppetmaster:packer > /dev/null

docker rm foreman_cert puppetdb_cert > /dev/null

echo -e "Building PuppetDB image..."
packer build puppetdb.json

echo -e "Importing artifact..."
docker import - iverberk/puppetdb:packer < puppetdb.tar > /dev/null

echo -e "Building Foreman image..."
packer build foreman.json

echo -e "Importing artifact..."
docker import - iverberk/foreman:packer < foreman.tar > /dev/null

echo -e "Done!"
