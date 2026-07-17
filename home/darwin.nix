{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.mac-app-util.homeManagerModules.default
  ];

  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Set Colemak as the keyboard layout.
    home.activation.enableColemakInputSource = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if ! /usr/bin/defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -q '"KeyboardLayout Name" = Colemak;'; then
        $DRY_RUN_CMD /usr/bin/defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add \
          '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>12825</integer><key>KeyboardLayout Name</key><string>Colemak</string></dict>'
        $DRY_RUN_CMD /usr/bin/defaults write com.apple.HIToolbox AppleSelectedInputSources -array \
          '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>12825</integer><key>KeyboardLayout Name</key><string>Colemak</string></dict>'
        $DRY_RUN_CMD /usr/bin/defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string "com.apple.keylayout.Colemak"
      fi
    '';

    # Adds Japanese - Romaji (Apple's built-in Kotoeri.
    home.activation.enableJapaneseInputSource = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if ! /usr/bin/defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -q '"Input Mode" = "com.apple.inputmethod.Japanese";'; then
        $DRY_RUN_CMD /usr/bin/defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add \
          '<dict><key>Bundle ID</key><string>com.apple.CharacterPaletteIM</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>'
        $DRY_RUN_CMD /usr/bin/defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add \
          '<dict><key>Bundle ID</key><string>com.apple.50onPaletteIM</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>'
        $DRY_RUN_CMD /usr/bin/defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add \
          '<dict><key>Bundle ID</key><string>com.apple.inputmethod.Kotoeri.RomajiTyping</string><key>Input Mode</key><string>com.apple.inputmethod.Japanese</string><key>InputSourceKind</key><string>Input Mode</string></dict>'
        $DRY_RUN_CMD /usr/bin/defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add \
          '<dict><key>Bundle ID</key><string>com.apple.inputmethod.Kotoeri.RomajiTyping</string><key>InputSourceKind</key><string>Keyboard Input Method</string></dict>'
      fi
    '';
  };
}
