{
  config,
  pkgs,
  lib,
  user,
  ...
}:

{
  home.username = user;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  imports = [
    ./kitty.nix
    ./starship.nix
    ./neovim.nix
    ./ssh.nix
    ./git.nix
    # ./opam.nix
    # ./hyprland.nix
    ./niri.nix
    ./vscode.nix
    ./yazi.nix
    ./fcitx5.nix
    # ./hyprland.nix
    ./niri.nix
    ./darwin.nix
    ./rocq.nix
    ./firefox.nix
  ];

  home.packages = lib.optionals pkgs.stdenv.isLinux (
    with pkgs;
    [
      prismlauncher
      spotify
      xeyes
      mattermost-desktop
      slack
      snitch
      osu-lazer-bin
    ]
  );

  programs.fish.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

}
