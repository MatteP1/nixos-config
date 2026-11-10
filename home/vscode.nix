{ pkgs, ... }:
{

  programs.vscode = {
    enable = true;
    # Comes from the Homebrew cask on Darwin instead (modules/darwin/common.nix).
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.vscode;
  };
  home.packages = with pkgs; [
    rocqPackages.vsrocq-language-server
  ];
}
