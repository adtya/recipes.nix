_: {
  imports = [
    ./bufferline.nix
    ./gitsigns.nix
    ./lualine.nix
    ./lsp.nix
    ./neo-tree.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  viAlias = true;
  vimAlias = true;

  opts = {
    autowrite = true;
    background = "dark";
    clipboard = "unnamedplus";
    expandtab = true;
    laststatus = 2;
    list = true;
    number = true;
    relativenumber = true;
    scrolloff = 10;
    shiftwidth = 2;
    showmode = false;
    signcolumn = "yes";
    smartindent = true;
    softtabstop = 2;
    splitbelow = true;
    splitright = true;
    swapfile = false;
    tabstop = 2;
    termguicolors = true;
    updatetime = 100;
    wrap = false;
  };

  keymaps = [
    {
      mode = [ "n" ];
      key = "<C-a>";
      action = "<cmd>bprevious<Return>";
    }
    {
      mode = [ "n" ];
      key = "<C-d>";
      action = "<cmd>bnext<Return>";
    }
    {
      mode = [ "n" ];
      key = "<C-h>";
      action = "<cmd>nohlsearch<Return>";
    }
    {
      mode = [ "n" ];
      key = "<leader>w";
      action = "<cmd>bdelete<Return><cmd>bnext<Return>";
    }
    {
      mode = [ "n" ];
      key = "<leader>q";
      action = "<cmd>close<Return>";
    }
  ];

  clipboard.providers.wl-copy.enable = true;
  colorschemes.dracula-nvim = {
    enable = true;
    settings = {
      transparent_bg = true;
    };
  };

}
