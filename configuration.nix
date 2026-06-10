{ inputs, username, flakePath, stateVersion, ... }:

let
  loadModules = attrs:
    builtins.concatMap
      (key:
        map (val: ./. + "/${key}/${val}.nix") attrs.${key}
      )
      (builtins.attrNames attrs);

  modulePaths = loadModules {
    "modules/desktop" = [
      "desktop-env"
      "flatpaks"
      "packages"
      "sddm"
    ];
    "modules/system" = [
      "boot"
      "disko"
      "hardware"
      "networking"
      "nvidia"
      "sound"
    ];
  };
in
{
  imports = modulePaths;

  system.stateVersion = stateVersion;
  time.timeZone = "Africa/Cairo";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    use-xdg-base-directories = true;
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.autoUpgrade = {
    enable = true;
    dates = "02:00";
    allowReboot = false;
    flake = flakePath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
  };
}
