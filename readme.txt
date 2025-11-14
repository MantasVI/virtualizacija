
#----------SUDO/SSH PASSAI JUSU VMS--------
#NATUI |SSH/SUDO/NORMAL PASS -  client    |
#VILIUI|SSH/SUDO/NORMAL PASS -  database  |
#ARNUI |SSH/SUDO/NORMAL PASS -  webserver |

kurimas1vm.sh           -  0. sukuria ANSIBLE VM NAUDOJANT BASH !!

1.ansiInstall.sh         - 1. atsiuncia ansible ir ansible galaxy collections

2.vault.sh               - 2. cia failas kuriame yra visu musu open nebula passai juos encryptina  todel visi playbookams (9.playbookai.sh) turi buti duodami passai

3.vmpackage.sh           - 3. atsiucnia visko ka reikia per ANSIBLE kurti vmus

4.natovm.sh   		 - 4,5,6.   sukuriu visiems jums vm naudojant template : (rimtas_webserver,rimtas_database,rimtas_client) extractinu nato vm info poto issaugau private ip jo i txt faila
5.viliausvm.sh
6.arnovm.sh


7.hostas.sh  		 - 7.  suranda kur yra KIEKVIENO PRIVATE IP txt failas issaugotas, pritaiko tai i variable ir ji ideda i host faila

8.dockeris.sh 		 - 8.  sukuria kiekvienam dockeri bet cia ignorinkit jis neveikia
			   8. bet esme ir goalas kdl as visa sita dariau kad dabar galiu visiems hostams rasyti ansible playbookus ir jiems siusti dockeri,t.t


9.playbookai.sh          - 9. playbookai paleisti visiems failams. KAD gelciau naudotis host failu turi papingint kad vm komunikuoja su vienas kitu
                           9. tai reiskia kad man reikia ideti  ANSIBLE VM PUBLIC SSH KEY jums KIEKVIENAM i vmus
                           9. tai as sukuriau TEMPLATE KIEKVIENAM(rimtas_webserver,rimtas_database,rimtas_client)
                           9. nes paleidus ta ssh-copy-id komanda praso jusu vm passwordo tai tsg iveda sudo/ssh pasus nurodytus virsuje zdz
