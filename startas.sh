#!/bin/bash

#----------SUDO/SSH PASSAI JUSU VMS--------
#NATUI |SSH/SUDO/NORMAL PASS -  client    |
#VILIUI|SSH/SUDO/NORMAL PASS -  database  |
#ARNUI |SSH/SUDO/NORMAL PASS -  webserver |


source ./kurimas1vm.sh 				# sukuria ANSIBLE VM NAUDOJANT BASH !!! 


$CSSH_CON  'bash -s' < 1.ansiInstall.sh  #1. atsiuncia ansible ir ansible galaxy collections

$CSSH_CON 'bash -s' < webserver.doc
$CSSH_CON 'bash -s' < database.doc

$CSSH_CON 'bash -s' < 2.vault.sh    #2. cia failas kuriame yra visu musu open nebula passai juos encryptina
				    #2. todel visi playbookams (9.playbookai.sh) turi buti duodami passai

$CSSH_CON 'bash -s' < 3.vmpackage.sh  #3. atsiucnia visko ka reikia per ANSIBLE kurti vmus

$CSSH_CON 'bash -s' < 4.natovm.sh    # 4.   sukuriu visiems jums vm naudojant template:rimtas_webserver,rimtas_database,rimtas_client)
				     # 4.   extractinu nato vm info poto issaugau private ip jo i txt faila

$CSSH_CON 'bash -s' < 5.viliausvm.sh 

$CSSH_CON 'bash -s' < 6.arnovm.sh 

$CSSH_CON 'bash -s' < 7.hostas.sh   # 7.  suranda kur yra KIEKVIENO PRIVATE IP txt failas issaugotas, pritaiko tai i variable ir ji ideda i host faila


$CSSH_CON 'bash -s' < 8.dockeris.sh  # 8.  sukuria kiekvienam dockeri bet cia ignorinkit jis neveikia 
                                     # 8. bet esme ir goalas kdl as visa sita dariau kad dabar galiu visiems hostams rasyti ansible playbookus ir jiems siusti dockeri,t.t

$CSSH_CON 'bash -s' < 9.playbookai.sh   # 9. playbookai paleisti visiems failams. KAD gelciau naudotis host failu turi papingint kad vm komunikuoja su vienas kitu
					# 9. tai reiskia kad man reikia ideti  ANSIBLE VM PUBLIC SSH KEY jums KIEKVIENAM i vmus
					# 9. tai as sukuriau TEMPLATE KIEKVIENAM(rimtas_webserver,rimtas_database,rimtas_client) 
					# 9. nes paleidus ta ssh-copy-id komanda praso jusu vm passwordo tai tsg iveda sudo/ssh pasus nurodytus virsuje zdz  
