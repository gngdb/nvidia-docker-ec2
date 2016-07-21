#!/bin/bash

# blacklisting nouveau etc
sudo cp blacklist-nouveau.conf /etc/modprobe.d/
echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
sudo update-initramfs -u
sudo reboot
