#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo Setting up configs

# SSH (first to fail fast if /mnt is not mounted)
mkdir -p $HOME/.ssh
cp /mnt/src/id_rsa $HOME/.ssh
cp /mnt/src/id_rsa.pub $HOME/.ssh

# Fonts
mkdir -p $HOME/.config/fontconfig/conf.d
rm -f $HOME/.config/fontconfig/conf.d/10-powerline-symbols.conf
ln -s -r $DIR/.config/fontconfig/conf.d/10-powerline-symbols.conf $HOME/.config/fontconfig/conf.d

# git setup
rm -f $HOME/.gitconfig
ln -s $DIR/.gitconfig $HOME/.gitconfig

# docker
sudo systemctl enable docker.service
sudo cp $DIR/etc/systemd/system/docker.service /etc/systemd/system/docker.service

# .Xresources (DPI + rofi)
rm -f $HOME/.Xresources
ln -s $DIR/.Xresources $HOME/.Xresources

# Scripts
rm -rf $HOME/scripts
ln -s $DIR/scripts $HOME/scripts

# Fish
mkdir -p $HOME/.config/fish
mv $HOME/.config/fish/config.fish $HOME/.config/fish/config.fish.bak > /dev/null || true
ln -s $DIR/.config/fish/config.fish $HOME/.config/fish/config.fish

# tmux.conf
mv $HOME/.tmux.conf $HOME/.tmux.conf.bak > /dev/null || true
ln -s $DIR/.tmux.conf $HOME/.tmux.conf

# Enable italics in tmux
tic $DIR/xterm-256color-italic.terminfo

# i3
mkdir -p $HOME/.config/i3
mv $HOME/.config/i3/config $HOME/.config/i3/config.bak > /dev/null || true
ln -s $DIR/.config/i3/config $HOME/.config/i3/config
mkdir -p $HOME/.config/i3blocks
mv $HOME/.config/i3blocks/i3blocks.conf $HOME/.config/i3blocks/i3blocks.conf.bak > /dev/null || true
ln -s $DIR/.config/i3blocks/i3blocks.conf $HOME/.config/i3blocks/i3blocks.conf

# Screen hotplug setup
sudo cp $DIR/etc/systemd/system/hotplug.service /etc/systemd/system/hotplug.service
sudo cp $DIR/etc/systemd/system/synergyc.service /etc/systemd/system/synergyc.service
sudo cp $DIR/etc/udev/rules.d/95-monitor-hotplug.rules /etc/udev/rules.d
sudo cp $DIR/etc/udev/rules.d/95-monitor-hotplug2.rules /etc/udev/rules.d
sudo udevadm control --reload-rules
