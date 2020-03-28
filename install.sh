# @Author: adriamoya
# @Date:   2018-11-24T22:12:13+00:00
# @Last modified by:   adriamoya
# @Last modified time: 2019-01-18T11:51:53+00:00

#!/bin/bash

# Get dotfiles installation directory
# DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR=~

# Current directories
CURRENT_DIR=$(pwd)
CURRENT_SCRIPT=${0##*/}

# Files to symlink
declare -a FILES_TO_SYMLINK=(
  'fzf.plugin.zsh'
  'gitconfig'
  'gitignore_global'
  'zsh_aliases'
  'zsh_exports'
  'zshrc'
  'vimrc'
  )

# Backing up old dotfiles
backup_old () {

  echo "\n---> Backing up old dotfiles...\n"

  dir=$DOTFILES_DIR                      # dotfiles directory
  dir_backup=~/.dotfiles_old             # old dotfiles backup directory

  # Create dotfiles_old in homedir
  echo "\nCreating $dir_backup/ for backup of any existing dotfiles in ~/"
  mkdir -p $dir_backup
  echo "Done."

  # Change to the dotfiles directory
  # echo "\nChanging to the $dir/ directory..."
  # cd $dir
  # echo "Done\n"

  # Move any existing dotfiles in homedir to dotfiles_old directory,
  # then create symlinks from the homedir to any files in the ~/dotfiles directory
  # specified in $files
  for i in ${FILES_TO_SYMLINK[@]}; do
    echo "[.${i##*/}] - Moving any existing dotfiles from $dir to $dir_backup"
    cp $dir/.${i##*/} $dir_backup/  # cp ~/.${i##*/} ~/.dotfiles_old/
  done
  echo "Done."
}

backup_old

###############################################################################
# Brew                                                                        #
###############################################################################

brew_install() {
  # Ask for the administrator password upfront
  sudo -v

  # Check for Homebrew and install it if missing
  if test ! $(which brew)
  then
    echo "\n---> Installing Homebrew...\n"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Make sure we’re using the latest Homebrew
  echo "\n---> Updating brew...\n"
  brew update

  apps=(
    diff-so-fancy
    fzf
    git
    jq
    tmux
    tree
    wget
  ) # python

  echo "\nInstalling the following packages: ${apps[@]}"

  for i in ${apps[@]}; do
    if brew ls --versions "${i}" !> /dev/null; then
      echo "[${i}] installing..."
      brew install "${i}"
    else
      echo "[${i}] already installed!"
    fi
  done

  # brew install python - this will install the latest version of Python,
  # which should come packaged with PIP. If the installation is successful
  # but PIP is unavailable, you may need to re-link Python using the following
  # Terminal command:
  # brew unlink python && brew link python

  # Remove outdated versions from the cellar
  brew cleanup

  echo "Done."
}

brew_install

###############################################################################
# ZSH                                                                         #
###############################################################################

install_zsh () {
  echo "\n---> Installing zsh + oh-my-zsh...\n\n"
  # Test to see if zshell is installed.  If it is:
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    echo "Zsh already installed!"
    # Install Oh My Zsh if it isn't already present
    if [[ ! -d /.oh-my-zsh/ ]]; then
      echo "Oh-my-zsh is not present, installing..."
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    else
      echo "Oh-my-zsh already installed!"
    fi

    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      echo "setting default shell to zsh..."
      chsh -s $(which zsh)
    fi

  else
    echo "Zsh not installed..."
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
      # Not sure if it would do the trick
      echo "Reexecuting script"
      exec "$CURRENT_DIR"/"$CURRENT_SCRIPT"
    fi
  fi
  echo "Done."
}

install_zsh

# Specify ZSH custom directory
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

# Install the ZSH syntax highlighting plugin if it's not already installed
if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
  echo "\n---> Installing Syntax highlighting\n"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Themes
###############################################################################

# Install the ZSH spaceship theme if not already installed
if [[ ! -d $HOME/.oh-my-zsh/custom/themes/spaceship-prompt ]]; then
  echo "\n---> Installing Spaceship theme\n"
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

if [[ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel9k ]]; then
  echo "\n---> Installing Powerlevel9k theme\n"
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
  echo "\n---> Installing MaterialDark color scheme\n"
  curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/MaterialDark.itermcolors > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/schemes/MaterialDark.itermcolors
fi

# Install the Solarized Dark Color Scheme
if [ ! -f $HOME/.oh-my-zsh/custom/schemes/Solarized\ Dark.itermcolors ]; then
  echo "\n---> Installing Solarized Dark color scheme\n"
  curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark.itermcolors > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/schemes/Solarized\ Dark.itermcolors
fi

# Install the Solarized Dark Higher Contrast Color Scheme
if [ ! -f $HOME/.oh-my-zsh/custom/schemes/Solarized\ Dark\ Higher\ Contrast.itermcolors ]; then
  echo "\n---> Installing Solarized Dark Higher Contrast color scheme\n"
  curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Solarized%20Dark%20Higher%20Contrast.itermcolors > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/schemes/Solarized\ Dark\ Higher\ Contrast.itermcolors
fi

# Install the SpaceGray Color Scheme
if [ ! -f $HOME/.oh-my-zsh/custom/schemes/SpaceGray.itermcolors ]; then
  echo "\n---> Installing SpaceGray color scheme\n"
  curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/SpaceGray.itermcolors > ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/schemes/SpaceGray.itermcolors
fi

# Install colorls - Enhances the terminal command ls with color and icons
echo "\n---> Installing colorls\n"
sudo gem install colorls

# Adjust colorls settings
echo "\n---> Adjusting colorls settings\n"
mkdir $HOME/.config/colorls
cp ./dark_colors.yaml $HOME/.config/colorls/dark_colors.yaml
# cp $(dirname $(gem which colorls))/yaml/dark_colors.yaml ~/.config/colorls/dark_colors.yaml

# Fonts
###############################################################################

# Install Powerline Fonts
echo "\n---> Installing Powerline fonts\n"
pip install --user powerline-status
git clone https://github.com/powerline/fonts
. ./fonts/install.sh
rm -rf ./fonts

# Install Hack Nerd Fonts
echo "\n---> Installing Hack Nerd fonts\n"
brew tap caskroom/fonts
brew cask install font-hack-nerd-font

###############################################################################
# Z (https://github.com/rupa/z)                                               #
###############################################################################

if [ ! -f $HOME/z.sh ]; then
  echo "\n---> Installing z.sh\n"
  curl https://raw.githubusercontent.com/rupa/z/master/z.sh > $HOME/z.sh
fi

# Symlinking files
echo "\n---> Symlinking dotfiles...\n"
for i in ${FILES_TO_SYMLINK[@]}; do
  ln -sf "$CURRENT_DIR/.${i##*/}" "$DOTFILES_DIR/.${i##*/}"  # cp ~/.${i##*/} ~/.dotfiles_old/
  echo "[.${i##*/}] - Symlinked."
done
echo "Done."
