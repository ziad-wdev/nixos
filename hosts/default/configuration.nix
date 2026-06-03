{ username, config, lib, pkgs, ... }:

{
  # Configure the system state version
  system.stateVersion = "26.05";

  # Configure Nix settings
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    use-xdg-base-directories = true;
    auto-optimise-store = true;
  };

  # Configure the network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Configure bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Set the time zone to Cairo
  time.timeZone = "Africa/Cairo";

  # Create the user
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };

  # Configure the boot loader
  boot.loader = {
    systemd-boot.enable = false;
    grub.enable = false;
    efi.canTouchEfiVariables = true;
    limine = {
      enable = true;
      maxGenerations = 10;
      enableEditor = true;
      efiInstallAsRemovable = true;
      style = {
        wallpapers = [
          (pkgs.fetchurl {
            url = "https://port8080.sh/images/limine-splash.png";
            sha256 = "sha256-+S8J+XKbIpfNKbN76/yBEpbYx3FUiXQ5Ut5LmBeFAt8=";
          })
        ];
        wallpaperStyle = "stretched";
      };
    };
  };

  # Enable hyprland and setup the environment
  programs.hyprland = {
    enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Enable gnome-keyring for password management
  services.gnome.gnome-keyring.enable = true;

  # Enable polkit for system-wide policy management
  security.polkit.enable = true;

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Enable essential graphics hardware settings
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.finegrained = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      open = false;
    };
  };

  # Optimize network performance
  boot.kernel.sysctl = {
    # Use BBR congestion control with CAKE qdisc
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";

    # Enable TCP Fast Open
    "net.ipv4.tcp_fastopen" = 3;

    # Increase TCP buffer sizes
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";

    # Enable MTU probing for black hole routers
    "net.ipv4.tcp_mtu_probing" = 1;

    # Disable TCP slow start after idle
    "net.ipv4.tcp_slow_start_after_idle" = 0;

    # Enable Explicit Congestion Notification (ECN)
    "net.ipv4.tcp_ecn" = 1;

    # Tune TCP keepalive for faster dead connection detection
    "net.ipv4.tcp_keepalive_time" = 60;
    "net.ipv4.tcp_keepalive_intvl" = 10;
    "net.ipv4.tcp_keepalive_probes" = 6;
  };
  # Enable local DNS caching
  services.resolved.enable = true;
}
