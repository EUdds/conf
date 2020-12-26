#!/bin/bash
BACKUP_FOLDER="${HOME}/.oldConfigs"
SUFFIX=".erc"

function installPrograms() {
    local answer
    read -p "[Application Installation] Would you like to install Vundle (y/n) ? " -n 1 answer
    echo
    if [ "${answer}" = "y" ];
    then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    else
        echo "Skipping"
    fi

    read -p "[Application Installation] Would you like to install Python3 (This includes pip and venv) (y/n)? " -n 1 answer
    echo
    if [ "${answer}" = "y" ];
    then
        sudo apt-get install -y python3 python3-pip python-is-python3        
    else
        echo "Skipping"
    fi

        read -p "[Application Installation] Would you like to install tmux (y/n)? " -n 1 answer
    echo
    if [ "${answer}" = "y" ];
    then
        sudo apt-get install -y tmux        
    else
        echo "Skipping"
    fi
}

function setupGit() {
    local email
    read -p "[Git Config] Email: " email
    echo
    git config --global user.email "${email}"
    local name
    read -p "[Git Config] Name: " name
    git config --global user.name "${name}"
}


echo "Backing up your current conf files in ${BACKUP_FOLDER} in case you change your mind"

function safeMove() {
    local answer
    if [ "$1" = "README.md" ]; then
        return
    fi
    if [ "$1" = "install.sh" ]; then
        return
    fi
    local base_file=$(basename -s ${SUFFIX} $1)
    read  -p "[Configuration Files] Would you like to install .${base_file} (y/n)? " -n 1 answer
    echo
    if [ "${answer}" = "y" ];
    then
        mv ${HOME}/".${base_file}" ${BACKUP_FOLDER}/${base_file}
        cp $1 ${HOME}/".${base_file}"
    else
        echo "Skipping"
        return
    fi
}


if [ ! -d "${BACKUP_FOLDER}" ]; then
    mkdir ${BACKUP_FOLDER}
fi

declare -a ALL_FILES=()

ALL_FILES=$(ls *.erc)
echo "=== Updating and Upgrading Packages ==="
sudo apt-get update
sudo apt-get upgrade
echo
echo "=== Installing .rc Files ==="
for name in ${ALL_FILES[@]}; do
    safeMove "${name}"
done
echo
echo "=== Installing Programs ==="
installPrograms

echo "=== Setting up Git ID ==="
setupGit
echo

echo "=== Exiting ==="

exit 0


