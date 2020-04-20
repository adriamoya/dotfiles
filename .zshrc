# @Author: adriamoya
# @Date:   2018-11-24T22:12:13+00:00
# @Last modified by:   adriamoya
# @Last modified time: 2019-01-14T17:03:10+00:00


# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Anaconda
if [ -f "/anaconda3/etc/profile.d/conda.sh" ]; then
  export PATH="/anaconda3/bin:$PATH"
fi

# Path to the oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"
# ZSH_THEME="powerlevel9k/powerlevel9k"
# ZSH_THEME="spaceship"
# ZSH_THEME="cobalt2"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy/mm/dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins
plugins=(
  git
  docker
  kubectl
  tmux
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Sourcing oh-my-zsh and other shell helpers
source $ZSH/oh-my-zsh.sh
source $HOME/.zsh_exports
source $HOME/.zsh_aliases
# source $HOME/.bash_profile

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Powerlevel9k
# ------------------------------------------------------------------------------

# Customise the Powerlevel9k prompts (https://github.com/bhilburn/powerlevel9k#available-prompt-segments)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
 user dir vcs newline status virtualenv docker_machine
)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Load Nerd Fonts with Powerlevel9k theme for Zsh
POWERLEVEL9K_MODE='nerdfont-complete'
# source ~/powerlevel9k/powerlevel9k.zsh-theme

# Set a color for iTerm2 tab title background using rgb values
function title_background_color {
  echo -ne "\033]6;1;bg;red;brightness;$ITERM2_TITLE_BACKGROUND_RED\a"
  echo -ne "\033]6;1;bg;green;brightness;$ITERM2_TITLE_BACKGROUND_GREEN\a"
  echo -ne "\033]6;1;bg;blue;brightness;$ITERM2_TITLE_BACKGROUND_BLUE\a"
}

ITERM2_TITLE_BACKGROUND_RED="18"
ITERM2_TITLE_BACKGROUND_GREEN="26"
ITERM2_TITLE_BACKGROUND_BLUE="33"

title_background_color

# Colorls (change colors with > atom $(dirname $(gem which colorls))/yaml)
source $(dirname $(gem which colorls))/tab_complete.sh

# Enable docker completion -- no need since there is a plugin in oh-my-zsh
# fpath=(~/.zsh/completion $fpath)
# autoload -Uz compinit && compinit -i

# Enable kubernetes completion -- no need since there is a plugin in oh-my-zsh
# source <(kubectl completion zsh)

# fzf
# ------------------------------------------------------------------------------
source $HOME/.fzf.plugin.zsh

# Reverse search with fzf
_reverse_search(){
  selected_command=$(fc -rl 1 | awk '{$1="";print substr($0,2)}' | sort | uniq | fzf)
  echo $selected_command
  eval $selected_command
}

zle -N _reverse_search
bindkey '^r' _reverse_search

# Initialize Z (https://github.com/rupa/z)
. ~/z.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/adriamoya/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/adriamoya/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/adriamoya/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/adriamoya/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
export "PATH=/usr/local/opt/rabbitmq/sbin:$PATH"

# Java home path
export JAVA_HOME="/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/"
export GOOGLE_APPLICATION_CREDENTIALS="/Users/adriamoya/nemuru/keys/data-science-239811-215aac45ffef.json"

# Add kube-ps1 to PROMPT
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
export PROMPT='$(kube_ps1)'$PROMPT