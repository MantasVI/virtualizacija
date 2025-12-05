#!/bin/bash

#----------SUDO/SSH PASSAI JUSU VMS--------
#NATUI |SSH/SUDO/NORMAL PASS -  client    |
#VILIUI|SSH/SUDO/NORMAL PASS -  database  |
#ARNUI |SSH/SUDO/NORMAL PASS -  webserver |


source ./kurimas1vm.sh


$CSSH_CON  'bash -s' < 1.ansiInstall.sh 

$CSSH_CON 'bash -s' < webstack.sh
$CSSH_CON 'bash -s' < db_setup.sh

$CSSH_CON 'bash -s' < 2.vault.sh    

$CSSH_CON 'bash -s' < 3.vmpackage.sh 

$CSSH_CON 'bash -s' < 4.natovm.sh

$CSSH_CON 'bash -s' < 5.viliausvm.sh 

$CSSH_CON 'bash -s' < 6.arnovm.sh 

$CSSH_CON 'bash -s' < 6.1.dovydovm.sh

$CSSH_CON 'bash -s' < 7.hostas.sh


$CSSH_CON 'bash -s' < 8.dockeris.sh 

$CSSH_CON 'bash -s' < 9.playbookai.sh 
