{
  description = "Matte's Hyprland config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
	  let
		  mkHost = hostname: nixpkgs.lib.nixosSystem {
			  system = "x86_64-linux";

			  modules = [
				  ./hosts/${hostname}/configuration.nix

					  home-manager.nixosModules.home-manager
					  {
						  home-manager.useGlobalPkgs = true;
						  home-manager.useUserPackages = true;
						  home-manager.backupFileExtension = "backup";

						  home-manager.users.matte =
							  import ./home/home.nix;
					  }
			  ];
		  };
	  in {
		  nixosConfigurations = {
			  desktop = mkHost "desktop";
			  au-thinkpad = mkHost "au-thinkpad";
			  ideapad = mkHost "ideapad";
		  };
	  };
}
