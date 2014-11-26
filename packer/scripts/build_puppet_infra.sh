#!/bin/bash -e

#if [ -z "$1" ]; then
#	echo "Please supply a local domain for the containers"
#	exit 1
#fi

if [ -z "$1" ]; then
	echo "Please provide a name for the images (NAME/puppetdb:packer, NAME/puppetmaster:packer, etc.)"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR/.."

DOMAIN=localdomain
NAME=$1

FOREMAN=foreman.json
PUPPETDB=puppetdb.json
PUPPETMASTER=puppetmaster.json

sed -r -i "s/-h=(.*\.).*\"(.*)$/-h=\1$DOMAIN\"\2/g" $FOREMAN $PUPPETDB $PUPPETMASTER
sed -r -i "s/CERT=(.*\.).*\"/CERT=\1$DOMAIN\"/g" $FOREMAN $PUPPETDB

echo -e "Building Puppetmaster image..."
packer build $PUPPETMASTER

echo -e "Importing artifact..."
docker import - $NAME/puppetmaster:packer < puppetmaster.tar > /dev/null

echo -e "Generating certificates for PuppetDB and Foreman..."

docker run --name="foreman_cert" -t $NAME/puppetmaster:packer puppet cert generate foreman.$DOMAIN > /dev/null
docker commit foreman_cert $NAME/puppetmaster:packer > /dev/null

docker run --name="puppetdb_cert" -t $NAME/puppetmaster:packer puppet cert generate puppetdb.$DOMAIN > /dev/null

echo -e "Copying certificates from the container..."
mkdir -p certs
mkdir -p private_keys

docker cp puppetdb_cert:/var/lib/puppet/ssl/certs/ca.pem certs/
docker cp puppetdb_cert:/var/lib/puppet/ssl/certs/foreman.$DOMAIN.pem certs/
docker cp puppetdb_cert:/var/lib/puppet/ssl/certs/puppetdb.$DOMAIN.pem certs/

docker cp puppetdb_cert:/var/lib/puppet/ssl/private_keys/foreman.$DOMAIN.pem private_keys/
docker cp puppetdb_cert:/var/lib/puppet/ssl/private_keys/puppetdb.$DOMAIN.pem private_keys/

docker commit puppetdb_cert $NAME/puppetmaster:packer > /dev/null

docker rm foreman_cert puppetdb_cert > /dev/null

echo -e "Building PuppetDB image..."
packer build $PUPPETDB

echo -e "Importing artifact..."
docker import - $NAME/puppetdb:packer < puppetdb.tar > /dev/null

echo -e "Building Foreman image..."
packer build $FOREMAN

echo -e "Importing artifact..."
docker import - $NAME/foreman:packer < foreman.tar > /dev/null

echo -e "Done!"
