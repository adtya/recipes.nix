_: {
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "dracula";
        globalstatus = true;
        icons_enabled = true;
        component_separators = "|";
        section_separators = "";
        disabled_filetypes = {
          statusline = [ "neo-tree" ];
        };
      };
    };
  };
}
