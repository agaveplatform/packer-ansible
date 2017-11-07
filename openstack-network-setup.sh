#! /bin/bash
# This file configures a default network that Packer will use to provision
# the OpenStack VM from which you will build your final images. This script
# should ONLY BE RUN ONCE!
#
# If you already have a network set up and have launched VM instances before,
# then skip this section and substitute the name of your network with the
# openstack_network_id variable
#

# copy your openstack environment into a file we'll source later
if [[ ! -f .openstack.env ]]; then
  env | grep "OS_" >> .openstack.env
fi

# Create a private network
openstack network create ${OS_USERNAME}-api-net

# Verify that the private network was created
openstack network list

# Create a subnet within the private network space
openstack subnet create --network ${OS_USERNAME}-api-net --subnet-range 10.0.0.0/24 ${OS_USERNAME}-api-subnet1

# Verify that subnet was created
openstack subnet list

# Create a router
openstack router create ${OS_USERNAME}-api-router

# Connect the newly created subnet to the router
openstack router add subnet ${OS_USERNAME}-api-router ${OS_USERNAME}-api-subnet1

# Connect the router to the gateway named "public"
openstack router set --external-gateway public ${OS_USERNAME}-api-router

# Verify that the router has been connected to the gateway
openstack router show ${OS_USERNAME}-api-router
