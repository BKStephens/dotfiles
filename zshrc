# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

PATH="/opt/homebrew/bin:$PATH"
# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

export PATH="$HOME/.asdf/shims:$PATH"

# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  current_branch=$(git current-branch 2> /dev/null)
  if [[ -n $current_branch ]]; then
    echo " %{$fg_bold[green]%}$current_branch%{$reset_color%}"
  fi
}
setopt promptsubst
export PS1='${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%c%{$reset_color%}$(git_prompt_info) %# '

# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# completion
autoload -U compinit
compinit

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*~*.zwc(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/(pre|post)/*|*.zwc)
          :
          ;;
        *)
          . $config
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*~*.zwc(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
setopt hist_ignore_all_dups inc_append_history
HISTFILE=~/.zhistory
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^K" kill-line
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases


# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

export NOTES_DIR=~/Dropbox/Notes
note() {
  $EDITOR $NOTES_DIR/$(date +%Y%m%d)_"$*".txt
}
note_ls() {
  ls -c $NOTES_DIR | grep "$*"
}
note_cd() {
  cd $NOTES_DIR
}

# fzf + ag configuration
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
--color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168
'

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/bstephens-mac/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/bstephens-mac/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/bstephens-mac/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/bstephens-mac/google-cloud-sdk/completion.zsh.inc'; fi

alias vim="nvim"

export NODE_OPTIONS="${NODE_OPTIONS:=--max-old-space-size=8192}"

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

export DOTNET_ROOT=/usr/local/share/dotnet

export PATH="$PATH:$HOME/repos/msf-dev/minikube"

export DOCKER_TLS_VERIFY="1"
# export DOCKER_HOST="tcp://127.0.0.1:55949"
export DOCKER_CERT_PATH="/Users/ben.stephens/.minikube/certs"
export MINIKUBE_ACTIVE_DOCKERD="docker-desktop"

eval $(minikube -p docker-desktop docker-env)
