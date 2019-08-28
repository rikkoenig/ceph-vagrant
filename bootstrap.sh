#!/usr/bin/env bash

sudo apt-get update
sudo apt-get upgrade -y
cat /vagrant_data/id_ed25519.pub >> /home/vagrant/.ssh/authorized_keys

#sudo reboot
