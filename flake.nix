{
  description = "Matte's Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      user = "matte";
      mkNixosHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./hosts/${hostname}/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users.${user} = import ./home/home.nix;
              home-manager.extraSpecialArgs = { inherit user inputs; };
            }
          ];

          specialArgs = { inherit inputs user; };
        };

      mkDarwinHost =
        hostname:
        let
          user =
            let
              sudoUser = builtins.getEnv "SUDO_USER";
              envUser = builtins.getEnv "USER";
              resolved = if sudoUser != "" then sudoUser else envUser;
            in
            if resolved == "" then
              throw "Could not determine username - run with --impure and ensure $USER (or $SUDO_USER under sudo) is set"
            else
              resolved;
        in
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";

          modules = [
            ./hosts/${hostname}/configuration.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              home-manager.users.${user} = import ./home/home.nix;
              home-manager.extraSpecialArgs = { inherit user inputs; };
            }
          ];

          specialArgs = { inherit inputs user; };
        };
    in
    {
      nixosConfigurations = {
        desktop = mkNixosHost "desktop";
        au-thinkpad = mkNixosHost "au-thinkpad";
        ideapad = mkNixosHost "ideapad";
      };

      darwinConfigurations = {
        au-macbook = mkDarwinHost "au-macbook";
      };
    };
}
