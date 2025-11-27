#!/bin/bash

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
        api_url: "https://grid5.mif.vu.lt/cloud3/RPC2" #jungiamasi prie OpenNebula API endpoint /RPC2
        api_username: "{{ ansibleuser1 }}"
        api_password: "{{ ansiblepass1 }}"
        template_name: "client_rimtas"
        attributes:
          name: "natas_client_vm"
        state: present
      register: "natas_client_vm" #register: įsimena VM ID tam, kad galėtum jį naudoti toliau.
   
    - name: Palaukiam kol VM uzsikraus
      pause:
        seconds: 20

    - name: Gauti VM info per CLI
      shell: onevm show {{ natas_client_vm.instances_ids[0] }} --user "{{ ansibleuser1 }}" --password "{{ ansiblepass1 }}" --endpoint https://grid5.mif.vu.lt/cloud3/RPC2 #same shit as before extractina visa nato vm info ir visa ta info issaugo i vm_natas variable.
      register: vm_natas

    - name: Rodyti formatuotą VM informaciją
      debug:
        msg:
<<<<<<< HEAD
          - "{{ vm_natas.stdout_lines | select('search', 'CONNECT_INFO1') | list }}"  #suranda || CONNECT_INFO="ssh -p 5681 naka1314@193.219.91.103" ||
          - "{{ vm_natas.stdout_lines | select('search', 'PUBLIC_IP') | list }}" #suranda  || PUBLIC_IP="193.219.91.103" ||
          - "{{ vm_natas.stdout_lines | select('search', 'PRIVATE_IP') | list }}" #suranda || PRIVATE_IP="10.0.1.98" ||
          - "{{ vm_natas.stdout_lines | select('search', 'TCP_PORT_FORWARDING') | list }}"  (nu krc taspats formatas tng as )
          
=======
          - "{{ vm_natas.stdout_lines | select('search', 'CONNECT_INFO1') | list }}"
          - "{{ vm_natas.stdout_lines | select('search', 'PUBLIC_IP') | list }}"
          - "{{ vm_natas.stdout_lines | select('search', 'PRIVATE_IP') | list }}"
          - "{{ vm_natas.stdout_lines | select('search', 'TCP_PORT_FORWARDING') | list }}"
          - "{{ vm_natas.stdout_lines | select('search', 'CONNECT_INFO4') | list }}"
    
>>>>>>> 0db614e (paskutines versija veikia clientas , database, webserver tarpusavije)
    - name: sukuriu NATOOOO private ip variable
      set_fact:
        nato_private_ip: "{{ vm_natas.stdout_lines | select('search', 'PRIVATE_IP') | list | first | split('=') | last | replace('\"', '') | trim }}" 
        #  || FIRST -> || PRIVATE_IP="10.0.1.98" ||  split(=) TAMPA -> ||  [ PRIVATE_IP,"10.0.1.98" ] || last - > pasiima TIK "10.0.1.98"  || ir trim nuiima kabutes ir galiausiai gaunam  || nato_private_ip=10.0.1.98 ||

    - name: nato  private IP i txt faila
      copy:
        dest: /home/mavi1016/.ansible/nato_ip.txt    #sitas tsg ideda nato_private_ip i txt faila nes veliau reikes ji ideti i hosta.
        content: "{{ nato_private_ip }}"

BMW
