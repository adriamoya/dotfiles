#!/bin/bash

# Get dotfiles installation directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Backing up old dotfiles
backup_old () {

  dir=~/.dotfiles                        # dotfiles director
  dir_backup=~/.dotfiles_old             # old dotfiles backup directory

  # Create dotfiles_old in homedir
  echo -n "Creating $dir_backup for backup of any existing dotfiles in ~..."
  mkdir -p $dir_backup
  echo "done"

  # Change to the dotfiles directory
  echo -n "Changing to the $dir directory..."
  cd $dir
  echo "done"

  declare -a FILES_TO_SYMLINK=(
  'gitconfig'
  'gitignore_global'
  'zsh_aliases'
  'zsh_exports'
  'zshrc'
  )

  # Move any existing dotfiles in homedir to dotfiles_old directory,
  # then create symlinks from the homedir to any files in the ~/dotfiles directory
  # specified in $files
  for i in ${FILES_TO_SYMLINK[@]}; do
    echo "Moving any existing dotfiles from ~ to $dir_backup"
    cp ~/.${i##*/} ~/.dotfiles_old/
  done
}

backup_old


###############################################################################
# Git                                                                         #
###############################################################################

# .gitconfig and .gitignore_global
ln -sf "$DOTFILES_DIR/.gitconfig" ~
ln -sf "$DOTFILES_DIR/.gitignore_global" ~

###############################################################################
# ZSH                                                                         #
###############################################################################

install_zsh () {
  # Test to see if zshell is installed.  If it is:
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Install Oh My Zsh if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      chsh -s $(which zsh)
    fi
  else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install zsh
        install_zsh
      fi
      if [[ -f /etc/debian_version ]]; then
        sudo apt-get install zsh
        install_zsh
      fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
      echo "We'll install zsh, then re-run this script!"
      brew install zsh
      exit
    fi
  fi
}

# install_zsh

# Specify ZSH custom directory
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# Install the ZSH spaceship theme if not already installed
if [[ ! -d $HOME/.oh-my-zsh/custom/themes/spaceship-prompt ]]; then
	git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
	ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

# Install the ZSH syntax highlighting plugin if it's not already installed
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Symlink .zshrc
ln -sf "$DOTFILES_DIR/.zshrc" ~
ln -sf "$DOTFILES_DIR/.zsh_exports" ~
ln -sf "$DOTFILES_DIR/.zsh_aliases" ~
