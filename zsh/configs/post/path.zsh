# Ensure no legacy alias shadows the special zsh 'path' array
unalias path 2>/dev/null

# Ensure dotfiles bin directory and Nix profiles are loaded first, with Homebrew and developer tools available
path=(
  "$HOME/.bin"
  "$HOME/bin"
  "$HOME/.local/bin"
  "/etc/profiles/per-user/$USER/bin"
  "$HOME/.nix-profile/bin"
  "$HOME/.docker/bin"
  "$HOME/.yarn/bin"
  "$HOME/.dotnet/tools"
  "/usr/local/share/dotnet"
  "/opt/homebrew/opt/postgresql@14/bin"
  "/opt/homebrew/opt/openjdk@11/bin"
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  $path
)
typeset -U path
export PATH

# Try loading ASDF from the regular home dir location
if [ -f "$HOME/.asdf/asdf.sh" ]; then
  . "$HOME/.asdf/asdf.sh"
elif which brew >/dev/null &&
  BREW_DIR="$(dirname `which brew`)/.." &&
  [ -f "$BREW_DIR/opt/asdf/asdf.sh" ]; then
  . "$BREW_DIR/opt/asdf/asdf.sh"
fi

# Load NVM (Node Version Manager) if installed
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh" --no-use
elif which brew >/dev/null && [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  . "/opt/homebrew/opt/nvm/nvm.sh" --no-use
fi
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# mkdir .git/safe in the root of repositories you trust
path=(".git/safe/../../bin" $path)
typeset -U path
