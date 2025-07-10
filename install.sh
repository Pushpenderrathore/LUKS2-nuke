#!/bin/bash

sudo cp hooks/failwipe /etc/initcpio/hooks/
sudo cp hooks/failwipe_encrypt /etc/initcpio/hooks/
sudo cp install/failwipe /etc/initcpio/install
sudo cp install/failwipe_encrypt /etc/initcpio/install/
sudo chmod +x /etc/initcpio/hooks/failwipe*
sudo chmod +x /etc/initcpio/install/failwipe*
