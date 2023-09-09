local themes = {
  onedark = {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("onedark")
    end,
  },
  darcula = {
    "xiantang/darcula-dark.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("darcula-dark")
    end,
    lazy = false,
  },
}

return themes["darcula"]
