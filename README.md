# Install and Configure iSCSI and Provision Cloud Block Store Volumes using Ansible

There are 2 main Ansible playbooks described in this document:

The first will perform a base installation and configuration of iSCSI on a newly provisioned cloud vm. 

The second playbook can be used for provisioning additional Cloud Block Store volumes after iSCSI has been already been installed and configured.


## Before you Begin:

### Provision Cloud Block Store on AWS

Retrive the Management IP Address from CloudFormation Output and Generate A Pure API Token.

- The Pure API Token can be created and retrived from the Cloud Block Store CLI or GUI.

### Install ansible on EC2 VM (control node).

This is where you will pull down the [ansible repo](https://github.com/aaronbadger/ansible.git) and run the ansible playbooks from. 

- The control node needs to have network connectivity to the Cloud Block Store management interface.

  - Ansible communicates with remote machines over the SSH protocol so be sure to allow inbound traffic on port 22.

See [Installing Ansible Control Node Requirements](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#control-node-requirements) for official documentation. 


### Install ansible on EC2 VM (managed node).

This can be done via AWS user data or after instance launch via ssh and CLI.

**AWS Supported OS:**

- Ubuntu 18.04

**AWS User Data:**

Specify The Below User Data in AWS during EC2 Launch. 

- These commands can also be executed via CLI after the EC2 Instance has been provisioned.

**Amazon Linux 2**
```
#!/bin/bash
sudo amazon-linux-extras install ansible2 -y
```

**openSUSE Leap 15.2**
```
#!/bin/bash
zypper addrepo https://download.opensuse.org/repositories/systemsmanagement/openSUSE_Leap_15.2/systemsmanagement.repo
zypper refresh
zypper install ansible
```

**Ubuntu 18.04**
```
#!/bin/bash
apt update
apt install software-properties-common -y
apt-add-repository --yes --update ppa:ansible/ansible
apt install ansible -y
```
For additional help with installing ansible, reference [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for official documentation. 


## Install and Configure iSCSI

### Playbook:

base_install_linux.yaml

**Example command:**

``ansible-playbook -i '10.0.3.164,' -i 'cloudblockstore,' --private-key='/home/ubuntu/.ssh/privatekey.pem' -e 'cloud_initiator='10.0.3.164' fa_url='10.0.1.237' volname=vol1 size=1T pure_api_token='265be729-0ccc-f79b-abf8-f94422eeaf42' ansible_user=ubuntu' base_install_linux.yaml``

**Required CLI parameters:**

``-i ',<IP address of VM storage initiator to be configured>,'``

``-i ',cloudblockstore,'``

- This is hardcoded within the ansible playbooks to allow for command-line inventory definition. DO NOT MODIFY.

``--private-key='<private SSH key path usually specified during compute provisioning>'``

``cloud_initiator='<IP address of VM storage initiator to be configured>'``

``fa_url='<IP address of the cloudblock store management interface>``

``volname=<volname> ``

``size=<volsize>``

- A volname and size are required to perform the initial iSCSI connection to the CloudBlockStore target.

``pure_api_token=<Cloud Block Store API Token>``

- A Pure API Token can be created and retrived from the Cloud Block Store CLI or GUI.

``ansible_user=<default user for ssh access to host>``


## Provision Cloud Block Store Volumes

### Playbook:

provision_storage_linux.yaml

**Example command:**

``ansible-playbook -i '10.0.3.164,' -i 'cloudblockstore,' --private-key='/home/ubuntu/.ssh/privatekey.pem' -e 'cloud_initiator='10.0.3.164' fa_url='10.0.1.237' volname=volyes size=2T pure_api_token='265be729-0ccc-f79b-abf8-f94422eeaf42' ansible_user=ubuntu' provision_storage_linux.yaml``

**Required CLI parameters:**

Required CLI parameters:

``-i ',<IP address of VM storage initiator to be configured>,'``

``-i ',cloudblockstore,'``

- This is hardcoded within the ansible playbooks to allow for command-line inventory definition. DO NOT MODIFY.

``--private-key='<private SSH key path usually specified during compute provisioning>'``

``cloud_initiator='<IP address of VM storage initiator to be configured>'``

``fa_url='<IP address of the cloudblock store management interface>``

``volname=<volname>``

``size=<volsize>``

- Specify a new volname name and volume size to be provisioned from Cloud Block Store and connected to the host.

``pure_api_token=<Cloud Block Store API Token>``

- A Pure API Token can be created and retrived from the Cloud Block Store CLI or GUI.

``ansible_user=<default user for ssh access to host>``
