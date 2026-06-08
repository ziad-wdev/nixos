{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "lockscreen";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl -e4 -s set 25%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 1200;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1350;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
