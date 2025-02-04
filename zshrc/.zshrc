# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-nvim-appname)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# ==================================
# Initialization Section
# ==================================
# Initialize Starship ==============
eval "$(starship init zsh)"

# Initialize Homebrew
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Init zoxide
eval "$(zoxide init zsh)"

# Initialize fzf ===================
# eval "$(fzf --zsh)" # fzf 0.48.0 or later # BUG: error
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# [ -f ~/.config/fzf/fzf.zsh ] && source ~/.config/fzf/fzf.zsh

# Setup fzf theme
fzf_theme() {
  local fg="#CBE0F0"
  local bg="#011628"
  local bg_highlight="#143652"
  local purple="#B388FF"
  local blue="#06BCE4"
  local cyan="#2CF9ED"

  export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
}
# fzf_theme

fzf_func() {
  # Set default commands for fzf
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

  # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  # when type: vi, nvim ...
  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  # Use fd to generate the list for directory completion
  # when type: cd, ...
  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }

  # source ~/fzf-git.sh/fzf-git.sh

  # Preview command for fzf
  show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

  # Set fzf options with preview
  export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

  # Advanced customization of fzf options via _fzf_comprun function
  # - The first argument to the function is the name of the command.
  # - You should make sure to pass the rest of the arguments to fzf.
  _fzf_comprun() {
    local command=$1
    shift

    case "$command" in
      cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
      export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
      ssh)          fzf --preview 'dig {}'                   "$@" ;;
      *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
    esac
  }
}
# fzf_func

# Init Node
init_node() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
init_node

# Init Pyenv
init_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  # Load pyenv automatically
  eval "$(pyenv init -)"
  # Load pyenv-virtualenv automatically by adding the following to ~/.bashrc:
  eval "$(pyenv virtualenv-init -)"
}
init_pyenv

# Bun completions
[ -s "/home/eagle/.bun/_bun" ] && source "/home/eagle/.bun/_bun"

# Bun installation path
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# ==================================
# Const Section
# ==================================
# Define paths for executables
export PATH_LOCAL_BIN="/usr/local/bin/"
export PATH_FLATPAK_BIN="/var/lib/flatpak/exports/bin/"
export PATH_SNAP_BIN="/snap/bin/"
export PATH_BREW_BIN="/home/linuxbrew/.linuxbrew/opt/" # Installed apps of brews

# Define paths for applications
export PATH_LOCAL_APP="$HOME/.local/share/"
export PATH_FLATPAK_APP="/var/lib/flatpak/app/"
export PATH_SNAP_APP="/snap/"
export PATH_BREW_APP="/home/linuxbrew/.linuxbrew/Cellar/"

export PATH_TMUX_PLUGIN="$HOME/.config/tmux/plugins/"

export PATH_PRITUNL_PROFILE="/home/eagle/.config/pritunl/profiles"

# ==================================
# Aliases Section
# ==================================
# System Aliases
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias suspend='sudo pm-suspend'
alias sleep='pmset sleepnow'
alias cl='clear'
alias ex='exit'

# Navigation Aliases
alias cd="z"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Eza Aliases
alias ls="eza --icons"
alias lsa="eza --icons -a"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=3 --icons --git"

# # Folder Shortcuts
# alias doc="$HOME/Documents"
# alias dow="$HOME/Downloads"

# Miscellaneous Aliases
update() { sudo nala update && sudo nala upgrade }
bs() { browserstack --key gJjMRxK6KtMx5o9XbJsb }

mvim() { nvapp "$@" }
alias lvi="mvim LazyVim01"
alias lvi2="mvim LazyVim02"
alias avi="mvim AstroNvim01"
# alias nvi=lvi
alias nvi=nvim
# alias nvi=hx
alias E=yazi # [E]xplorer([F]iles Manager of Ubuntu) in CLI
edit() {
  # [ -f "$1" ] && nvi "$1" || z "$1" || return && nvi .
  if [ -f "$@" ]; then
    nvi "$@"
  else
    z "$@" || return
    nvi .
  fi
}

# ==================================
# Functions Section
# ==================================
# Custom Functions
cx() { cd "$@" && lsa; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { nvi "$(find . -type f -not -path '*/.*' | fzf)" }

# Config funtion
config() {
  case $1 in
    wezterm) hx ~/.config/wezterm/wezterm.lua ;;
    install) hx ~/install-linux.sh ;;
    zsh) hx ~/.zshrc ;;
    bash) hx ~/.bashrc ;;
    tmux) hx ~/.config/tmux/tmux.conf ;;
    lazyvim) edit lazyvim ;;
    git) hx ~/.gitconfig ;;
    ssh) hx ~/.ssh/ ;;
    pritunl) cd "$PATH_PRITUNL_PROFILE" && hx . ;;
    grub) sudo hx /etc/default/grub ;;
    sleep) sudo hx /etc/systemd/sleep.conf ;;
    ppa) hx /etc/apt/sources.list.d/ ;;
    # ppa) grep -r ^deb /etc/apt/sources.list.d/ ;; # installed PPAs ONLY
    # ppa) sudo apt policy ;; # all repository including PPAs
    # ppa) software-properties-gtk ;; # GUI PPAs
    *) echo "Usage: config {zsh|tmux|wezterm|nvim|pritunl}" ;;
  esac
}

