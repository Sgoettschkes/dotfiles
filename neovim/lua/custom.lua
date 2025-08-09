-- Custom configuration and plugins for Neovim
-- This file contains additions beyond the base kickstart.nvim config

-- Return a table of plugins that will be merged with the kickstart plugins
return {
  -- My custom additions that were at the bottom of init.lua
  config = function()
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0

    vim.o.laststatus = 3
  end,

  -- Additional plugins to install
  plugins = {
    { -- Github neovim theme
      "projekt0n/github-nvim-theme",
      name = "github-theme",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
        require("github-theme").setup({})
        vim.cmd("colorscheme github_dark")
      end,
    },
    { -- Statusline for the bottom of neovim
      "beauwilliams/statusline.lua",
      dependencies = {
        "nvim-lua/lsp-status.nvim",
      },
      config = function()
        require("statusline").setup({
          match_colorscheme = true, -- Enable colorscheme inheritance (Default: false)
          tabline = true, -- Enable the tabline (Default: true)
          lsp_diagnostics = false, -- Enable Native LSP diagnostics (Default: true)
          ale_diagnostics = false, -- Enable ALE diagnostics (Default: false)
        })
      end,
    },
    -- Mason and LSP configuration
    {
      "williamboman/mason.nvim",
      cmd = "Mason",
      opts = {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      },
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      dependencies = { "williamboman/mason.nvim" },
      opts = {
        ensure_installed = {
          "stylua", -- Lua formatter
        },
      },
    },
  },
}
