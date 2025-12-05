#!/bin/bash

cd /home/mavi1016/.ansible/

cat > ymlkurimas.yml << "BMW"
- name: instaliuoju kas reikia opennebulai
  become: yes
  hosts: localhost
  vars_files:
    - vault.yml
  collections:
    - community.general

  tasks:
    - name: instaliuojam python packges
      apt:
        name:
          - python3
          - python3-pip
          - python3-venv
          - build-essential
        state: present
        update_cache: yes

    - name: instaliuoju pyone ir oca
      pip:
        name:
          - pyone
          - oca
        state: present
        extra_args: --break-system-packages
BMW
