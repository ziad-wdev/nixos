{ username, config, lib, ... }:

let
  # Get all files in ./modules
  dir = ./modules;
  files = builtins.readDir dir;

  # Filter for .nix files and exclude this current file if necessary
  nixFiles = lib.filterAttrs (name: type:
    type == "regular" && lib.hasSuffix ".nix" name
  ) files;

  # Create a list of full paths
  importList = lib.mapAttrsToList (name: _: dir + "/${name}") nixFiles;
in
{
  imports = importList;

  home = {
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
    username = "${username}";
  };

  programs.home-manager.enable = true;

  # OBS Studio theme & output configuration (only if OBS is installed as a Flatpak)
  home.file = lib.mkIf (builtins.pathExists "${config.home.homeDirectory}/.var/app/com.obsproject.Studio") {
    ".var/app/com.obsproject.Studio/config/obs-studio" = {
      "themes/custom.obt".source =
        config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/matugen/output/obs.obt";
      "global.ini".text = ''
        [General]
        Theme=custom

        [AdvOut]
        RecRecordingPath=${config.home.homeDirectory}/Videos/obs
      '';
    };
  };

  # NPM global packages configuration
  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  # Set NPM_CONFIG_PREFIX to ensure npm uses the correct directory for global packages
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };
}
