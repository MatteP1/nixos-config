# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/immich.nix
    ../../modules/nixos/home-assistant.nix
  ];

  networking.hostName = "ideapad";

  # Ensure laptop keeps running when lid is closed and connected to power
  services.logind.settings.Login = {
    HandleLidSwitchExternalPower = "ignore";
  };

}
