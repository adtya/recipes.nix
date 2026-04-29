_: {
  globals = {
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };
  keymaps = [
    {
      mode = [ "n" ];
      key = "<leader>1";
      action = "<cmd>Neotree toggle<Return>";
    }
  ];
  plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = false;
      enable_diagnostics = true;
      enable_git_status = true;
      filesystem = {
        filtered_items = {
          visible = true;
        };
        follow_current_file = {
          enabled = true;
        };
        use_libuv_file_watcher = true;
      };
    };
  };
}
