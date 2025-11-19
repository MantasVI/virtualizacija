#!/bin/bash

cd /home/mavi1016/.ansible

cat > docker.yml << "DOC"
- name: Install Docker on all VMs
  hosts: all
  become: yes
  tasks:

    # ---------------------------------------------------------
    # CREATE ALL REQUIRED APT DIRECTORIES (FROM SCRATCH)
    # ---------------------------------------------------------
    - name: Create /var/lib/apt directory
      file:
        path: /var/lib/apt
        state: directory
        mode: "0755"

    - name: Create /var/lib/apt/lists directory
      file:
        path: /var/lib/apt/lists
        state: directory
        mode: "0755"

    - name: Create /var/lib/apt/lists/partial directory
      file:
        path: /var/lib/apt/lists/partial
        state: directory
        mode: "0755"

    # ---------------------------------------------------------
    # CREATE LOCK FILES (fixes 'could not open lock file')
    # ---------------------------------------------------------
    - name: Ensure APT lock files exist
      file:
        path: "{{ item }}"
        state: touch
        mode: "0644"
      loop:
        - /var/lib/apt/lists/lock
        - /var/lib/dpkg/lock
        - /var/lib/dpkg/lock-frontend

    # ---------------------------------------------------------
    # UPDATE APT CACHE SAFELY
    # ---------------------------------------------------------
    - name: Update apt cache
      apt:
        update_cache: yes

    # ---------------------------------------------------------
    # INSTALL DEPENDENCIES
    # ---------------------------------------------------------
    - name: Install required packages
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - lsb-release
          - gnupg
          - curl
        state: present

    # ---------------------------------------------------------
    # ADD DOCKER GPG KEY
    # ---------------------------------------------------------
    - name: Add Docker GPG key
      shell: |
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/{{ ansible_distribution | lower }}/gpg \
        | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg

    # ---------------------------------------------------------
    # ADD DOCKER REPOSITORY
    # AUTO-DETECTS UBUNTU OR DEBIAN
    # ---------------------------------------------------------
    - name: Add Docker repository
      apt_repository:
        repo: "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/{{ ansible_distribution | lower }} {{ ansible_distribution_release }} stable"
        filename: docker
        state: present

    # ---------------------------------------------------------
    # INSTALL DOCKER + COMPOSE PLUGIN
    # ---------------------------------------------------------
    - name: Install Docker engine and Compose plugin
      apt:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
          - docker-compose-plugin
        state: latest
        update_cache: yes

# =====================================================
# DEPLOY WEBSTACK ON WEBSERVER VM
# =====================================================
- name: Deploy Webstack on webserver
  hosts: webserver
  become: yes
  tasks:

    - name: Copy entire webstack directory from Ansible VM
      copy:
        src: /home/mavi1016/.ansible/webstack/
        dest: /home/arba1037/webstack/
        owner: arba1037
        group: arba1037
        mode: "0755"

    - name: Start containers using Docker Compose
      shell: |
        cd /home/arba1037/webstack
        docker compose up -d
      args:
        executable: /bin/bash
DOC
