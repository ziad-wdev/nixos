{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    awww
    hyprshot
    hyprpicker
  ];

  xdg.configFile."hypr/colors.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/matugen/output/hyprland.lua";

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;

    extraConfig = ''
      -- Import matugen colors
      local colors = require("colors")

      hl.config(colors)

      -- Variables
      local cmds = {
        screenshot       = "pkill slurp || hyprshot -z -m region -o ~/Pictures/screenshots",
        windowScreenshot = "pkill slurp || hyprshot -z -m window -o ~/Pictures/screenshots",
        colorPicker      = "pkill hyprpicker || hyprpicker",
        powerMenu        = "pkill wlogout || wlogout -b 5",
        appLauncher      = "pkill rofi || rofi -show drun",
        wallpaperPicker  = "pkill rofi || bash ~/.config/rofi/scripts/rofi-wallpapers.sh",
        fileManager      = "nautilus",
        terminal         = "ghostty",
        browser          = "zen-beta",
      }

      -- On hyprland startup
      hl.on("hyprland.start", function ()
        hl.exec_cmd("awww-daemon")
        hl.exec_cmd("waybar")
      end)

      -- Environment Variables
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")

      -- Monitor Configuration
      hl.monitor({
        output = "eDP-1",
        mode = "2560x1600@165",
        position = "0x0",
        scale = 1,
      })

      -- Layer Rules (Only for shell elements matching a namespace)
      hl.layer_rule({
        match = { namespace = "logout_dialog" },
        blur = true,
        xray =  true,
      })

      -- Center floating windows and fix their size
      hl.window_rule({
        match = { class = ".*", float = true },
        center = true,
        size = "800 600",
      })

      -- Float generic utility windows
      hl.window_rule({ match = { title = "^(Open File)(.*)$" }, float = true })
      hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, float = true })
      hl.window_rule({ match = { title = "^(Choose wallpaper)(.*)$" }, float = true })
      hl.window_rule({ match = { title = "^(Save As)(.*)$" }, float = true })
      hl.window_rule({ match = { title = "^(Library)(.*)$" }, float = true })

      -- App-specific float rules
      hl.window_rule({ match = { class = "^(xfce4-taskmanager)$" }, float = true })
      hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true })
      hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true })
      hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
      hl.window_rule({ match = { class = "^(file-roller)$" }, float = true })
      hl.window_rule({ match = { title = "^([Pp]icture-in-[Pp]icture)$" }, float = true })
      hl.window_rule({ match = { class = "^(loupe)$" }, float = true })

      -- Configuration
      hl.config({
        debug = {
          disable_logs = false,
          gl_debugging = true,
        },
        general = {
          border_size = 2,
          gaps_in = 8,
          gaps_out = 16,
          layout = "scrolling",
        },
        decoration = {
          rounding = 16,
          rounding_power = 10.0,
          active_opacity = 1.0,
          inactive_opacity = 0.85,
          blur = {
            enabled = true,
            size = 10,
            passes = 3,
            xray = 1,
            popups = 1,
            noise = 0.025,
            contrast = 0.9,
            brightness = 1.0,
            vibrancy = 0.2,
          },
          shadow = {
            enabled = true,
            color = "0x00000080",
            range = 8,
            render_power = 3,
          },
        },
        misc = {
          disable_hyprland_logo = true,
          vrr = 1,
        },
        input = {
          kb_layout = "us,ara",
          kb_options = "grp:win_space_toggle",
          numlock_by_default = true,
          accel_profile = "flat",
          mouse_refocus = false,
          touchpad = {
            natural_scroll = true,
          },
        },
        binds = {
          scroll_event_delay = 50,
          drag_threshold = 10,
        },
      })

      -- Animations and Curves
      -- Curves
      hl.curve("smoothOut", { type = "bezier", points = { {0.36, 0}, {0.66, -0.56} } })
      hl.curve("smoothIn", { type = "bezier", points = { {0.25, 1}, {0.5, 1} } })
      hl.curve("overshot", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
      hl.curve("softSnap", { type = "bezier", points = { {0.4, 0}, {0.2, 1} } })
      hl.curve("fluent", { type = "bezier", points = { {0.0, 0.0}, {0.2, 1.0} } })
      hl.curve("easeInOutExpo", { type = "bezier", points = { {0.87, 0}, {0.13, 1} } })

      -- Windows
      hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" })
      hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "popin 95%" })
      hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "softSnap" })

      -- Layers
      hl.animation({ leaf = "layersIn", enabled = true, speed = 7, bezier = "smoothIn", style = "slide right" })
      hl.animation({ leaf = "layersOut", enabled = true, speed = 8, bezier = "softSnap", style = "slide right" })

      -- Fade
      hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeIn", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "smoothOut" })
      hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeShadow", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeDpms", enabled = true, speed = 4, bezier = "smoothIn" })
      hl.animation({ leaf = "fadeLayers", enabled = true, speed = 3, bezier = "softSnap" })

      -- Workspaces
      hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slidefadevert 30%" })
      hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "overshot", style = "slidefadevert 30%" })

      -- Window Resizing and Dragging
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Application Launchers
      hl.bind("SUPER + T", hl.dsp.exec_cmd(cmds.terminal))
      hl.bind("SUPER + B", hl.dsp.exec_cmd(cmds.browser))
      hl.bind("SUPER + E", hl.dsp.exec_cmd(cmds.fileManager))
      hl.bind("SUPER + A", hl.dsp.exec_cmd(cmds.appLauncher))
      hl.bind("SUPER + W", hl.dsp.exec_cmd(cmds.wallpaperPicker))
      hl.bind("SUPER + L", hl.dsp.exec_cmd(cmds.powerMenu))

      -- Utilities
      hl.bind("PRINT", hl.dsp.exec_cmd(cmds.screenshot))
      hl.bind("SUPER + PRINT", hl.dsp.exec_cmd(cmds.windowScreenshot))
      hl.bind("SUPER + P", hl.dsp.exec_cmd(cmds.colorPicker))

      -- Window Layout Tweaks
      hl.bind("SUPER + Q", hl.dsp.window.close())
      hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + C", hl.dsp.window.center())
      hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

      -- Focus Control
      hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
      hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
      hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
      hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
      hl.bind("SUPER + mouse_down", hl.dsp.focus({ direction = "left" }))
      hl.bind("SUPER + mouse_up", hl.dsp.focus({ direction = "right" }))

      -- Window Swapping
      hl.bind("SUPER + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
      hl.bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
      hl.bind("SUPER + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
      hl.bind("SUPER + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))
      hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.swap({ direction = "left" }))
      hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.swap({ direction = "right" }))

      -- Window Layout/Columns Sizing
      hl.bind("SUPER + equal", hl.dsp.layout("colresize +conf"))
      hl.bind("SUPER + minus", hl.dsp.layout("colresize -conf"))
      hl.bind("SUPER + F", hl.dsp.layout("colresize 1"))
      hl.bind("SUPER + D", hl.dsp.layout("colresize +conf"))

      -- Workspace Jumps
      hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }))
      hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }))
      hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }))
      hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }))
      hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }))
      hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }))
      hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }))
      hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }))
      hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }))
      hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }))

      -- Move Active Windows to Target Workspaces
      hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
      hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
      hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
      hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
      hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
      hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
      hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
      hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
      hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))
      hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

      -- System Integration (Hardware & Controls)
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 2 @DEFAULT_AUDIO_SINK@ 5%+"))
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"))
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"))

      -- Multimedia Controls
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
    '';
  };
}
