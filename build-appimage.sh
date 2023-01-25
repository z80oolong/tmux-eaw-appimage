#!/bin/sh
rm -f ./opt/releases/*.AppImage ./opt/formula/*.rb
vagrant up --provision
rsync -avz -e 'ssh -p 12022 -i ~/.vagrant.d/insecure_private_key -l vagrant' localhost:/vagrant/opt/ ./opt/
vagrant halt
