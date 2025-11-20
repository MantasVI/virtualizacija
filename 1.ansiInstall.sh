#!/bin/bash

ssh-keygen -t ed25519 -f /home/mavi1016/.ssh/id_ed25519 -N ""

sudo apt update -y
sudo apt install -y ansible curl wget gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings

wget -q -O- https://downloads.opennebula.io/repo/repo2.key | \
sudo gpg --dearmor --yes -o /etc/apt/keyrings/opennebula.gpg

echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] \
https://downloads.opennebula.io/repo/6.10/Ubuntu/24.04 stable opennebula" | \
sudo tee /etc/apt/sources.list.d/opennebula.list

sudo apt-get update
sudo apt-get install -y opennebula-tools

mkdir -p  /home/mavi1016/.ansible
cd /home/mavi1016/.ansible

ansible-galaxy collection install community.general --force
