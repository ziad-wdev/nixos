{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  # Enable Flatpak for system-wide package management
  services.flatpak = {
    enable = true;
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
    packages = [
      "com.github.tchx84.Flatseal" # Flatseal
      "com.rtosta.zapzap" # WhatsApp
      "org.telegram.desktop" # Telegram
      "com.obsproject.Studio" # OBS Studio
      "org.localsend.localsend_app" # Local file sharing
      "org.polymc.PolyMC" # Minecraft launcher
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (old: { doCheck = false; });
    })
  ];

  environment.systemPackages = with pkgs; [
    protonup-ng # Proton Updater for steam
    lutris # Game launcher

    # System utilities
    nodejs
    gh
    git
    curl
    ouch # Archive extraction and compression utility
    resources # Resource management
    wl-clipboard # Wayland clipboard utility
    brightnessctl # Brightness control

    showtime # video player
    loupe # Image viewer

    imagemagick # Image processing
  ];

  # Configure zsh shell.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # Fix file system environment variables
  services.envfs.enable = true;

  # Enable fwupd for firmware updates
  services.fwupd.enable = true;

  # Enable GVFS for file system access. (for nautilus)
  services.gvfs.enable = true;

  # Library for rendering SVG icons
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
}
