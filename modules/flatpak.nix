{ config, pkgs, ... }:

{
  services.flatpak.enable = true;

  system.userActivationScripts.flatpakManagement = {
    text = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      ${pkgs.flatpak}/bin/flatpak install -y --or-update flathub com.bitwarden.desktop
    '';
  };
}
