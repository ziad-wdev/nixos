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

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, home-manager, ... }@inputs:
  let
    username = "ziad";
    sharedArgs = {
      username = username;
      inherit inputs;
    };
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Pass sharedArg to NixOS configuration
      specialArgs = sharedArgs;

      modules = [
        # Main configuration modules
        disko.nixosModules.disko
        ./hosts/default/disko.nix
        ./hosts/default/hardware-configuration.nix
        ./hosts/default/configuration.nix
        ./hosts/default/packages.nix
        ./hosts/default/sddm.nix

        # Home Manager and sddm theme configuration
        home-manager.nixosModules.home-manager
        {
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
