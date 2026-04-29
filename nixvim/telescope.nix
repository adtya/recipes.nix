_: {
  keymaps = [
    {
      mode = [ "n" ];
      key = "<leader><space>";
      action = "<cmd>Telescope buffers<Return>";
    }
    {
      mode = [ "n" ];
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<Return>";
    }
    {
      mode = [ "n" ];
      key = "<leader>fp";
      action = "<cmd>Telescope live_grep<Return>";
    }
  ];
  plugins.telescope = {
    enable = true;
    extensions.fzf-native.enable = true;
  };
}
