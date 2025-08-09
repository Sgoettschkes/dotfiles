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
