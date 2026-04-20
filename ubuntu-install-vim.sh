#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt install -y vim python3 nodejs npm

# Install Yarn globally
sudo npm install -g yarn

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy the .vimrc file to the home directory
cp .vimrc ~/.vimrc

# Install the plugins specified in .vimrc
vim +PlugInstall +qa

# Install Coc extensions
vim +CocInstall coc-pyright +qa

echo "Vim setup complete!"
