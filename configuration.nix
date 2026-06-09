{ inputs, username, stateVersion, ... }:

let
  loadModules = import ./lib/loadModules.nix;
  modulePaths = loadModules ./modules [ "system" "desktop" ];
in
{
  imports = [ inputs.disko.nixosModules.disko ] ++ modulePaths;

  system.stateVersion = stateVersion;
  time.timeZone = "Africa/Cairo";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    use-xdg-base-directories = true;
    auto-optimise-store = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
  };
}
