{ pkgs, ... }:
{

  programs.vscode.enable = true;
  home.packages = with pkgs; [
    rocqPackages.vsrocq-language-server
  ];
}
