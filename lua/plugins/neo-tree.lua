local M = {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>fd", "<cmd>Neotree reveal toggle<cr>", desc = "Toggle File Directories" },
  },
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      hijack_netrw_behavior = "disabled",
      use_libuv_file_watcher = true,
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
  end,
}

return M
