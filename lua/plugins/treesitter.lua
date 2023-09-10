local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
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
        highlight = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        incremental_selection = {
          enable = true,
          keymaps = {
            -- Start by entering visual mode
            scope_incremental = "<cr>",
            node_incremental = "<tab>",
            node_decremental = "<s-tab>",
          },
        },
        endwise = { enable = true },
        indent = { enable = true },
        autopairs = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = {
                query = "@function.outer",
                desc = "select around a function",
              },
              ["if"] = {
                query = "@function.inner",
                desc = "select inner part of a function",
              },
              ["ac"] = {
                query = "@class.outer",
                desc = "select around a class",
              },
              ["ic"] = {
                query = "@class.inner",
                desc = "select inner part of a class",
              },
            },
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-treehopper",
    dependencies = { "phaazon/hop.nvim" },
    config = function()
      require("hop").setup()
      require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }
      vim.keymap.set("n", "<leader>m", "<cmd>lua require('tsht').nodes()<cr>", { desc = "Hop" })
    end,
  },
}

return M
