#!/bin/bash

cd /home/mavi1016/.ansible/

# Sukuriame ansible playbook failą ymlkurimas.yml
cat > ymlkurimas.yml << "BMW"
- name: instaliuoju kas reikia opennebulai
  become: yes                # vykdyti komandas su sudo
  hosts: localhost           # šis playbook veikia TIK ansible VM (ne kitose VM)
  vars_files:
    - vault.yml              # įtraukiame šifruotą failą su OpenNebula username/password
  collections:
    - community.general      # įgalina modulius kaip community.general.one_vm

# 1) įdiegiame Python paketus, kurie reikalingi pyone & ansible moduliam
  tasks:
    - name: instaliuojam python packges
      apt:
        name:
          - python3          # pagrindinis Python interpretatorius
          - python3-pip      # Python paketų diegimo įrankis
          - python3-venv     # virtualios Python aplinkos parama
          - build-essential  # kompiliavimo įrankiai (gcc, make...)
        state: present
        update_cache: yes    # atnaujina apt paketų sąrašą

    # 2) įdiegiame OpenNebula Python API bibliotekas
    - name: instaliuoju pyone ir oca
      pip:
        name:
          - pyone            # OpenNebula XML-RPC API Python biblioteka
          - oca              # OpenNebula Cloud API Python biblioteka
        state: present
        extra_args: --break-system-packages
        # break-system-packages leidžia pip įrašyti libs į global python,
        # nes Debian/OpenNebula konfliktuoja su pip paketo politika
        #VISAS SITAS KODAS ATSIUNCIA TAI KO REIKIA PRADETI KURTI VMUS VISIEMS
BMW
