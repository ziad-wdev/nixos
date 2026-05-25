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
    wireplumber.enable = true;
    jack.enable = true;
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

  # Enable sddm
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
    settings = {
      Theme = {
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = 24;
      };
    };
  };
  environment.systemPackages = [ pkgs.bibata-cursors ];

  # Enable hyprland and setup the environment
  programs.hyprland = {
    enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "hyprland" "gtk" ];
  };

  # Enable gnome-keyring for password management
  services.gnome.gnome-keyring.enable = true;

  # Enable polkit for system-wide policy management
  security.polkit.enable = true;

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

  specialisation = {
    Gaming.configuration = {
      hardware.nvidia = {
        prime.sync.enable = lib.mkForce true;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
        powerManagement.finegrained = lib.mkForce false;
      };
    };
  };
}
