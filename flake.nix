{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qylock.url = "github:Greeenman999/qylock-nix";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    username = "ziad";
    sharedArgs = {
      username = username;
      inherit inputs;
    };
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = system;

      # Pass sharedArg to NixOS configuration
      specialArgs = sharedArgs;

      modules = [
        # Main configuration modules
        disko.nixosModules.disko
        ./hosts/default/disko.nix
        ./hosts/default/hardware-configuration.nix
        ./hosts/default/configuration.nix
        ./hosts/default/packages.nix

        inputs.qylock.nixosModules.default # sddm qylock theme

        # Home Manager and sddm theme configuration
        home-manager.nixosModules.home-manager
        {
          programs.qylock = {
              enable = true;
              theme = "pixel-hollowknight";
              sddmTheme = "pixel-hollowknight";
          };

          home-manager = {
            # Pass sharedArg to Home Manager configuration
            extraSpecialArgs = sharedArgs;

            backupFileExtension = "hm-backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = {
              imports = [
                ./home/default/home.nix
              ];
            };
          };
        }
      ];
    };
  };
}
