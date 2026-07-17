# Declarative Dock contents via dockutil. Entries are set per-host (see
# hosts/au-macbook/configuration.nix); this module just provides the plumbing.
# Original source: https://gist.github.com/antifuchs/10138c4d838a63c0a05e725ccd7bccdd
{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.local.dock;
  inherit (pkgs) dockutil;
in
{
  options.local.dock = {
    enable = mkEnableOption "declarative Dock management";

    entries = mkOption {
      description = "Entries on the Dock";
      default = [ ];
      type =
        with types;
        listOf (submodule {
          options = {
            path = mkOption { type = str; };
            section = mkOption {
              type = str;
              default = "apps";
            };
            options = mkOption {
              type = str;
              default = "";
            };
          };
        });
    };

    username = mkOption {
      description = "Username to apply the Dock settings to";
      type = types.str;
    };
  };

  config = mkIf cfg.enable (
    let
      normalize = path: if hasSuffix ".app" path then path + "/" else path;
      entryURI =
        path:
        "file://"
        + (builtins.replaceStrings
          [ " " "!" "\"" "#" "$" "%" "&" "'" "(" ")" ]
          [ "%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29" ]
          (normalize path)
        );
      wantURIs = concatMapStrings (entry: "${entryURI entry.path}\n") cfg.entries;
      createEntries = concatMapStrings (
        entry: "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}\n"
      ) cfg.entries;
    in
    {
      system.activationScripts.postActivation.text = ''
        echo >&2 "Setting up the Dock for ${cfg.username}..."
        sudo -u ${cfg.username} ${pkgs.zsh}/bin/zsh -s /bin/sh <<'USERBLOCK'
        haveURIs="$(${dockutil}/bin/dockutil --list | ${pkgs.coreutils}/bin/cut -f2)"
        if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2 ; then
          echo >&2 "Resetting Dock."
          ${dockutil}/bin/dockutil --no-restart --remove all
          ${createEntries}
          killall Dock
        else
          echo >&2 "Dock setup complete."
        fi
        USERBLOCK
      '';
    }
  );
}
