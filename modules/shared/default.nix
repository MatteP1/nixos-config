{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Copenhagen";

  services.tailscale.enable = true;

  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    rubik
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    fastfetch
    just
    gnumake
    gcc
    clang
    gmp
    pkg-config
    ripgrep
    lazygit
    fzf
    fd
  ];
}
