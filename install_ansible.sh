#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Function to check if the current user has sudo privileges
has_sudo() {
    if sudo -n true 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check if the current user is root
is_root() {
    if [ "$(id -u)" -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Function to install Ansible as root
install_as_root() {
    apt update
    apt install -y software-properties-common
    apt-add-repository -y --update ppa:ansible/ansible
    apt install -y ansible
}

# Function to install Ansible with sudo privileges
install_with_sudo() {
    sudo apt update
    sudo apt install -y software-properties-common
    sudo apt-add-repository -y --update ppa:ansible/ansible
    sudo apt install -y ansible
}

# Check if user has sudo privileges or is root
if is_root; then
    install_as_root
elif [ "$(id -u)" -eq 0 ] || has_sudo; then
    install_with_sudo
fi

# Install roles
# ansible-galaxy install andrewrothstein.starship

# Run playbook
ansible-playbook master-setup.yml

