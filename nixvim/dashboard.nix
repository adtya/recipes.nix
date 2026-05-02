_: {
  plugins.dashboard = {
    enable = true;
    settings = {
      disable_move = true;
      hide.status_line = false;
      theme = "doom";
      config = {
        vertical_center = true;
        header = [
          "                                                                       "
          "                                                                     "
          "       ████ ██████           █████      ██                     "
          "      ███████████             █████                             "
          "      █████████ ███████████████████ ███   ███████████   "
          "     █████████  ███    █████████████ █████ ██████████████   "
          "    █████████ ██████████ █████████ █████ █████ ████ █████   "
          "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
          " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
          "                                                                       "
        ];
        center = [
          {
            icon = "󰥨 ";
            desc = "Find Files";
            action = {
              __raw = "function(path) vim.cmd('Telescope find_files') end";
            };
            key = "f";
          }
          {
            icon = "󰱼 ";
            desc = "Find Text";
            action = {
              __raw = "function(path) vim.cmd('Telescope live_grep') end";
            };
            key = "g";
          }
          {
            icon = "󰦛 ";
            desc = "Restore Session";
            action = {
              __raw = "function(path) require('persistence').load() end";
            };
            key = "r";
          }
        ];
      };
    };
  };

}
