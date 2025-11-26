#!/bin/bash
if ! command -v onevm; then 

sudo apt install -y curl wget gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings #direktorija gpg raktui
wget -q -O- https://downloads.opennebula.io/repo/repo2.key | \    
    sudo gpg --dearmor --yes -o /etc/apt/keyrings/opennebula.gpg    #    Atsisiunčia OpenNebula oficialų raktą Konvertuoja jį į APT tinkamą formatą Išsaugo kaip failą:





echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] \
https://downloads.opennebula.io/repo/6.10/Ubuntu/24.04 stable opennebula" | \    #nurodo apt iš kur tuos paketus gauti AKA leidzia sudo apt install openenbula tools 
sudo tee /etc/apt/sources.list.d/opennebula.list 

sudo apt-get update
sudo apt-get install -y opennebula-tools

else

ssh-add    #prideda private ssh key i agenta leidzia jungtis be slaptazodzio
CUSER=mavi1016
CPASS=Kietasislapas1
CENDPOINT=https://grid5.mif.vu.lt/cloud3/RPC2    #Tai API end-point’as, per kurį OpenNebula priima komandas ir grąžina rezultatus
template="ansible_rimtas"
VMname="ansiblas"
CVMREZ=$(onetemplate instantiate $template --name $VMname --user $CUSER --password $CPASS  --endpoint $CENDPOINT) # cai pvz as issiunciu savo info ir ka noriu kad serveris padarytu  as noriu kad jis (INSTANTIATE) ir poto grazina atsakyma
CVMID=$(echo $CVMREZ |cut -d ' ' -f 3) #iskarpau ||| VM ID: 350724 |||  kad liktu tik : ||| 350724 |||
echo $CVMID

echo "Waiting for VM to RUN 20 sec."
sleep 40

$(onevm show $CVMID  --user $CUSER --password $CPASS  --endpoint $CENDPOINT >$CVMID.txt) # parodo visa vm info : || PUBLIC_IP PRIVATE_IP CONNECT_INFO1 (SSH login) CPU / RAM / DISK Network detalės Template Ports || ir sutalpina juos i faila 
CSSH_CON=$(cat $CVMID.txt | grep CONNECT\_INFO1| cut -d '=' -f 2 | tr -d '"'|sed 's/'$CUSER'/root/') # randa  is failo ||  CONNECT_INFO1="ssh -p 4565 arba1037@193.219.91.103"  || ir  iskerpa  ir pasalina kabutes kad liktu tik  || ssh -p 4565 arba1037@193.219.91.103 || ir pervadina useri i root !!! |||
CSSH_PRIP=$(cat $CVMID.txt | grep PRIVATE\_IP| cut -d '=' -f 2 | tr -d '"') # tapati tik private ip extractina 
echo "Connection string: $CSSH_CON"
echo "Local IP: $CSSH_PRIP"
fi
echo "STAGE 1 SUKURTAS ANSIBLE VM"
