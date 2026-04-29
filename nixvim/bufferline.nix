_: {
  plugins = {
    web-devicons.enable = true;
    bufferline = {
      enable = true;
      settings = {
        options = {
          themable = false;
          diagnostics = "nvim_lsp";
          mode = "buffers";
          offsets = [
            {
              filetype = "neo-tree";
              text = "File Tree";
              separator = true;
            }
          ];
          #separator_style = "slant";
          show_buffer_close_icons = false;
          show_close_icon = false;
        };
        highlights = {
          buffer_selected = {
            italic = false;
          };
          indicator_selected = {
            fg = {
              attribute = "fg";
              highlight = "Function";
            };
            italic = false;
          };
        };
      };
    };
  };
}
