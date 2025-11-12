#!/bin/bash
a
cd /home/mavi1016/.ansible/

cat > arnovm.yml << "BMW"
- name: Pradedu ARNO VM KURTI
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
        api_username: "{{ ansibleuser4 }}"
        api_password: "{{ ansiblepass4 }}"
        template_name: "webserver_rimtas"
        attributes:
          name: "arnas_webserver_vm"
        state: present
      register: arnas_webserver_vm

    - name: Palaukiam kol VM uzsikraus
      pause:
        seconds: 20

    - name: Gauti VM info per CLI
      shell: onevm show {{ arnas_webserver_vm.instances_ids[0] }} --user "{{ ansibleuser4 }}" --password "{{ ansiblepass4 }}" --endpoint https://grid5.mif.vu.lt/cloud3/RPC2
      register: vm_arnas

    - name: Rodyti formatuotą VM informaciją
      debug:
        msg:
          - "{{ vm_arnas.stdout_lines | select('search', 'CONNECT_INFO1') | list }}"
          - "{{ vm_arnas.stdout_lines | select('search', 'PUBLIC_IP') | list }}"
          - "{{ vm_arnas.stdout_lines | select('search', 'PRIVATE_IP') | list }}"
          - "{{ vm_arnas.stdout_lines | select('search', 'TCP_PORT_FORWARDING') | list }}"

    - name: sukuriu ARNOOOO private ip variable
      set_fact:
        arno_private_ip: "{{ vm_arnas.stdout_lines | select('search', 'PRIVATE_IP') | list | first | split('=') | last | replace('\"', '') | trim }}"

    - name: arno ip i txt 
      copy:
        dest: /home/mavi1016/.ansible/arno_ip.txt
        content: "{{ arno_private_ip }}"

    - name: Copy Ansible SSH key to Arnas VM
      ansible.builtin.authorized_key:
        user: mavi1016
        key: "{{ lookup('file', '/home/mavi1016/.ssh/id_ed25519.pub') }}"
        state: present
      vars:
        ansible_user: arba1037
        ansible_host: "{{ arno_private_ip }}"
        ansible_ssh_private_key_file: /mavi1016/.ssh/id_ed25519
      delegate_to: localhost
BMW
