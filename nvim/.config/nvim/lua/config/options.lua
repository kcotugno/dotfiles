-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if pcall(require, "config.remote_clipboard") then
  require("config.remote_clipboard").setup()
end

vim.g.autoformat = false

local opt = vim.opt

opt.colorcolumn = "80,100"
opt.cursorline = true
opt.list = true
opt.listchars = "tab:――,space:·,trail:·"
opt.mouse = "a"
opt.relativenumber = true
opt.spell = true
opt.wrap = false
