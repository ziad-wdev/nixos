{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        type = "file";
        source = ../../assets/icons/ascii.txt;
        color = {
          "1" = "1";
        };
      };

      display = {
        separator = " ";
      };

      modules = [
        { type = "os"; key = " "; keyColor = "1"; }
        { type = "kernel"; key = " "; keyColor = "1"; }
        { type = "packages"; key = " "; keyColor = "1"; }
        { type = "shell"; key = " "; keyColor = "1"; }
        { type = "terminal"; key = " "; keyColor = "1"; }
        { type = "wm"; key = " "; keyColor = "1"; }
        { type = "cursor"; key = " "; keyColor = "1"; }
        { type = "terminalfont"; key = " "; keyColor = "1"; }
        { type = "uptime"; key = " "; keyColor = "1"; }
        { type = "datetime"; format = "{1}-{3}-{11}"; key = " "; keyColor = "1"; }
        { type = "memory"; key = "󰍛 "; keyColor = "1"; }
        { type = "monitor"; key = " "; keyColor = "1"; }
      ];
    };
  };
}
