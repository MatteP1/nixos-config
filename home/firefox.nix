{ ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      ExtensionSettings = let
        moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
      in {
        # Bitwarden Password Manager
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = moz "bitwarden-password-manager";
          installation_mode = "force_installed";
        };
        # Privacy Badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = moz "privacy-badger17";
          installation_mode = "force_installed";
        };
        # SponsorBlock for YouTube
        "sponsorBlocker@ajay.app" = {
          install_url = moz "sponsorblock";
          installation_mode = "force_installed";
        };
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = moz "ublock-origin";
          installation_mode = "force_installed";
        };
        # Vimium
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = moz "vimium-ff";
          installation_mode = "force_installed";
        };
        # Yomitan
        "{6b733b82-9261-47ee-a595-2dda294a4d08}" = {
          install_url = moz "yomitan";
          installation_mode = "force_installed";
        };
        # Alpenglow (built-in theme, ships with Firefox; ensures it isn't user-disabled)
        "firefox-alpenglow@mozilla.org" = {
          installation_mode = "normal_installed";
        };
      };
    };

    # Fresh, home-manager-managed default profile so the theme (and other
    # profile settings) apply cleanly instead of being shadowed by whatever
    # was already in an existing profile's prefs.js.
    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        "extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
      };
    };
  };
}
