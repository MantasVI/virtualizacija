#!/bin/bash
a
cd /home/mavi1016/.ansible/

cat > natovm.yml << "BMW"
- name: Pradedu NATO VM KURTI
  become: yes
  hosts: localhost
  vars_files:
    - vault.yml
  collections:
    - community.general
  tasks:
    - name: kuriam natui vm
      community.general.one_vm:
        api_url: "https://grid5.mif.vu.lt/cloud3/RPC2"
        api_username: "{{ ansibleuser1 }}"
        api_password: "{{ ansiblepass1 }}"
        template_name: "client_rimtas"
        attributes:
          name: "natas_client_vm"
        state: present
      register: "natas_client_vm"

    - name: Palaukiam kol VM uzsikraus
      pause:
        seconds: 20

    - name: Gauti VM info per CLI
      shell: onevm show {{ natas_client_vm.instances_ids[0] }} --user "{{ ansibleuser1 }}" --password "{{ ansiblepass1 }}" --endpoint https://grid5.mif.vu.lt/cloud3/RPC2
      register: vm_natas

    - name: Rodyti formatuotą VM informaciją
      debug:
        msg:
          - "{{ vm_natas.stdout_lines | select('search', 'CONNECT_INFO1') | list }}"
          - "{{ vm_natas.stdout_lines | select('search', 'PUBLIC_IP') | list }}"
          - "{{ vm_natas.stdout_lines | select('search', 'PRIVATE_IP') | list }}"
          - "{{ vm_natas.stdout_lines | select('search', 'TCP_PORT_FORWARDING') | list }}"
    
    - name: sukuriu NATOOOO private ip variable
      set_fact:
        nato_private_ip: "{{ vm_natas.stdout_lines | select('search', 'PRIVATE_IP') | list | first | split('=') | last | replace('\"', '') | trim }}"

    - name: nato  private IP i txt faila
      copy:
        dest: /home/mavi1016/.ansible/nato_ip.txt
        content: "{{ nato_private_ip }}"

BMW
