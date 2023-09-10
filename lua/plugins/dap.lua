local M = {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      local Hydra = require("hydra")
      local dap = require("dap")

      local hint = [[
 _n_: step over   _s_: Continue/Start   _b_: Breakpoint
 _i_: step into   _x_: Terminate        _K_: Hover Variables
 _o_: step out    _X_: Force Close      _E_: Evaluate
 _c_: to cursor   _C_: Close UI         _u_: Toggle DAP UI
 ^
 ^ ^              _q_: exit
      ]]

      local dap_hydra = Hydra({
        hint = hint,
        config = {
          color = "pink",
          invoke_on_body = true,
          hint = {
            position = "bottom",
            border = "rounded",
          },
        },
        name = "dap",
        mode = { "n", "x" },
        body = "<leader><leader>d",
        heads = {
          { "C", "<cmd>lua require('dapui').close()<cr>|:DapVirtualTextForceRefresh<cr>", { silent = true } },
          { "E", "<cmd>lua require('dapui').eval()<cr>",                                  { silent = true } },
          { "K", "<cmd>lua require('dap.ui.widgets').hover()<cr>",                        { silent = true } },
          { "X", dap.close,                                                               { silent = true } },
          { "b", dap.toggle_breakpoint,                                                   { silent = true } },
          { "c", dap.run_to_cursor,                                                       { silent = true } },
          { "i", dap.step_into,                                                           { silent = true } },
          { "n", dap.step_over,                                                           { silent = true } },
          { "o", dap.step_out,                                                            { silent = true } },
          { "u", "<cmd>lua require('dapui').toggle()<cr>",                                { silent = true } },
          { "s", dap.continue,                                                            { silent = true } },
          {
            "x",
            "<cmd>lua require('dap').terminate()<cr>|:DapVirtualTextForceRefresh<cr>",
            { exit = true, silent = true },
          },
          {
            "q",
            nil,
            { exit = true, nowait = true },
          },
        },
      })

      Hydra.spawn = function(head)
        if head == "dap-hydra" then
          dap_hydra:activate()
        end
      end

      require("nvim-dap-virtual-text").setup({ commented = true })
      local dapui = require("dapui")
      dapui.setup({})
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_initialized["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end

      require("dap-go").setup()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
  },
}

return M
