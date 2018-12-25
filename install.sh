#!/bin/bash

# Get dotfiles installation directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Backing up old dotfiles
backup_old () {

  printf "\n---> Backing up old dotfiles...\n"

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
printf "\n---> Linking Git config files...\n"
ln -sf "$DOTFILES_DIR/.gitconfig" ~
ln -sf "$DOTFILES_DIR/.gitignore_global" ~

###############################################################################
# ZSH                                                                         #
###############################################################################

install_zsh () {
  printf "\n---> Installing zsh...\n"
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

install_zsh

# Specify ZSH custom directory
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# Install the ZSH syntax highlighting plugin if it's not already installed
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
  printf "\n---> Installing Syntax highlighting\n"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Themes
###############################################################################

# Install the ZSH spaceship theme if not already installed
if [[ ! -d $HOME/.oh-my-zsh/custom/themes/spaceship-prompt ]]; then
  printf "\n---> Installing Spaceship theme\n"
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

if [[ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel9k ]]; then
  printf "\n---> Installing Powerlevel9k theme\n"
  git clone https://github.com/bhilburn/powerlevel9k.git  "$ZSH_CUSTOM/themes/powerlevel9k"
  ln -s "$ZSH_CUSTOM/themes/powerlevel9k/powerlevel9k.zsh-theme" "$ZSH_CUSTOM/themes/powerlevel9k.zsh-theme"
fi

# Color schemes
###############################################################################

# Create schemes directory if not exists
if [[ ! -d $HOME/.oh-my-zsh/custom/schemes ]]; then
  mkdir ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/schemes
fi

# Install the MaterialDark Color Scheme
if [ ! -f $HOME/.oh-my-zsh/custom/schemes/MaterialDark.itermcolors ]; then
  printf "\n---> Installing MaterialDark color scheme\n"
  curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/MaterialDark.itermcolors > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/schemes/MaterialDark.itermcolors
fi

# Install the Solarized Dark Color Scheme
if [ ! -f $HOME/.oh-my-zsh/custom/schemes/Solarized\ Dark.itermcolors ]; then
  printf "\n---> Installing Solarized Dark color scheme\n"
  curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark.itermcolors > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/schemes/Solarized\ Dark.itermcolors
fi

# Install colorls - Enhances the terminal command ls with color and icons
printf "\n---> Installing colorls\n"
sudo gem install colorls

# Fonts
###############################################################################

# Install Powerline Fonts
printf "\n---> Installing Powerline fonts\n"
pip install --user powerline-status
git clone https://github.com/powerline/fonts
. ./fonts/install.sh
rm -rf ./fonts

# Install Hack Nerd Fonts
printf "\n---> Installing Hack Nerd fonts\n"
brew tap caskroom/fonts
brew cask install font-hack-nerd-font

###############################################################################
# Z (https://github.com/rupa/z)                                               #
###############################################################################

if [ ! -f $HOME/z.sh ]; then
  printf "\n---> Installing z.sh\n"
  curl https://raw.githubusercontent.com/rupa/z/master/z.sh > $HOME/z.sh
fi


# Symlink .zshrc
printf "\n---> Symlink .zshrc .zsh_exports .zsh_aliases\n"
ln -sf "$DOTFILES_DIR/.zshrc" ~
ln -sf "$DOTFILES_DIR/.zsh_exports" ~
ln -sf "$DOTFILES_DIR/.zsh_aliases" ~
