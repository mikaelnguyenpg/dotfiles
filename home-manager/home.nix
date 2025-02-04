{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "eagle";
  home.homeDirectory = "/home/eagle";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.git
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.lazygit
    pkgs.lf
    pkgs.ripgrep
    pkgs.xclip
    pkgs.yazi
    pkgs.zoxide

    pkgs.vim
    pkgs.neovim
    pkgs.helix
    pkgs.tmux
    
    pkgs.direnv
    pkgs.zsh

    pkgs.bun
    pkgs.nodejs_22
    pkgs.yarn

    pkgs.vlc
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".zshrc".source = ~/dotfiles/zshrc/.zshrc;
    # ".config/wezterm".source = ~/dotfiles/wezterm;
    # ".config/skhd".source = ~/dotfiles/skhd;
    ".config/starship".source = ~/dotfiles/starship;
    # ".config/zellij".source = ~/dotfiles/zellij;
    ".config/nvim".source = ~/dotfiles/nvim;
    ".config/helix".source = ~/dotfiles/helix;
    ".config/nix".source = ~/dotfiles/nix;
    # ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
    # ".config/tmux".source = ~/dotfiles/tmux;
    ".config/ghostty".source = ~/dotfiles/ghostty;
    # ".config/aerospace".source = ~/dotfiles/aerospace;
    # ".config/sketchybar".source = ~/dotfiles/sketchybar;
    # ".config/nushell".source = ~/dotfiles/nushell;
  };

  # Step 1: Add the nixpkgs unstable channel and update it
  home.activation.add-unstable-channel = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Check if the channel is already added
    #if ! nix-channel --list | grep -q "nixpkgs"; then
    #  echo "Adding nixpkgs unstable channel..."
    #  nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs
    #else
    #  echo "nixpkgs unstable channel already added."
    #fi
    # Update the channels
    #echo "Updating channels..."
    #nix-channel --update
  '';

  # Step 2a: install Python(Pyenv, Virtualenv)
  home.activation.installPyenv = lib.hm.dag.entryAfter [ "add-unstable-channel" ] ''
    export PATH=${pkgs.git}/bin:${pkgs.curl}/bin:${pkgs.zsh}/bin:$PATH
    
    # Install pyenv and pyenv-virtualenv
    if [ ! -d "$HOME/.pyenv" ]; then
      curl https://pyenv.run | bash
    fi

    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    
    if ! grep -q 'export PYENV_ROOT="$HOME/.pyenv"' ~/.bashrc; then
      echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    fi

    if ! grep -q 'export PATH="$PYENV_ROOT/bin:$PATH"' ~/.bashrc; then
      echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    fi

    if command -v pyenv 1>/dev/null 2>&1; then
      if ! grep -q 'eval "$(pyenv init --path)"' ~/.bashrc; then
        echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
      fi
      if ! grep -q 'eval "$(pyenv init -)"' ~/.bashrc; then
        echo 'eval "$(pyenv init -)"' >> ~/.bashrc
      fi
      if ! grep -q 'eval "$(pyenv virtualenv-init -)"' ~/.bashrc; then
        echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
      fi
    fi
  '';

  # Step 3: Install oh-my-zsh (if it's not already installed)
  home.activation.install-oh-my-zsh = lib.hm.dag.entryAfter [ "installPyenv" ] ''
    export PATH=${pkgs.git}/bin:${pkgs.curl}/bin:${pkgs.zsh}/bin:$PATH
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
      echo "Installing oh-my-zsh..."
      RUNZSH=no KEEP_ZSHRC=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      echo "Generating .zshrc from the oh-my-zsh template..."
      # BUG: below cmds work, but next zshrc config NOT work
      # cp $ZSH/templates/zshrc.zsh-template $HOME/.zshrc
      # sed -i 's|^ZSH=.*|ZSH="$HOME/.oh-my-zsh"|' $HOME/.zshrc
    else
      echo "oh-my-zsh already installed."
    fi
  '';

  # Step 4: Install oh-my-zsh plugins (Syntax Highlighting & Autosuggestions)
  home.activation.install-oh-my-zsh-plugins = lib.hm.dag.entryAfter [ "install-oh-my-zsh" ] ''
    # Define ZSH_CUSTOM as the custom directory for oh-my-zsh
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

    # Install zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
      echo "Installing zsh-syntax-highlighting..."
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    else
      echo "zsh-syntax-highlighting already installed."
    fi

    # Install zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
      echo "Installing zsh-autosuggestions..."
      git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    else
      echo "zsh-autosuggestions already installed."
    fi

    # Install zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-nvim-appname" ]; then
      echo "Installing zsh-nvim-appname..."
      git clone https://github.com/mehalter/zsh-nvim-appname $ZSH_CUSTOM/plugins/zsh-nvim-appname
    else
      echo "zsh-nvim-appname already installed."
    fi
  '';

  programs.starship = {
    enable = true;
  };
  # Step 6: Initialize Starship after Oh My Zsh setup
  home.activation.initialize-starship = lib.hm.dag.entryAfter [ "install-oh-my-zsh-plugins" ] ''
    echo "Initializing Starship configuration..."
    mkdir -p ~/.config
    ${pkgs.starship}/bin/starship preset nerd-font-symbols -o ~/.config/starship.toml
  '';

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/eagle/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "hx";
    PYENV_ROOT = "$HOME/.pyenv";
    PATH = "$HOME/.pyenv/bin:$PATH";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
