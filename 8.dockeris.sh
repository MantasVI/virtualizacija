#!/bin/bash

cd /home/mavi1016/.ansible


ansible-galaxy role install geerlingguy.docker

cat > docker.yml << "DOC"
- name: Install Docker on all
  hosts: all
  tasks:
    - name: Install docker
      shell: |
        apt-get update 
        apt-get install -y docker.io

DOC



