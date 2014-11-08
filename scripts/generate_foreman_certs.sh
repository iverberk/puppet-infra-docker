#!/bin/bash

# Create certificate directories
mkdir -p certs
mkdir -p private_keys

# Generate certificates for Foreman
docker exec -t puppetmaster puppet cert generate foreman.localdomain

# Copy the certificates from the container
docker exec -t puppetmaster cat /var/lib/puppet/ssl/certs/ca.pem > certs/ca.pem
docker exec -t puppetmaster cat /var/lib/puppet/ssl/certs/foreman.localdomain.pem > certs/foreman.localdomain.pem
docker exec -t puppetmaster cat /var/lib/puppet/ssl/private_keys/foreman.localdomain.pem > private_keys/foreman.localdomain.pem

# Inject the certificates into the Foreman container
docker exec -t foreman cp -f /host/certs/ca.pem /var/lib/puppet/ssl/certs/ca.pem
docker exec -t foreman cp -f /host/certs/foreman.localdomain.pem /var/lib/puppet/ssl/certs/foreman.localdomain.pem
docker exec -t foreman cp -f /host/private_keys/foreman.localdomain.pem /var/lib/puppet/ssl/private_keys/foreman.localdomain.pem