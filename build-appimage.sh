#!/bin/sh
rm -f ./opt/releases/*.AppImage ./opt/formula/*.rb
if [ "x${VAGRANT_WSL_ENABLE_WINDOWS_ACCESS}" != "x" ]; then
  unset VAGRANT_WSL_ENABLE_WINDOWS_ACCESS
  unset VAGRANT_HOME
fi
vagrant up --provision
rsync -avz -e 'ssh -p 12022 -i ~/.vagrant.d/insecure_private_key -l vagrant' localhost:/vagrant/opt/ ./opt/
vagrant halt
