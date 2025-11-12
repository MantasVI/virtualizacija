#!/bin/bash
a
cd /home/mavi1016/.ansible/

cat > viliausvm.yml << "BMW"
- name: Pradedu Viliaus VM KURTI
  become: yes
  hosts: localhost
  vars_files:
    - vault.yml
  collections:
    - community.general
  tasks: 
    - name: kuriam viliui vm
      community.general.one_vm:
        api_url: "https://grid5.mif.vu.lt/cloud3/RPC2"
        api_username: "{{ ansibleuser3 }}"
        api_password: "{{ ansiblepass3 }}"
        template_name: "database_rimtas"
        attributes:
          name: "vilius_database_vm"
        state: present
      register: vilius_database_vm

    - name: Palaukiam kol VM uzsikraus
      pause:
        seconds: 20

    - name: Gauti VM info per CLI
      shell: onevm show {{ vilius_database_vm.instances_ids[0] }} --user "{{ ansibleuser3 }}" --password "{{ ansiblepass3 }}" --endpoint https://grid5.mif.vu.lt/cloud3/RPC2
      register: vm_vilius

    - name: Rodyti formatuotą VM informaciją
      debug:
        msg:
          - "{{ vm_vilius.stdout_lines | select('search', 'CONNECT_INFO1') | list }}"
          - "{{ vm_vilius.stdout_lines | select('search', 'PUBLIC_IP') | list }}"
          - "{{ vm_vilius.stdout_lines | select('search', 'PRIVATE_IP') | list }}"
          - "{{ vm_vilius.stdout_lines | select('search', 'TCP_PORT_FORWARDING') | list }}"

    - name: sukuriu VILIAUSSSSS private ip variable
      set_fact:
        viliaus_private_ip: "{{ vm_vilius.stdout_lines | select('search', 'PRIVATE_IP') | list | first | split('=') | last | replace('\"', '') | trim }}"

    - name: viliaus ip i txt
      copy:
        dest: /home/mavi1016/.ansible/viliaus_ip.txt
        content: "{{ viliaus_private_ip }}"
BMW
