#!/bin/bash

cd /home/mavi1016/.ansible

ansible-galaxy role install geerlingguy.docker


cat > docker.yml << "DOC"
- name: Install Docker on all
  hosts: all
  become: true
  tasks:
    - name: Install docker 
      shell: | 
        apt-get update
        apt-get install -y docker.io

- name: Copy Dockerfile to webserver
  hosts: webserver
  become: true
  tasks:
    - name: Copy Dockerfile.data
      copy:
        src: /home/mavi1016/.ansible/Dockerfile.data
        dest: /home/arba1037/Dockerfile

- name: Copy Dockerfile to database
  hosts: database
  become: true
  tasks:
    - name: Copy DockerfileData
      copy:
        src: /home/mavi1016/.ansible/DockerfileData
        dest: /home/viba1062/DockerfileData

- name: Run LAMP webserver container
  hosts: webserver
  become: true
  tasks:
    - name: Build and run custom webserver container
      shell: |
        cd /home/arba1037
        docker build -f DockerfileWeb -t lamp-webserver .
        docker run -dit --name webserver -p 80:80 lamp-webserver


- name: Run LAMP database container
  hosts: database
  become: true
  tasks:
    - name: Build and run custom database container
      shell: |
        cd /home/viba1062
        docker build -f DockerfileData -t database .
        docker run -dit --name database -p 80:80 database
DOC


