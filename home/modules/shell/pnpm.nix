{ config, pkgs, ... }:

{
  home.packages = [ pkgs.pnpm ];

  home.sessionVariables = {
    PNPM_HOME = "${config.xdg.dataHome}/pnpm";
  };

  home.sessionPath = [
    "${config.xdg.dataHome}/pnpm/bin"
  ];

  programs.zsh.initContent = ''
    export PNPM_HOME="${config.xdg.dataHome}/pnpm"
    export PATH="$PNPM_HOME/bin:$PATH"
  '';
}