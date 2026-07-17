{ ... }:

{
  imports = [
    ../../modules/darwin/common.nix
  ];

  networking.hostName = "au-macbook";
  networking.computerName = "au-macbook";
  networking.localHostName = "au-macbook";
}
