#!/bin/sh

if [ -n "$(cat /etc/hosts | grep vhcalnplci.dummy.nodomain )" ]; then
  echo "Seems the system configs already patched, skipping"
  exit 0
fi

echo "Patching /etc/hosts ..."
echo "10.0.2.15 vhcalnplci vhcalnplci.dummy.nodomain" | sudo tee -a /etc/hosts
sudo sed -i.bak '/127.*vhcalnplci/d' /etc/hosts

echo "Local start/stopsap scripts..."
mkdir -p $HOME/.local/bin
cp /vagrant/scripts/startsap.sh $HOME/.local/bin
cp /vagrant/scripts/stopsap.sh $HOME/.local/bin
chmod +x $HOME/.local/bin/startsap.sh
chmod +x $HOME/.local/bin/stopsap.sh

echo "Enabling uuidd ..."
sudo systemctl enable uuidd.service
sudo service uuidd start

echo "Installing packages (mc, csh, etc) ..."
sudo apt-get -q update
sudo apt-get -y -q --no-install-recommends install mc csh libaio1 unrar expect
