#!/usr/bin/bash

sudo pacman -S --noconfirm git base-devel openssh

cp -r .ssh /home/user/.ssh
sudo chown user:user -R /home/user/.ssh

git config --global user.email "zasdfgbnm-bot@example.com"
git config --global user.name "zasdfgbnm-bot"
