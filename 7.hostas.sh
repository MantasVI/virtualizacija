#!/bin/bash

cd /home/mavi1016/.ansible/

cat > host.yml << "BMW"

- name: SUKURIU VISU HOST FILE SU JU PRIVATE IPS
  hosts: localhost
  become: yes
  tasks:
    - name: Read saved IPs
      set_fact:
        arno_private_ip: "{{ lookup('file', '/home/mavi1016/.ansible/arno_ip.txt') }}"
        viliaus_private_ip: "{{ lookup('file', '/home/mavi1016/.ansible/viliaus_ip.txt') }}"
        nato_private_ip: "{{ lookup('file', '/home/mavi1016/.ansible/nato_ip.txt') }}"

    - name: Write Ansible hosts inventory file
      copy:
        dest: /home/mavi1016/.ansible/hosts
        content: |
          [webserver]
          {{ arno_private_ip }} ansible_user=arba1037 ansible_ssh_pass=webserver ansible_become=yes ansible_become_pass=webserver
          [database]
          {{ viliaus_private_ip }} ansible_user=viba1062 ansible_ssh_pass=database ansible_become=yes ansible_become_pass=database
          [client]
          {{ nato_private_ip }} ansible_user=naka1314 ansible_ssh_pass=client ansible_become=yes ansible_become_pass=client
          [all]
          {{ arno_private_ip }} ansible_user=arba1037 ansible_ssh_pass=webserver ansible_become=yes ansible_become_pass=webserver
          {{ viliaus_private_ip }} ansible_user=viba1062 ansible_ssh_pass=database ansible_become=yes ansible_become_pass=database
          {{ nato_private_ip }} ansible_user=naka1314 ansible_ssh_pass=client ansible_become=yes ansible_become_pass=client
BMW
