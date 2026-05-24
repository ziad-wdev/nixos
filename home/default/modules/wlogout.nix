{ config, ... }:

let
  iconDir = ./icons;
in
{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "logout";
        action = "sleep 0.5; hyprctl dispatch 'hl.dsp.exit()'";
        keybind = "l";
      }
      {
        label = "lock";
        action = "sleep 0.5; hyprlock";
        keybind = "k";
      }
      {
        label = "sleep";
        action = "sleep 0.5; hyprlock && systemctl suspend";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "sleep 0.5; systemctl reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "sleep 0.5; systemctl poweroff";
        keybind = "h";
      }
    ];

    style = ''
      @import url("file://${config.xdg.configHome}/matugen/output/wlogout.css");

      window {
        background: rgba(0, 0, 0, 0.5);
      }

      button {
        background-color: transparent;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 40%;
        outline: none;
        border: none;
        border-radius: 64px;
        margin: 8px;
        margin-top: 365px;
        margin-bottom: 365px;
        transition: all 0.3s ease;
      }

      button:hover,
      button:focus {
        background-color: @primary;
        background-size: 50%;
      }

      #logout { background-image: url("${iconDir}/logout.svg"); }
      #logout:hover, #logout:focus { background-image: url("${iconDir}/dark-logout.svg"); }

      #lock { background-image: url("${iconDir}/lock.svg"); }
      #lock:hover, #lock:focus { background-image: url("${iconDir}/dark-lock.svg"); }

      #sleep { background-image: url("${iconDir}/sleep.svg"); }
      #sleep:hover, #sleep:focus { background-image: url("${iconDir}/dark-sleep.svg"); }

      #reboot { background-image: url("${iconDir}/reboot.svg"); }
      #reboot:hover, #reboot:focus { background-image: url("${iconDir}/dark-reboot.svg"); }

      #shutdown { background-image: url("${iconDir}/shutdown.svg"); }
      #shutdown:hover, #shutdown:focus { background-image: url("${iconDir}/dark-shutdown.svg"); }
    '';
  };
}
