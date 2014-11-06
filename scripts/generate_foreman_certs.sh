#!/bin/bash

# Create certificate directories
mkdir -p certs
mkdir -p private_keys

# Generate certificates for Foreman
docker exec -t puppetmaster puppet cert generate foreman.localdomain

# Copy the certificates from the container
docker cp puppetmaster:/var/lib/puppet/ssl/certs/ca.pem certs/
docker cp puppetmaster:/var/lib/puppet/ssl/certs/foreman.localdomain.pem certs/
docker cp puppetmaster:/var/lib/puppet/ssl/private_keys/foreman.localdomain.pem private_keys/

# Inject the certificates into the Foreman container
cat certs/ca.pem | docker exec -i foreman sh -c 'cat > /var/lib/puppet/ssl/certs/ca.pem'
cat certs/foreman.localdomain.pem | docker exec -i foreman sh -c 'cat > /var/lib/puppet/ssl/certs/foreman.localdomain.pem'
cat private_keys/foreman.localdomain.pem | docker exec -i foreman sh -c 'cat > /var/lib/puppet/ssl/private_keys/foreman.localdomain.pem'
