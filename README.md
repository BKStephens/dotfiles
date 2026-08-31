# Dotfiles (macOS & Arch Linux)

Declarative, cross-platform dotfiles powered by **[Nix Flakes](https://nixos.wiki/wiki/Flakes)**, **[nix-darwin](https://github.com/LnL7/nix-darwin)** (macOS), and **[Home Manager](https://github.com/nix-community/home-manager)** (macOS & Arch Linux).

---

## Architecture Overview

```
dotfiles/
├── flake.nix                # Root Flake defining targets: 'macbook' & 'archlinux'
├── hosts/
│   ├── macbook/             # macOS system configuration (nix-darwin + homebrew)
│   │   └── default.nix
│   └── arch/                # Arch Linux host settings (standalone Home Manager)
│       └── default.nix
├── modules/
│   └── home/                # Shared dotfiles & user packages
│       ├── default.nix      # Common CLI tools (fzf, ripgrep, eza, zoxide, etc.)
│       ├── git.nix          # Git configuration & aliases
│       ├── nvim.nix         # Neovim configuration (~/.config/nvim)
│       ├── tmux.nix         # Tmux configuration (cross-platform clipboard, vi keys)
│       └── zsh.nix          # Zsh configuration, prompt, and functions
├── bin/                     # Custom executable scripts
└── config/                  # Native XDG configs (Neovim Lua config, etc.)
```

---

## 1. Installation on a New Machine

### Prerequisites (Both Platforms)

1. **Install the Determinate Nix Installer** (recommended for modern Flakes support):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```
2. **Clone this repository**:
   ```bash
   git clone https://github.com/BKStephens/dotfiles.git ~/repos/dotfiles
   cd ~/repos/dotfiles
   ```

---

### A. Setup on macOS

1. **Run the initial `nix-darwin` switch**:
   ```bash
   nix run nix-darwin -- switch --flake ~/repos/dotfiles#macbook
   ```
2. **For subsequent updates on macOS**, run:
   ```bash
   darwin-rebuild switch --flake ~/repos/dotfiles#macbook
   ```

> [!NOTE]
> **Homebrew on macOS**: Homebrew formulas and GUI Casks can be declaratively managed in [`hosts/macbook/default.nix`](file:///Users/ben.stephens/repos/dotfiles/hosts/macbook/default.nix) via `homebrew.casks` and `homebrew.brews`, or installed manually via `brew install`.

---

### B. Setup on Arch Linux

1. **Enable Flakes** (if not using Determinate installer):
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```
2. **Run Home Manager**:
   ```bash
   nix run github:nix-community/home-manager -- switch --flake ~/repos/dotfiles#archlinux
   ```
3. **For subsequent updates on Arch Linux**, run:
   ```bash
   home-manager switch --flake ~/repos/dotfiles#archlinux
   ```

> [!NOTE]
> **Pacman on Arch Linux**: `pacman` and `yay`/`paru` continue to manage your Linux kernel, systemd services, GPU drivers, and desktop environment packages. Nix isolates user CLI tools and dotfiles inside `/nix/store`.

---

## 2. How to Make Changes

### Adding or Modifying Packages
* **Shared CLI packages** (installed on both macOS & Arch): Edit [`modules/home/default.nix`](file:///Users/ben.stephens/repos/dotfiles/modules/home/default.nix) in `home.packages`.
* **macOS GUI Apps (Casks) & Homebrew**: Edit [`hosts/macbook/default.nix`](file:///Users/ben.stephens/repos/dotfiles/hosts/macbook/default.nix) in `homebrew.casks`.
* **Arch Linux System Packages**: Install via `sudo pacman -S <pkg>` or `yay -S <pkg>`.

### Modifying Dotfiles
* **Git**: Edit [`modules/home/git.nix`](file:///Users/ben.stephens/repos/dotfiles/modules/home/git.nix).
* **Zsh**: Edit [`modules/home/zsh.nix`](file:///Users/ben.stephens/repos/dotfiles/modules/home/zsh.nix) or add functions in [`zsh/`](file:///Users/ben.stephens/repos/dotfiles/zsh).
* **Tmux**: Edit [`modules/home/tmux.nix`](file:///Users/ben.stephens/repos/dotfiles/modules/home/tmux.nix).
* **Neovim**: Edit files directly in [`config/nvim/`](file:///Users/ben.stephens/repos/dotfiles/config/nvim) (changes are picked up immediately).

### Applying Changes

After modifying files in `~/repos/dotfiles`:

* **On macOS**:
  ```bash
  darwin-rebuild switch --flake ~/repos/dotfiles#macbook
  ```
* **On Arch Linux**:
  ```bash
  home-manager switch --flake ~/repos/dotfiles#archlinux
  ```

### Updating Nix Dependencies
To update all package inputs (`nixpkgs`, `nix-darwin`, `home-manager`):
```bash
cd ~/repos/dotfiles
nix flake update
git commit -am "chore: update flake.lock"
```

---

## 3. Local Machine Overrides

For private tokens, machine-specific paths, or secrets not tracked in git:
* **Zsh**: Put overrides in `~/.zshrc.local` or `~/.aliases.local` (automatically sourced if present).
* **Git**: Put machine-specific config in `~/.gitconfig.local` (automatically included).
* **Tmux**: Put local tmux settings in `~/.tmux.conf.local`.
