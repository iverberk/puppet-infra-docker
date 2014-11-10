#!/bin/bash -e

# Init SSL directory
puppet cert list

cp -f /tmp/certs/ca.pem /var/lib/puppet/ssl/certs/ca.pem
cp -f /tmp/certs/$CERT.pem /var/lib/puppet/ssl/certs/$CERT.pem
cp -f /tmp/private_keys/$CERT.pem /var/lib/puppet/ssl/private_keys/$CERT.pem