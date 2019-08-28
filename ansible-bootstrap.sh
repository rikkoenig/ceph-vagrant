#!/usr/bin/env bash

#sudo apt-add-repository ppa:ansible/ansible-2.6 
#sudo apt-get update
sudo apt-get install ansible -y
sudo apt-get install -y python-pip
sudo -H pip install --upgrade pip
cp /vagrant_data/id_e* /home/vagrant/.ssh/

#ssh-keyscan -H -t ecdsa-sha2-nistp256 mon1 >> ~/.ssh/known_hosts
#ssh-keyscan -H -t ecdsa-sha2-nistp256 mon2 >> ~/.ssh/known_hosts
#ssh-keyscan -H -t ecdsa-sha2-nistp256 mon3 >> ~/.ssh/known_hosts
#ssh-keyscan -H -t ecdsa-sha2-nistp256 osd1 >> ~/.ssh/known_hosts
#ssh-keyscan -H -t ecdsa-sha2-nistp256 osd2 >> ~/.ssh/known_hosts
#ssh-keyscan -H -t ecdsa-sha2-nistp256 osd3 >> ~/.ssh/known_hosts

sudo cp /vagrant_data/ansible-hosts /etc/ansible/hosts
git clone https://github.com/ceph/ceph-ansible.git
cd ceph-ansible
git checkout stable-3.2

sudo -H pip install -r /home/vagrant/ceph-ansible/requirements.txt
#sudo mkdir /etc/ansible/fetch
mkdir /home/vagrant/ceph-ansible/fetch
#sudo chown vagrant /etc/ansible/fetch
ln -s /vagrant_data/osds.yml /home/vagrant/ceph-ansible/group_vars
ln -s /vagrant_data/all.yml /home/vagrant/ceph-ansible/group_vars
mv /home/vagrant/ceph-ansible/site.yml.sample /home/vagrant/ceph-ansible/site.yml

cd /home/vagrant/ceph-ansible
ansible-playbook ./site.yml
