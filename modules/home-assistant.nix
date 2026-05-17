{ config, pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      "isal"
      "flux_led"
      "wiz"
      "roomba"
      "sonos"
      "cast" # Chromecast
      "webostv" # LG TV
      "mobile_app" # iOS companion app
    ];
    config = {
      default_config = { };

      "automation ui" = "!include automations.yaml";
      # "scene ui" = "!include scenes.yaml";
      # "script ui" = "!include scripts.yaml";
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
