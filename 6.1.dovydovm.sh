#!/bin/bash

cd /home/mavi1016/.ansible/

cat > dovydovm.yml << "BMW"
- name: Pradedu DOVYDO VM KURTI
  become: yes
  hosts: localhost
  vars_files:
    - vault.yml
  collections:
    - community.general
  tasks:
    - name: kuriam arnui vm
      community.general.one_vm:
        api_url: "https://grid5.mif.vu.lt/cloud3/RPC2"
        api_username: "{{ ansibleuser2 }}"
        api_password: "{{ ansiblepass2 }}"
        template_name: "webserver_rimtas"
        attributes:
          name: "dovydo_vm"
        state: present
      register: dovydo_vm
BMW
