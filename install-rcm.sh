#!/bin/sh

# Installs https://github.com/thoughtbot/rcm on Mac or (Debian-based) Linux

set -e

if [ $(command -v brew) ]
then
  brew tap thoughtbot/formulae
  brew install rcm
else
  # assume apt, I guess.
  wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -
  echo "deb http://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
  sudo apt-get update
  sudo apt-get install rcm -y
fi
