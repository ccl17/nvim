local themes = {
  onedark = {
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "darker",
      })
      require("onedark").load()
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
  github = {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("github_dark_high_contrast")
    end,
  },
}

return themes["onedark"]
