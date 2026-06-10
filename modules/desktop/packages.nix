{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (old: { doCheck = false; });
    })
  ];

  environment.systemPackages = with pkgs; [
    lutris # Game launcher

    gnome-disk-utility # Disk utility
    resources # Resource management
    baobab # Disk usage analyzer
    showtime # video player
    loupe # Image viewer

    # System utilities
    
    python3
    python3Packages.pip
    nodejs_24
    gh
    git
    curl
    _7zz-rar
    ouch # Archive extraction and compression utility
    imagemagick # Image processing
    wl-clipboard # Wayland clipboard utility
    brightnessctl # Brightness control
  ];

  # Enable Docker for containerization and NVIDIA container toolkit.
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  # Enable Steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # Configure zsh shell.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable GVFS for file system access. (for nautilus)
  services.gvfs.enable = true;

  # Library for rendering SVG icons
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  # Compatibility layer for unpatched dynamic binaries (e.g. Copilot)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libsecret
      glib
    ];
  };
}
