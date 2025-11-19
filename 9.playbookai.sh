#!/bin/bash

cd /home/mavi1016/.ansible

sudo apt install sshpass

ansible-playbook --vault-password-file vault.txt ymlkurimas.yml
ansible-playbook --vault-password-file vault.txt natovm.yml
ansible-playbook --vault-password-file vault.txt viliausvm.yml
ansible-playbook --vault-password-file vault.txt arnovm.yml
ansible-playbook --vault-password-file vault.txt host.yml

sshpass -p 'database' sudo ssh-copy-id -i /home/mavi1016/.ssh/id_ed25519.pub -o StrictHostKeyChecking=accept-new  viba1062@$(cat viliaus_ip.txt)  
sshpass -p 'webserver' sudo ssh-copy-id -i /home/mavi1016/.ssh/id_ed25519.pub -o StrictHostKeyChecking=accept-new  arba1037@$(cat arno_ip.txt)
sshpass -p 'client' sudo ssh-copy-id -i /home/mavi1016/.ssh/id_ed25519.pub -o StrictHostKeyChecking=accept-new naka1314@$(cat nato_ip.txt)

ansible -i /home/mavi1016/.ansible/hosts all -m ping

ansible-playbook -i /home/mavi1016/.ansible/hosts docker.yml  -vvv --ask-become-pass 
