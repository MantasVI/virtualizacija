#!/bin/bash
set -e

cd /home/mavi1016/.ansible

cat > docker.yml << "DOC"
- name: Install Docker on all VMs
  hosts: all
  become: yes
  tasks:

    - name: Make apt lists folder
      file:
        path: /var/lib/apt/lists
        state: directory
        mode: '0755'

    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install dependencies
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - lsb-release
          - gnupg
          - curl
        state: present

    - name: Add Docker GPG key
      shell: |
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/{{ ansible_distribution | lower }}/gpg \
        | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg

    - name: Add Docker repo
      apt_repository:
        repo: "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/{{ ansible_distribution | lower }} {{ ansible_distribution_release }} stable"
        filename: docker
        state: present

    - name: Install Docker
      apt:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
          - docker-compose-plugin
        state: latest
        update_cache: yes

# ===============================================================
# DEPLOY DATABASE ON VILIUS
# ===============================================================
- name: Deploy database
  hosts: database
  become: yes
  tasks:
    - name: Copy DB stack files
      copy:
        src: /home/mavi1016/.ansible/dbstack/
        dest: /home/viba1062/dbstack/
        mode: "0755"

    - name: Start MariaDB container
      shell: |
        cd /home/viba1062/dbstack
        docker compose up -d
      args:
        executable: /bin/bash

# ===============================================================
# DEPLOY WEB ON ARNAS
# ===============================================================
- name: Deploy Webstack on webserver
  hosts: webserver
  become: yes
  tasks:

    - name: Copy webstack
      copy:
        src: /home/mavi1016/.ansible/webstack/
        dest: /home/arba1037/webstack/
        mode: "0755"

    - name: Create .env file with DB settings
      copy:
        dest: /home/arba1037/webstack/.env
        content: |
          DB_HOST={{ lookup('file', '/home/mavi1016/.ansible/viliaus_ip.txt') | trim }}
          DB_PORT=3306
          DB_NAME=hospital
          DB_USER=hospital_user
          DB_PASSWORD=hospital_pass
        mode: "0600"

    - name: Start Web containers
      shell: |
        cd /home/arba1037/webstack
        docker compose up -d
      args:
        executable: /bin/bash
DOC
