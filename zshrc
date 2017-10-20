# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

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

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
#_load_settings() {
#  _dir="$1"
#  if [ -d "$_dir" ]; then
#    if [ -d "$_dir/pre" ]; then
#      for config in "$_dir"/pre/**/*(N-.); do
#        . $config
#      done
#    fi
#
#    for config in "$_dir"/**/*(N-.); do
#      case "$config" in
#        "$_dir"/pre/*)
#          :
#          ;;
#        "$_dir"/post/*)
#          :
#          ;;
#        *)
#          if [ -f $config ]; then
#            . $config
#          fi
#          ;;
#      esac
#    done
#
#    if [ -d "$_dir/post" ]; then
#      for config in "$_dir"/post/**/*(N-.); do
#        . $config
#      done
#    fi
#  fi
#}
#_load_settings "$HOME/.zsh/configs"

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - --no-rehash)"

export PATH="$PATH:/usr/local/go/bin"
export GOPATH="$HOME/go_code"

# Make Ruby gems use GCC 4.2. We need this for the monorail.
# export CPPFLAGS=-I/opt/X11/include
# export CC="/usr/local/bin/gcc-4.2"
# export CXX="/usr/local/bin/g++-4.2"
# export CPP="/usr/local/bin/cpp-4.2"
# export CC=$(which CC)
# export CXX=$(which g++)
# export CPP=$(which CPP)

# MySQL
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/
export PATH=${PATH}:/usr/local/mysql/bin

# Postgres
export PATH=${PATH}:/usr/local/Cellar/postgresql/9.4.5_2/bin

# TheCity
export PATH=${PATH}:/Users/benstephens/repos/thecity/script

# Engagement
export PATH=${PATH}:/Users/benstephens/repos/engagement-compose/bin

# Make option-left and option-right jump word
bindkey -e
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

# http://superuser.com/a/838630 - increase Yosemite maxfile limit
# ulimit -n 65536
# ulimit -u 2048

# export NVM_DIR="/Users/benstephens/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# eval $(docker-machine env docker-machine)
# export DOCKER_MACHINE_IP=$(docker-machine ip docker-machine)
source /usr/share/nvm/init-nvm.sh

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

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# fzf + ag configuration
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
--color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168
'
