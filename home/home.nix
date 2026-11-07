{
  pkgs,
  lib,
  user,
  ...
}:

{
  home.username = user;
  home.homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${user}" else "/home/${user}";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  imports = [
    ./kitty.nix
    ./starship.nix
    ./neovim.nix
    ./ssh.nix
    ./git.nix
    ./niri
    # ./hypr
    ./yazi.nix
    ./fcitx5.nix
    ./darwin.nix
    ./vscode.nix
    ./rocq.nix
    ./firefox.nix
  ];

  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
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
