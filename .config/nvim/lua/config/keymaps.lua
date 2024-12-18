-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

function ToggleBackground()
  if vim.opt.background:get() == "dark" then
    vim.opt.background = "light"
  else
    vim.opt.background = "dark"
  end
end

vim.keymap.set(
  "n",
  "<F5>",
  "<cmd>lua ToggleBackground()<cr>",
  { desc = "Switch between dark and light themes", noremap = true }
)
