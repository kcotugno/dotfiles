-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazy.core.util")

function toggle_background()
  Util.info(vim.opt.background:get())
  if vim.opt.background:get() == "dark" then
    vim.opt.background = "light"
  else
    vim.opt.background = "dark"
  end
end

vim.keymap.set("n", "<F5>", "<cmd>lua toggle_background()<cr>", { desc = "Switch between dark and light themes", noremap = true })
