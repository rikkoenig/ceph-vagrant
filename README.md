# Ceph-Vagrant

This project hold the files needed to create a ceph cluster (**3 mon, 1 mgr, 1 rgw, 3 osd**) in virtualbox using vagrant.

## Requirements
You need to have the vagrant-hostmanager plugin installed prior to running.

```vagrant plugin install vagrant-hostmanager```

Before running `vagrant up`, generate an ed25519 keypair and place it in the [data](./data) directory.

`ssh-keygen -t ed25519 -f data/id_ed25519`

## Notes
At current, Ceph-Ansible will set up the OSDs, the MONs, and install a MGR on MON1 and an RGW on MON3.

Dashboard needs to be manually instantiated.
