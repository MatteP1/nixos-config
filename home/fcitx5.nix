{ pkgs, ... }: {
	i18n.inputMethod = {
		type = "fcitx5";
		enable = true;
		fcitx5 = {
			waylandFrontend = true;
			addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        qt6Packages.fcitx5-configtool
        fcitx5-material-color
        catppuccin-fcitx5
			];
			settings = {
				inputMethod = {
					GroupOrder."0" = "Default";
					"Groups/0" = {
						Name = "Default";
						"Default Layout" = "us-colemak";
						DefaultIM = "mozc";
					};
					"Groups/0/Items/0".Name = "keyboard-us-colemak";
					"Groups/0/Items/1".Name = "mozc";
				};

				globalOptions = {
					Behavior = {
						ActiveByDefault = false;
					};
					Hotkey = {
						EnumerateWithTriggerKeys = true;
						EnumerateSkipFirst = false;
					};
					"Hotkey/TriggerKeys" = {
						"0" = "Super+space";
					};
					"Hotkey/AltTriggerKeys" = {
						"0" = "Shift_L";
					};
					"Hotkey/PrevCandidate" = {
						"0" = "Shift+Tab";
					};
					"Hotkey/NextCandidate" = {
						"0" = "Tab";
					};
					"Hotkey/PrevPage" = {
						"0" = "Up";
					};
					"Hotkey/NextPage" = {
						"0" = "Down";
					};
					"Hotkey/EnumerateGroupForwardKeys" = {
						"0" = "Super+space";
					};
					"Hotkey/EnumerateGroupBackwardKeys" = {
						"0" = "Shift+Super+space";
					};
					Behavior = {
						PreeditEnabledByDefault = true;
						ShowInputMethodInformation = true;
						ShowInputMethodInformationWhenFocusIn = false;
						CompactInputMethodInformation = true;
						ShowFirstInputMethodInformation = true;
					};
				};
				addons = {
					classicui.globalSection.Theme = "catppuccin-mocha-pink";
				};
			};
		};
	};
	       }
