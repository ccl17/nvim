local api = vim.api

--- Remove all trailing whitespace on save
-- local TrimWhiteSpaceGrp = api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
-- api.nvim_create_autocmd("BufWritePre", {
--   command = [[:%s/\s\+$//e]],
--   group = TrimWhiteSpaceGrp,
-- })

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

local InitBufFormatOnSaveGrp = api.nvim_create_augroup("InitBufFormatOnSaveGrp", { clear = true })
api.nvim_create_autocmd("BufReadPre", {
  group = InitBufFormatOnSaveGrp,
  callback = function()
    vim.b.format_on_save = true
    vim.keymap.set(
      "n",
      "<leader>fF",
      "<cmd>lua vim.b.format_on_save = not vim.b.format_on_save<cr>",
      { desc = "Toggle format on save", buffer = bufnr, noremap = true, silent = true }
    )
  end,
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- go to last loc when opening a buffer
api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- show cursor line only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  pattern = "*",
  command = "set cursorline",
  group = cursorGrp,
})
api.nvim_create_autocmd(
  { "InsertEnter", "WinLeave" },
  { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

api.nvim_create_autocmd("FileType", {
  pattern = {
    "json",
    "lua",
    "sh",
    "vim",
    "yaml",
    "yml",
    "zsh",
  },
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.softtabstop = 2
    vim.opt.tabstop = 2
  end,
})
