#!/bin/bash -e

# Init SSL directory
puppet cert list

cp /tmp/certs/ca.pem /var/lib/puppet/ssl/certs/ca.pem
cp /tmp/certs/$CERT.pem /var/lib/puppet/ssl/certs/$CERT.pem
cp /tmp/private_keys/$CERT.pem /var/lib/puppet/ssl/private_keys/$CERT.pem

rm -rf /tmp/certs /tmp/private_keys