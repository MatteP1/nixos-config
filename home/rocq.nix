{ pkgs, lib, ... }:
let
  rocqLibs = with pkgs.rocqPackages; [
    stdlib
    stdpp
    iris
  ];

  rocqVersion = pkgs.rocq-core.rocq-version;
in
{
  home.packages =
    with pkgs;
    [
      rocq-core
      coqPackages.coq-lsp
    ]
    ++ rocqLibs;

  home.sessionVariables =
    let
      rocqPath = lib.concatMapStringsSep ":" (p: "${p}/lib/coq/${rocqVersion}/user-contrib") rocqLibs;
    in
    {
      ROCQPATH = rocqPath;
      COQPATH = rocqPath;
    };
}
