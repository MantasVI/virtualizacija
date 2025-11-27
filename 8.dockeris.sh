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
# CLIENT VM – GUI + XRDP + Firefox + Auto-session Fix
# ===============================================================
- name: Setup client GUI + RDP
  hosts: client
  become: yes

  tasks:

    - name: Ensure client user exists
      user:
        name: naka1314
        state: present
        shell: /bin/bash

    - name: Ensure home directory exists
      file:
        path: /home/naka1314
        state: directory
        owner: naka1314
        group: naka1314
        mode: '0755'

    - name: Initialize Xorg session files (fixes XRDP login)
      shell: |
        sudo -u naka1314 mkdir -p /home/naka1314/.config
        sudo -u naka1314 mkdir -p /home/naka1314/.local
        sudo -u naka1314 mkdir -p /home/naka1314/.cache
        sudo -u naka1314 touch /home/naka1314/.Xauthority
      args:
        executable: /bin/bash

    - name: Preselect lightdm to avoid installer freeze
      shell: |
        echo "lightdm shared/default-x-display-manager select lightdm" | debconf-set-selections

    - name: Force XRDP to use LXDE
      copy:
        dest: /home/naka1314/.xsession
        content: "lxsession\n"
        owner: naka1314
        group: naka1314
        mode: "0755"

    - name: Install LXDE + XRDP + Firefox (FAST GUI)
      apt:
        name:
          - lxde
          - xrdp
          - firefox # correct package for Debian 12
        state: present
        update_cache: yes

    - name: Enable XRDP service
      systemd:
        name: xrdp
        enabled: yes
        state: started

    - name: Add user to ssl-cert group (required for XRDP)
      user:
        name: naka1314
        groups: ssl-cert
        append: yes

    - name: Restart XRDP
      systemd:
        name: xrdp
        state: restarted

    - name: Reboot VM
      reboot:
        msg: "Rebooting to activate GUI + XRDP"
        reboot_timeout: 300
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

