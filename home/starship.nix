{ pkgs, lib, ... }: {

	programs.starship = {
		enable = true;
		enableFishIntegration = true;
		settings = lib.mkMerge [
			(builtins.fromTOML (
					    builtins.readFile "${pkgs.starship}/share/starship/presets/pastel-powerline.toml"
					   ))
		];	
	};
}
