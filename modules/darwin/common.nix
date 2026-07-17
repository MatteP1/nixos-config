{
  config,
  pkgs,
  inputs,
  user,
  ...
}:

{
  imports = [
    ../shared
    ./dock.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.mac-app-util.darwinModules.default
  ];

  nix.enable = false;

  system.primaryUser = user;
  system.stateVersion = 6;

  # Not added to `users.knownUsers`, so nix-darwin never tries to
  # create/delete this pre-existing account - this just tells home-manager
  # (and other modules) where its home directory lives.
  users.users.${user}.home = "/Users/${user}";

  environment.systemPackages = [ pkgs.nh ];
  environment.variables.NH_DARWIN_FLAKE = "${config.users.users.${user}.home}/nixos-config";

  # Default Dock entries for every darwin host - a specific host can append
  # more via its own local.dock.entries.
  local.dock = {
    enable = true;
    username = user;
    entries = [
      { path = "${pkgs.kitty}/Applications/kitty.app/"; }
      { path = "/Applications/Slack.app/"; }
      { path = "/Applications/Mattermost.app/"; }
      { path = "/Applications/Spotify.app/"; }
      { path = "/Applications/Prism Launcher.app/"; }
      { path = "/Applications/osu!.app/"; }
    ];
  };

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
  };

  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
    };
    finder = {
      AppleShowAllFiles = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv";
    };
    dock = {
      autohide = true;
      show-recents = false;
    };
  };

  # remap capslock to backspace.
  launchd.daemons.remap-capslock-to-backspace = {
    serviceConfig = {
      Label = "local.remap-capslock-to-backspace";
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        ''{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000002A}]}''
      ];
      RunAtLoad = true;
    };
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    inherit user;
  };

  homebrew = {
    enable = true;
    casks = [
      "spotify"
      "slack"
      "mattermost"
      "prismlauncher"
      "osu"
      "mos"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };
}
