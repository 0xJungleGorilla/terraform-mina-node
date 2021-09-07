#!/bin/bash
echo "Install Mina"
echo "deb [trusted=yes] http://packages.o1test.net release main" | sudo tee /etc/apt/sources.list.d/mina.list
sudo apt update -qq
sudo apt install -y -qq curl unzip software-properties-common mina-mainnet=1.1.5-a42bdee 

export "$(grep CODA_PRIVKEY_PASS /home/ubuntu/.mina-env)"
curl https://storage.googleapis.com/mina-seed-lists/mainnet_seeds.txt > /home/ubuntu/peers.txt
systemctl --user daemon-reload
systemctl --user start mina
systemctl --user enable mina
sudo loginctl enable-linger
