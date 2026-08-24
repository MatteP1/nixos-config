{ pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;

    languagePacks = [ "en-US" ];

    policies = {
      # Updates & Background Services
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;

      # Feature Disabling
      DisableBuiltinPDFViewer = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableForgetButton = true;
      DisableMasterPasswordCreation = true;
      DisableProfileImport = true;
      DisableProfileRefresh = true;
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;

      # Access Restrictions
      BlockAboutConfig = false;
      BlockAboutProfiles = true;
      BlockAboutSupport = true;

      # UI and Behavior
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      HardwareAcceleration = false;
      OfferToSaveLogins = false;
      # DefaultDownloadDirectory = "${home}/Downloads";

      # Extensions
      ExtensionSettings =
        let
          moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        in
        {
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
          # Theme
          "{b6aa7dff-8b85-4733-a064-8e529c5ed419}" = {
            install_url = moz "catppuccin-mocha-miku-nb";
            installation_mode = "force_installed";
          };
        };
    };

    profiles.default = {
      isDefault = true;
      settings = {
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
      };
      search = {
        force = true;
        privateDefault = "ddg";

        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          "NixOS Wiki" = {
            urls = [
              {
                template = "https://wiki.nixos.org/w/index.php";
                params = [
                  {
                    name = "search";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nw" ];
          };
        };
      };
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Bookmarks Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "AU";
                bookmarks = [
                  {
                    name = "Webmail";
                    url = "http://webmail.au.dk/";
                  }
                  {
                    name = "Staff Portal";
                    url = "https://medarbejdere.au.dk/en/";
                  }
                  {
                    name = "Mitstudie";
                    url = "http://mitstudie.au.dk/";
                  }
                  {
                    name = "Brightspace";
                    url = "https://brightspace.au.dk/d2l/home";
                  }
                  {
                    name = "Post AU";
                    url = "http://post.au.dk/";
                  }
                  {
                    name = "Mit AU";
                    url = "http://mit.au.dk/";
                  }
                  {
                    name = "PhD studies at Graduate School of Natural Sciences, Aarhus University";
                    url = "https://phd.nat.au.dk/";
                  }
                  {
                    name = "MyPhD login";
                    url = "https://phd.au.dk/for-current-phd-students/myphd-login";
                  }
                  {
                    name = "PhD Course Management";
                    url = "https://au.phd-courses.dk/";
                  }
                ];
              }
              {
                name = "Iris";
                bookmarks = [
                  {
                    name = "Iris Repo";
                    url = "https://gitlab.mpi-sws.org/iris/iris";
                  }
                  {
                    name = "Iris Algebra";
                    url = "https://gitlab.mpi-sws.org/iris/iris/-/tree/master/iris/algebra";
                  }
                  {
                    name = "Iris Docs";
                    url = "https://gitlab.mpi-sws.org/iris/iris/-/tree/master/docs";
                  }
                  {
                    name = "iris-tutorial";
                    url = "https://github.com/logsem/iris-tutorial";
                  }
                ];
              }
              {
                name = "日本語の学業";
                bookmarks = [
                  {
                    name = "Kanji Garden";
                    url = "https://kanji.garden/";
                  }
                  {
                    name = "marshallyin";
                    url = "https://marshallyin.com/";
                  }
                  {
                    name = "日本語たどく";
                    url = "https://tadoku.org/japanese/book-search";
                  }
                  {
                    name = "たどくのPDF";
                    url = "https://www.reddit.com/r/LearnJapanese/comments/o7x7ha/2021_updated_free_tadoku_graded_reader_pdfs_1796/";
                  }
                  {
                    name = "JPDB";
                    url = "https://jpdb.io/";
                  }
                  {
                    name = "Conjugator";
                    url = "https://steven-kraft.com/projects/japanese/";
                  }
                  {
                    name = "絵でわかる日本語";
                    url = "https://www.edewakaru.com/";
                  }
                  {
                    name = "hanabira";
                    url = "https://hanabira.org/";
                  }
                ];
              }
              "separator"
              {
                name = "Gmail";
                url = "https://mail.google.com/";
              }
              {
                name = "Proton Mail";
                url = "https://mail.proton.me/";
              }
              {
                name = "MEGA";
                url = "https://mega.nz/";
              }
              {
                name = "GitHub";
                url = "https://github.com/MatteP1";
              }
              {
                name = "YouTube";
                url = "https://www.youtube.com/";
              }
              {
                name = "Reddit";
                url = "https://www.reddit.com/";
              }
              {
                name = "Twitch";
                url = "https://www.twitch.tv/directory";
              }
              {
                name = "Immich";
                url = "http://100.94.80.72:2283/";
              }
            ];
          }
        ];
      };
    };
  };
}
