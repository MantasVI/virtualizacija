#!/bin/bash
a
cd /home/mavi1016/.ansible

cat > docker.yml << "DOC"
- name: instaliuoju visiems dockeri
  hosts: client,webserver,database
  become: yes
  tasks:
    - name: docker.io
      apt:
        name: docker.io
        state: present
DOC
