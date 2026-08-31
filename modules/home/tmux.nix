{ pkgs, ... }:

let
  copyCommand = if pkgs.stdenv.hostPlatform.isDarwin
    then "pbcopy"
    else "wl-copy || xclip -sel clip -i";
in
{
  programs.tmux = {
    enable = true;
    prefix = "C-s";
    keyMode = "vi";
    baseIndex = 1;
    mouse = true;
    historyLimit = 100000;
    terminal = "screen-256color";
    escapeTime = 0;

    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Pane navigation (vim style)
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      bind-key -r C-h select-window -t :-
      bind-key -r C-l select-window -t :+

      # Resize panes
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r H resize-pane -L 5
      bind -r L resize-pane -R 5

      # Renumber windows sequentially
      set -g renumber-windows on

      # Status bar styling
      set -g status-style bg='#666666',fg='#aaaaaa'
      set -g status-left ""
      set -g status-right '#[fg=green]|#[fg=white]%m/%d %H:%M'

      # Split windows keeping current path
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Copy mode (vi)
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "${copyCommand}"
      bind-key -T copy-mode-vi Escape send -X cancel
      bind-key -T copy-mode-vi V send -X rectangle-toggle

      # Local configuration override
      if-shell "[ -f ~/.tmux.conf.local ]" 'source ~/.tmux.conf.local'
    '';
  };
}