# Reload function
reload() {
  case $1 in
    zsh) source ~/.zshrc ;;
    bash) source ~/.bashrc ;;
    tmux) tmux source-file ~/.config/tmux/tmux.conf ;;
    grub) sudo update-grub ;;
    *) echo "Usage: reload {zsh|tmux}" ;;
  esac
}

# List executable paths
lx() {
  case $1 in
    local) ls "$PATH_LOCAL_BIN" ;;
    flatpak) ls "$PATH_FLATPAK_BIN" ;;
    snap) ls "$PATH_SNAP_BIN" ;;
    brew) ls "$PATH_BREW_BIN" ;;
    *) echo "Usage: lx {local|flatpak|snap|brew}" ;;
  esac
}

# cd installed-apps
cdapp() {
  case $1 in
    local) cd "$PATH_LOCAL_APP" ;;
    flatpak) cd "$PATH_FLATPAK_APP" ;;
    snap) cd "$PATH_SNAP_APP" ;;
    brew) cd "$PATH_BREW_APP" ;;
    tmux) cd "$PATH_TMUX_PLUGIN" ;;
    *) echo "Usage: cdapp {flatpak|snap|local}" ;;
  esac
}

# List installed-apps
lapp() {
  case $1 in
    local) ls "$PATH_LOCAL_APP" ;;
    flatpak) ls "$PATH_FLATPAK_APP" ;;
    snap) ls "$PATH_SNAP_APP" ;;
    brew) ls "$PATH_BREW_APP" ;;
    tmux) ls "$PATH_TMUX_PLUGIN" ;;
    *) echo "Usage: lapp {flatpak|snap|local}" ;;
  esac
}

# Config installed-apps
configapp() {
  local option=$1
  local app_name=$2
  case $option in
    flatpak) cd "/home/eagle/.var/app/$app_name/config" ;;
    *) echo "Usage: configapp {flatpak|snap|local}" ;;
  esac
}

# Search available-app to install
searchapp() {
  local option=$1
  local app_name=$2

  case $option in
    apt) apt-cache madison "$app_name" ;; # apt search "$app_name" ;;
    flatpak) flatpak search "$app_name" ;;
    brew) brew search "$app_name" ;;
    *) echo "Usage: searchapp {flatpak|snap|local}" ;;
  esac
}

# Find installed-apps
findapp() {
  local app_name=$1

  find ~/ -type d -name "*$app_name*"
}

# Install an app
installapp() {
  local option=$1
  local app_name=$2
  local name=$4

  case $option in
    apt) sudo nala install "$app_name" ;;
    flatpak)
      flatpak install flathub "$app_name"
      if [ "$3" == "--name" ] && [ -n "$name" ]; then
        sudo ln -s "${PATH_FLATPAK_BIN}${app_id}" "${PATH_LOCAL_BIN}${name}"
      fi
      ;;
    brew) brew install "$app_name" ;;
    *) echo "Usage: searchapp {flatpak|snap|local}" ;;
  esac
}

# Remove an app
removeapp() {
  local option=$1
  local app_name=$2

  case $option in
    apt)
      sudo nala remove --purge "$app_name"
      sudo nala autoremove --purge
      sudo nala clean
      ;;
    flatpak)
      flatpak uninstall --delete-data "$app_name"
      flatpak uninstall --unused
      ;;
    brew)
      brew uninstall "$app_name"
      brew cleanup
      ;;
    *) echo "Usage: searchapp {flatpak|snap|local}" ;;
  esac
}

# Browse an URL in Incognito Mode
bincog() {
  local filepath=$1
  nohup google-chrome --args --incognito "$filepath" &
}

# Browse an URL in Mode of cors-disabled
bcors() {
  local filepath=$1

  nohup google-chrome --args --disable-web-security --user-data-dir "$1" &
}

# Play media by VLC
play() {
  local path=$1

  nohup vlc "$1" &
}

# Download video from Youtube
download() {
  local url=$1
  local format=${2:-mp4}

  if [ "$format" = "webm" ]; then
    yt-dlp -f "bestvideo[ext=webm]+bestaudio[ext=m4a]/best[ext=webm]" "$url"
  else
    yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" "$url"
  fi
}

# Call GPT model
gpt() {
  local model_name=${1:-deepseek-coder-v2:latest}
  shift
  local params="$@"

  if [ -z "$params" ]; then
    ollama run "$model_name"
  else
    ollama run "$model_name" $params
  fi
}
