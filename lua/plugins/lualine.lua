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
      sections = {
        lualine_c = { { "filename", path = 1 } },
        -- lualine_y = { function() vim.b.format_on_save end }
        lualine_y = {
          function()
            if vim.b.format_on_save then
              return " "
            else
              return " "
            end
          end,
        },
      },
    })
  end,
}

return M
