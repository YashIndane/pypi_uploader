#!/usr/bin/bash

#This script installs pymod command to system

mkdir /pymod_dir
wget https://raw.githubusercontent.com/YashIndane/pypi_uploader/main/pymod.sh -P /pymod_dir
chmod +x /pymod_dir/pymod.sh
ln -s /pymod_dir/pymod.sh /bin/pymod
