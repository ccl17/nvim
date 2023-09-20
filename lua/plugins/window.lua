local M = {
  {
    "s1n7ax/nvim-window-picker",
    config = function()
      require("window-picker").setup({
        hint = "floating-big-letter",
        selection_chars = "asdfhjkl",
        filter_rules = {
          bo = {
            filetype = { "neo-tree" },
            buftype = { "help", "terminal", "nofile" },
          },
        },
      })
    end,
    tag = "stable",
  },
  {
    "christoomey/vim-tmux-navigator",
  },
  {
    "anuvyklack/windows.nvim",
    event = "VimEnter",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    opts = {
      autowidth = {   -- |windows.autowidth|
        enable = true,
        winwidth = 5, -- |windows.winwidth|
        filetype = {  -- |windows.autowidth.filetype|
          help = 2,
        },
      },
      ignore = { -- |windows.ignore|
        buftype = { "quickfix" },
        filetype = { "NvimTree", "neo-tree", "undotree", "NeogitStatus" },
      },
      animation = {
        enable = true,
        duration = 300,
        fps = 30,
        easing = "in_out_sine",
      },
    },
    config = function()
      require("windows").setup()
      local map = vim.keymap.set
      map("n", "<C-w>z", "<Cmd>WindowsMaximize<CR>")
      map("n", "<C-w>_", "<Cmd>WindowsMaximizeVertically<CR>")
      map("n", "<C-w>|", "<Cmd>WindowsMaximizeHorizontaly<CR>")
      map("n", "<C-w>=", "<Cmd>WindowsEqualize<CR>")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("indent_blankline").setup({
        buftype_exclude = { "terminal", "nofile" },
        char_list = { "|", "¦", "┆", "┊" },
      })
    end,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
  },
}

return M
