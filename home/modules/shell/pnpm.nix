{ config, pkgs, ... }:

{
  programs.pnpm = {
    enable = true;
    package = pkgs.pnpm;
  };

  home.sessionVariables = {
    PNPM_HOME = "${config.xdg.dataHome}/pnpm";
  };

  home.sessionPath = [
    "${config.xdg.dataHome}/pnpm"
  ];
}
