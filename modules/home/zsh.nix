{ config, pkgs, ... }:

{
  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Fuzzy finder with Zsh integration (Ctrl+R history, Ctrl+T file find)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    fileWidget.command = "${pkgs.fd}/bin/fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    changeDirWidget.command = "${pkgs.fd}/bin/fd --type d --strip-cwd-prefix --hidden --follow --exclude .git";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zhistory";
      ignoreAllDups = true;
      share = true;
    };

    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      ll = "ls -al";
      ln = "ln -v";
      mkdir = "mkdir -p";
      e = "$EDITOR";
      v = "$VISUAL";
      b = "bundle";
      migrate = "bin/rails db:migrate db:rollback && bin/rails db:migrate db:test:prepare";
      s = "rspec";
      showpath = "echo $PATH | tr -s ':' '\n'";
    };

    initContent = ''
      # Vi mode
      bindkey -v
      bindkey "^F" vi-cmd-mode
      bindkey "^A" beginning-of-line
      bindkey "^E" end-of-line
      bindkey "^K" kill-line
      bindkey "^P" history-search-backward
      bindkey "^Y" accept-and-hold
      bindkey "^N" insert-last-word

      # Edit current command line in editor (Ctrl+X Ctrl+E, Ctrl+X e, or 'v' in vicmd)
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line
      bindkey "^Xe" edit-command-line
      bindkey -M viins "^X^E" edit-command-line
      bindkey -M viins "^Xe" edit-command-line
      bindkey -M vicmd "^X^E" edit-command-line
      bindkey -M vicmd "^Xe" edit-command-line
      bindkey -M vicmd "v" edit-command-line

      # Enable colors
      autoload -U colors && colors

      # Load custom functions & configs from ~/.zsh
      if [ -d "$HOME/.zsh/functions" ]; then
        for function in "$HOME/.zsh/functions"/*; do
          [ -f "$function" ] && source "$function"
        done
      fi

      _load_settings() {
        local _dir="$1"
        if [ -d "$_dir" ]; then
          if [ -d "$_dir/pre" ]; then
            for config in "$_dir"/pre/*(N-.); do
              . "$config" ""
            done
          fi
          for config in "$_dir"/*(N-.); do
            case "$config" in
              "$_dir"/(pre|post)|"$_dir"/(pre|post)/*|*.zwc) : ;;
              *) . "$config" "" ;;
            esac
          done
          if [ -d "$_dir/post" ]; then
            for config in "$_dir"/post/*(N-.); do
              . "$config" ""
            done
          fi
        fi
      }
      _load_settings "$HOME/.zsh/configs"

      # Include local machine overrides
      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
      [[ -f ~/.aliases.local ]] && source ~/.aliases.local

      # Ensure fzf widgets (Ctrl+R history, Ctrl+T files, Alt+C cd) are bound in vi keymaps
      if (( $+widgets[fzf-history-widget] )); then
        bindkey -M viins '^R' fzf-history-widget
        bindkey -M vicmd '^R' fzf-history-widget
        bindkey -M emacs '^R' fzf-history-widget
      fi
      if (( $+widgets[fzf-file-widget] )); then
        bindkey -M viins '^T' fzf-file-widget
        bindkey -M vicmd '^T' fzf-file-widget
        bindkey -M emacs '^T' fzf-file-widget
      fi
      if (( $+widgets[fzf-cd-widget] )); then
        bindkey -M viins '\ec' fzf-cd-widget
        bindkey -M vicmd '\ec' fzf-cd-widget
        bindkey -M emacs '\ec' fzf-cd-widget
      fi
    '';
  };

  # Link support directory directly to live dotfiles repo
  home.file.".zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles/zsh";
}
