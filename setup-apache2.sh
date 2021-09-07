#!/bin/bash
sudo apt update -qq
sudo apt install -y -qq apache2
sudo systemctl start apache2.service
sudo rm -f /var/www/html/index.html
sudo echo "*  *    * * *   root    curl -s --connect-timeout 10 http://127.0.0.1:9180/metrics > /var/www/html/\$(date +'\%F-\%T-\%Z').metrics.txt" |sudo tee /etc/cron.d/collect_metrics
