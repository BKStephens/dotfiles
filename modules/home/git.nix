{ pkgs, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Ben Stephens";
        email = if isDarwin
          then "ben.stephens@docusign.com"
          else "BKStephens@outlook.com";
      };

      alias = {
        aa = "add --all";
        ap = "add --patch";
        branches = "for-each-ref --sort=-committerdate --format=\"%(color:blue)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)\" refs/remotes";
        ci = "commit -v";
        co = "checkout";
        pf = "push --force-with-lease";
        st = "status";
      };

      init.defaultBranch = "main";
      push.default = "current";
      color.ui = "auto";
      core = {
        excludesfile = "~/.gitignore";
        autocrlf = "input";
      };
      fetch.prune = true;
      rebase.autosquash = true;
      commit.template = "~/.gitmessage";
      checkout.workers = -1;
      credential.helper = if isDarwin then "osxkeychain" else "libsecret";
    };

    includes = [
      { path = "~/.gitconfig.local"; }
    ];
  };

  # Symlink git support files
  home.file.".gitmessage".source = ../../gitmessage;
  home.file.".gitignore".source = ../../gitignore;
}
