#!/usr/bin/bash

set -eux

sudo pacman -Syu --noconfirm
sudo pacman -Sy --noconfirm git base-devel openssh tree libffi xonsh

sudo cp -r .ssh /home/user/.ssh
sudo chown user:user -R /home/user/.ssh
chmod 0600 /home/user/.ssh/id_rsa
ssh-keyscan -t rsa github.com >> /home/user/.ssh/known_hosts

git config --global user.email "zasdfgbnm-bot@example.com"
git config --global user.name "zasdfgbnm-bot"

sudo mkdir tmp
sudo chown user:user tmp
