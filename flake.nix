{
  description = "Matte's Hyprland config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "git+https://github.com/MatteP1/dots-hyprland.git?submodules=1";
      flake = false;
    };

    illogical-flake = {
      url = "github:soymou/illogical-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dotfiles.follows = "dotfiles";  # Override to use your dotfiles
    };
  };

  outputs = { nixpkgs, home-manager, illogical-flake, ... }: {

    nixosConfigurations.matte = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

	home-manager.nixosModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.backupFileExtension = "backup";

	  home-manager.users.matte = {
	    home.stateVersion = "25.05";
            imports = [
              # Import the module from illogical-flake
	      # illogical-flake.homeManagerModules.default
	    ];

	    # programs.illogical-impulse.enable = true;

	  };
	}
      ];
    };
  };
}
