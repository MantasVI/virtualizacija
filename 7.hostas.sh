#!/bin/bash

cd /home/mavi1016/.ansible/

cat > host.yml << "BMW"    #SIS FAILAS BUS PALEISTAS 9.PLAYBOOKAI.SH 

- name: SUKURIU VISU HOST FILE SU JU PRIVATE IPS 
  hosts: localhost      #i ansible instaliuoju
  become: yes        #sudo
  tasks:
    - name: Read saved IPs
      set_fact:    #nustatau informacija || /home/mavi1016/.ansible/arno_ip.txt || atsirastu sitam variable  -->|| arno_private_ip || ir taip su kiekvienu ip
        arno_private_ip: "{{ lookup('file', '/home/mavi1016/.ansible/arno_ip.txt') }}"
        viliaus_private_ip: "{{ lookup('file', '/home/mavi1016/.ansible/viliaus_ip.txt') }}"
        nato_private_ip: "{{ lookup('file', '/home/mavi1016/.ansible/nato_ip.txt') }}"


 #nukopijuoju viskas kas  yra CONTENT  i sita destination (faila krc)  -->  || /home/mavi1016/.ansible/hosts ||
 #{{ arno_private_ip }} - pinging kad connectionas egzistuoja ir veliau kiekvienam su ansible galesiu siusti ka reikia kiekvienam atskirai ko reikia.
 
 ansible_user=arba1037 - nurodau useri(neprisimenu kad jis reikalingas lol)  
 
 ansible_ssh_pass=webserver - veliau darysiu ssh-copy-id del to pirmam kartui reikia imesti jusu ssh passworda

 ansible_become=yes - ar naudoti sudo? TAIP
 
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
