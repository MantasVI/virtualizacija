#!/bin/bash
a
cd /home/mavi1016/.ansible
cat > vault.yml << "safe"
ansibleuser1: "naka1314"
ansiblepass1: "sataNZetro"
ansibleuser2: "dope1157"
ansiblepass2: "h7j9gq2DWAHK"
ansibleuser3: "viba1062"
ansiblepass3: "viba1062"
ansibleuser4: "arba1037"
ansiblepass4: "arnas2005"
safe

echo "domantas" > vault.txt
ansible-vault encrypt vault.yml --vault-password-file vault.txt
