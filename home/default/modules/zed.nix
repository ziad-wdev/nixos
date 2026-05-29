{ config, ... }:

{
  xdg.configFile."zed/themes/custom.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/matugen/output/zed.json";

  programs.zed-editor = {
    enable = true;

    # Extensions to install
    extensions = [
      "react-snippets-es7"
      "charmed-icons"
      "git-firefly"
      "emmet"
    ];

    # Your keymaps.json configuration
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "alt-d" = [ "editor::SelectNext" { "replace_newest" = false; } ];
          "alt-shift-f" = "editor::Format";
          "ctrl-alt-shift-down" = null;
          "ctrl-d" = "editor::DuplicateLineDown";
          "ctrl-shift-i" = null;
        };
      }
      {
        context = "(Editor && mode == full)";
        bindings = {
          "ctrl-enter" = "editor::NewlineBelow";
        };
      }
      {
        bindings = {
          "ctrl-alt-w" = "workspace::CloseProject";
        };
      }
      {
        context = "Workspace";
        bindings = {
          "ctrl-alt-b" = "workspace::ToggleLeftDock";
          "ctrl-b" = "workspace::ToggleRightDock";
        };
      }
      {
        context = "Workspace";
        unbind = {
          "ctrl-b" = "workspace::ToggleLeftDock";
          "ctrl-alt-b" = "workspace::ToggleRightDock";
        };
      }
    ];

    # Your settings.json configuration
    userSettings = {
      theme = "Matugen Dark";
      agent = {
        default_width = 400;
        flexible = false;
      };
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      buffer_font_family = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
      buffer_font_features = {
        calt = false;
      };
      buffer_font_size = 14;
      cli_default_open_behavior = "existing_window";
      collaboration_panel = {
        default_width = 400;
      };
      colorize_brackets = true;
      diagnostics = {
        inline = {
          enabled = true;
        };
      };
      git_panel = {
        default_width = 400;
        tree_view = true;
      };
      icon_theme = {
        dark = "Soft Charmed Icons";
        light = "Light Charmed Icons";
        mode = "dark";
      };
      indent_guides = {
        active_line_width = 2;
        coloring = "indent_aware";
        line_width = 2;
      };
      minimap = {
        show = "auto";
        thumb = "always";
      };
      outline_panel = {
        default_width = 400;
        indent_guides = {
          show = "never";
        };
      };
      preferred_line_length = 120;
      prettier = {
        allowed = true;
        plugins = [ "@ianvs/prettier-plugin-sort-imports" "prettier-plugin-tailwindcss" ];
      };
      project_panel = {
        auto_fold_dirs = false;
        default_width = 400;
        hide_root = true;
        indent_guides = {
          show = "never";
        };
        scrollbar = {
          show = "never";
        };
      };
      restore_on_startup = "launchpad";
      scrollbar = {
        axes = {
          horizontal = false;
          vertical = false;
        };
      };
      session = {
        trust_all_worktrees = true;
      };
      show_wrap_guides = false;
      soft_wrap = "bounded";
      tab_bar = {
        show_nav_history_buttons = false;
      };
      tab_size = 2;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      terminal = {
        cursor_shape = "block";
        default_height = 400;
      };
      toolbar = {
        breadcrumbs = true;
        selections_menu = false;
      };
      ui_font_family = builtins.head config.fonts.fontconfig.defaultFonts.sansSerif;
      ui_font_size = 16;
    };
  };
}
