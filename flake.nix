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

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    username = "ziad";
    stateVersion = "26.05";
    flakePath = "/home/${username}/.nix-config";
    sharedArgs = {
      inherit username stateVersion flakePath inputs;
    };
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = sharedArgs;

      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = sharedArgs;

            backupFileExtension = "hm-backup";
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = {
              imports = [
                ./home/home.nix
              ];
            };
          };
        }
      ];
    };
  };
}
