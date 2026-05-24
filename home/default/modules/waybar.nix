{ config, pkgs, ... }:

let
  sassContent = pkgs.writeText "style.scss" ''
    @import url("file://${config.xdg.configHome}/matugen/output/waybar.css");

    $rounding: 24px;
    $padding: 4px;
    $side-padding-multiplier: 4;

    $primary: #{"@primary"};
    $primary-hover: #{"darker(@primary)"};

    $bg: #{"@surface"};
    $bg-darker: #{"@surface_container_lowest"};
    $bg-lighter: #{"@surface_container_low"};

    $fg: #{"@on_surface"};
    $fg-primary: #{"@on_primary"};

    $green: #{"@green"};
    $red: #{"@red"};
    $blue: #{"@blue"};
    $orange: #{"@orange"};

    * {
      color: $fg;
      font-weight: 500;
      padding: 0;
      margin: 0;
      min-width: 0;
      min-height: 0;
      transition: all 0.3s ease;
    }

    #waybar {
      background-color: transparent;
    }

    /* globals */
    #custom-menu,
    #workspaces,
    #clock,
    #tray,
    #wireplumber,
    #bluetooth,
    #network,
    #battery {
      border-radius: $rounding;
      background-color: $bg;
      border: 1px solid $bg-lighter;
      padding-left: $padding * $side-padding-multiplier;
      padding-right: $padding * $side-padding-multiplier;
    }

    /* hover effect for interactive elements */
    #custom-menu:hover,
    #wireplumber:hover,
    #bluetooth:hover,
    #network:hover {
      background-color: $bg-lighter;
    }

    /* fix center alignment for custom menu */
    #custom-menu {
      $font-size: 20px;
      font-size: $font-size;
      padding-left: $padding * $side-padding-multiplier;
      padding-right: $padding * $side-padding-multiplier + calc(1 / 7) * $font-size;
    }

    /* workspaces */
    #workspaces {
      /* workspace padding controls all other elements' padding */
      padding: $padding;

      button {
        border-radius: max($rounding - $padding, $rounding / 2);
        background-color: $bg-darker;
        border: 1px solid $bg-lighter;
        min-width: 24px;
      }

      button:hover {
        background-color: $bg-lighter;
      }

      button:not(:last-child) {
        margin-right: $padding;
      }

      button.visible {
        background-color: $primary;
        border: 1px solid transparent;
        min-width: 64px;
      }

      button.visible:hover {
        background-color: $primary-hover;
      }

      label {
        color: transparent;
      }

      button.visible label {
        color: $fg-primary;
      }
    }

    #battery {
      color: $green;
    }

    #network {
      color: $red;
    }

    #bluetooth {
      color: $blue;
    }

    #wireplumber {
      color: $orange;
    }

    /* tray */
    #tray menu {
      background-color: $bg;
      border: 1px solid $bg-lighter;
      padding: $padding * 2;
    }

    #tray separator {
      border: 1px solid $bg-lighter;
      margin-bottom: $padding;
    }

    #tray menuitem {
      border-radius: $padding * 2;
      background-color: $bg;
      padding: $padding;
    }

    #tray menuitem:not(:last-child) {
      margin-bottom: $padding;
    }

    #tray menuitem:hover {
      background-color: $primary;
    }

    #tray menuitem:hover label {
      color: $fg-primary;
    }
  '';

  waybarStyle = pkgs.runCommand "style.css" {
    buildInputs = [ pkgs.dart-sass ];
  } ''
    sass ${sassContent} $out
  '';
in
{
  programs.waybar = {
    enable = true;

    style = builtins.readFile waybarStyle;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 8;
        "margin-left" = 16;
        "margin-right" = 16;
        "margin-top" = 16;
        "margin-bottom" = 0;
        reload_style_on_change = true;

        modules-left = [ "custom/menu" "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "wireplumber" "bluetooth" "network" "battery" ];

        "custom/menu" = {
          format = "";
          on-click = "rofi -show drun";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          all-outputs = true;
          on-click = "hyprctl dispatch 'hl.dsp.focus({ workspace = {id} })'";
          persistent-workspaces = {
            "*" = [ 1 2 3 4 5 ];
          };
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            default = "";
          };
          tooltip = false;
        };

        clock = {
          format = "{:%m %a %I:%M %p}";
          tooltip = false;
        };

        wireplumber = {
          format = "{icon}   {volume}%";
          format-muted = "󰝟";
          format-icons = [ "󰕿" "󰖀" "󰕾" ];
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          max-volume = 200;
          scroll-step = 5;
          tooltip = false;
        };

        bluetooth = {
          format = "";
          format-connected = "󰂯   {device_alias}";
          format-connected-battery = "   {device_alias} {device_battery_percentage}%";
          on-click = "${pkgs.blueman}/bin/blueman-manager";
          tooltip = false;
        };

        network = {
          format-wifi = "{icon}   {essid}";
          format-ethernet = "󰈀    Ethernet";
          format-disabled = "󰤭     Disabled";
          format-disconnected = "󰤭    Disconnected";
          format-icons = [ "󰤯 " "󰤟 " "󰤢 " "󰤥 " "󰤨 " ];
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          tooltip = false;
        };

        battery = {
          format = "{icon}   {capacity}%";
          format-icons = {
            default = [ " " " " " " " " " " ];
            charging = [ "  " "  " "  " "  " "  " ];
          };
          states = {
            warning = 30;
            critical = 15;
          };
          tooltip = false;
        };
      };
    };
  };
}
