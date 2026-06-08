{ inputs, config, ... }:

let
  flakePath = toString inputs.self.outPath;
in
{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    shellAliases = {
      nix-rebuild = "sudo nixos-rebuild switch --flake ${flakePath}#default";
      nix-update = "sudo nix-channel --update && sudo nixos-rebuild switch --flake ${flakePath}#default";
      nix-gc = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +10 && nix-collect-garbage";
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };

    initContent = ''
      fastfetch
    '';
  };
}
