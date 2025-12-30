{ pkgs, ... }:
{

  programs.vscode.enable = true;
  home.packages = with pkgs; [
    coqPackages.vscoq-language-server
  ];
}
