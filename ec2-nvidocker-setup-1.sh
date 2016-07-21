#!/bin/bash

# required before installing nvidia driver
sudo apt-get update
sudo apt-get install --no-install-recommends -y gcc make libc-dev
sudo apt-get install linux-image-extra-virtual
sudo reboot
