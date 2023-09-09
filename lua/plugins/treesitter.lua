local M = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "make",
        "dockerfile",
        "go",
        "hcl",
        "javascript",
        "json",
        "lua",
        "make",
        "terraform",
        "yaml",
      },
    })
  end,
}

return M
