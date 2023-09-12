local M = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
    },
  },
  opts = {
    theme = "onedark",
  },
  config = function()
    require("lualine").setup({
      sections = { lualine_c = { { "filename", path = 1 } } },
    })
  end,
}

return M
