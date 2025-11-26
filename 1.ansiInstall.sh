#!/bin/bash               

# Čia esame ANSIBLE virtualioje mašinoje (ansible-vm).
# Šitas skriptas paruošia ją dirbti – sukuria SSH raktą, įdiegia OpenNebula tools, ansible ir t. t.

# Sukuriame SSH raktą, kad vėliau galėtume be slaptažodžio kopijuoti savo PUBLIC KEY į kitų VM .ssh/authorized_keys
ssh-keygen -t ed25519 -f /home/mavi1016/.ssh/id_ed25519 -N ""

# Atnaujiname paketų sąrašą ir įdiegiame ansible ir kitus reikalingus įrankius
sudo apt update -y
sudo apt install -y ansible curl wget gnupg lsb-release

# Sukuriame specialią vietą GPG raktams (čia apt saugumo reikalavimas)
sudo mkdir -p /etc/apt/keyrings

# Atsisiunčiame OpenNebula repo viešą GPG raktą ir konvertuojame į .gpg formatą, kurį supranta APT
wget -q -O- https://downloads.opennebula.io/repo/repo2.key | \
sudo gpg --dearmor --yes -o /etc/apt/keyrings/opennebula.gpg

# Pridedame OpenNebula paketų repozitoriją į APT sources list
# Tai leidžia vykdyti komandas kaip: sudo apt install opennebula-tools
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] \
https://downloads.opennebula.io/repo/6.10/Ubuntu/24.04 stable opennebula" | \
sudo tee /etc/apt/sources.list.d/opennebula.list

# Atnaujiname APT indeksus, kad apt matytų naują repozitoriją
sudo apt-get update

# Įdiegiame OpenNebula CLI įrankius (onevm, onetemplate, vienintelis būdas kurti VM automatizuotai)
sudo apt-get install -y opennebula-tools

# Sukuriame katalogą, kuriame laikysime visus ansible playbookus, docker failus, host failą ir t.t.
mkdir -p /home/mavi1016/.ansible
cd /home/mavi1016/.ansible

# Įdiegiame Ansible Galaxy collection "community.general",
# kuri suteikia modulį `community.general.one_vm`
# BŪTINA, kad ansible galėtų kurti VM OpenNebuloje
ansible-galaxy collection install community.general --force
