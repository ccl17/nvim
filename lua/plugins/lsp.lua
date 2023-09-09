local M = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim",          build = ":MasonUpdate" },
      { "williamboman/mason-lspconfig.nvim" },
      { "folke/neodev.nvim",                config = true },
      { "onsails/lspkind-nvim" },
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              formatting = {
                enable = false,
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              gofumpt = true,
              hints = {
                compositeLiteralTypes = true,
                functionTypeParameters = true,
                parameterNames = true,
              },
              semanticTokens = true,
              usePlaceholders = true,
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("mason").setup()

      local tools = {
        "golangci-lint",
        "goimports",
        "stylua",
        "yamlfmt",
      }
      local mason_registry = require("mason-registry")
      local function install_ensured()
        for _, tool in ipairs(tools) do
          local p = mason_registry.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mason_registry.refresh then
        mason_registry.refresh(install_ensured)
      else
        install_ensured()
      end

      local mason_lspconfig = require("mason-lspconfig")
      local lsp_config = require("lspconfig")
      local lsp_attach = function(_, bufnr)
        local default_options = { buffer = bufnr, noremap = true, silent = true }
        local keymap = vim.keymap
        require("which-key").register({ l = { name = "lsp" } }, { prefix = "<leader>", mode = "n" })

        -- Keymaps
        default_options.desc = "Goto Declaration"
        keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, default_options)

        default_options.desc = "Line Diagnostics"
        keymap.set("n", "<leader>ll", vim.diagnostic.open_float, default_options)

        default_options.desc = "Rename"
        keymap.set("n", "<leader>lR", function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end, vim.tbl_extend("force", default_options, { expr = true }))

        default_options.desc = "Goto Definition"
        keymap.set("n", "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", default_options)

        default_options.desc = "References"
        keymap.set("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", default_options)

        default_options.desc = "Goto Implementation"
        keymap.set("n", "<leader>lI", "<cmd>Telescope lsp_implementations<cr>", default_options)

        default_options.desc = "Goto Type Definition"
        keymap.set("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", default_options)

        default_options.desc = "Hover"
        keymap.set("n", "K", vim.lsp.buf.hover, default_options)
      end

      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
      lsp_capabilities = require("cmp_nvim_lsp").default_capabilities(lsp_capabilities)
      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
        },
      })
      mason_lspconfig.setup_handlers({
        function(server_name)
          lsp_config[server_name].setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = opts.servers[server_name] and opts.servers[server_name].settings or {},
          })
        end,
        ["gopls"] = function(server_name)
          lsp_config[server_name].setup({
            on_attach = function(client, bufnr)
              local inlayhints = require("lsp-inlayhints")
              inlayhints.setup({ inlay_hints = { type_hints = { prefix = "=> " } } })
              inlayhints.on_attach(client, bufnr)

              lsp_attach(client, bufnr)
              if client.supports_method("textDocument/formatting") then
                local augroup = vim.api.nvim_create_augroup("GoplsFormatting", { clear = true })
                vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                  group = augroup,
                  buffer = bufnr,
                  callback = function()
                    vim.lsp.buf.format({ group = augroup, buffer = bufnr })
                  end,
                })
              end
            end,
            capabilities = lsp_capabilities,
            settings = opts.servers[server_name] and opts.servers[server_name].settings or {},
          })
        end,
      })

      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
        },
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local nls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      nls.setup({
        debug = true,
        sources = {
          -- Linters
          nls.builtins.diagnostics.golangci_lint,
          -- Formatters
          nls.builtins.formatting.goimports,
          nls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
          nls.builtins.formatting.yamlfmt,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ group = augroup, buffer = bufnr })
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local opts = { desc = "Trouble", silent = true, noremap = true }
      vim.keymap.set("n", "<leader>lx", "<cmd>TroubleToggle<cr>", opts)
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {},
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    dependencies = "neovim/nvim-lspconfig",
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")
      local vsc = require("luasnip.loaders.from_vscode")
      local lua = require("luasnip.loaders.from_lua")

      ls.config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })

      -- load lua snippets
      lua.load({ paths = os.getenv("HOME") .. "/.config/nvim/snippets/" })
      -- load friendly-snippets
      -- this must be loaded after custom snippets or they get overwritte!
      -- https://github.com/L3MON4D3/LuaSnip/blob/b5a72f1fbde545be101fcd10b70bcd51ea4367de/Examples/snippets.lua#L497
      vsc.lazy_load()

      -- expansion key
      -- this will expand the current item or jump to the next item within the snippet.
      vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      -- jump backwards key.
      -- this always moves to the previous item within the snippet
      vim.keymap.set({ "i", "s" }, "<c-k>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      -- selecting within a list of options.
      vim.keymap.set("i", "<c-h>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            with_text = false,
            maxwidth = 50,
            mode = "symbol",
            menu = {
              buffer = "BUF",
              nvim_lsp = "LSP",
              path = "PATH",
              luasnip = "SNIP",
            },
          }),
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-u>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "buffer",                 keyword_length = 5 },
          { name = "luasnip" },
          { name = "path" },
        },
        experimental = {
          ghost_text = true,
        },
      })

      -- Use buffer source for / (if you enabled native_menu, this won't work anymore).
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },
}

return M
