# Agave VM Image Creator  

## Overview  
This repository contains a [Packer](https://packer.io) template and [Ansible](https://ansible.io) playbook to build the default base VM image used by the Agave Platform to host its docker services. By default, the playbook will build an Ubuntu 16.04 image and publish it to the Indiana University Jetstream (OpenStack) cluster.

## Requirements

The only pre-requisite to run the vm image creator is that Docker must be installed on the system where the Packer template is run.

## Running

Before running the Packer template, you need to initialize your environment by sourcing your _openrc.sh_ config file. You can read more about how to obtain an source your Jetstream openrc.sh file from the [Jetstream Wiki](https://iujetstream.atlassian.net/wiki/spaces/JWT/pages/39682064/Setting+up+openrc.sh).


```
. ~/.openstack/openrc.sh
```  

If you have not yet set up a default network to use when launching instances, you will need one for Packer to use to connect to your new VM. The following commands should configure one for you.

```
./openstack-network-setup.sh
```  

Once you have a network configured, you can run the `packer.json` template.

```  
docker run --env-file=$(pwd)/.openstack.env \
     --rm -it -v $(pwd):/data  \
     hashicorp/packer:full build -var-file=/data/openstack/iu-jetstream/variables.json /data/openstack/iu-jetstream/packer.json

```

A successful run will result in the following text being printed at the end of the command output. The image id will, of course, differ every time you run the template.

```
...
==> Builds finished. The artifacts of successful builds are:
--> openstack: An image was created: cbf4645f-91af-45d3-9f56-0c0df37b6031
--> openstack:
```  

The resulting image ID can then be used by the [agaveplatform/terraform-provisioner](https://github.com/agaveplatform/terraform-provisioner) project to instantiate or reconfigure your Agave training infrastucture.  

## Customizing the build

If you are running somewhere other than the IU Jetstream cloud, you will need to change the id of the OpenStack image Packer will provision to build your final image. You can change this by creating a `variables.json` file and overriding any variables you need to in there. See the different openstack target environments under the `openstack` folder for examples on several national cloud systems.

```  
docker run --env-file=$(pwd)/.openstack.env \
     --rm -it -v $(pwd):/data  \
     hashicorp/packer:full build -var-file=/data/openstack/iu-jetstream/variables.json /data/openstack/iu-jetstream/packer.json

```
