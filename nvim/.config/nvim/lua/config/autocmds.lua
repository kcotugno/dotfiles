-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(event)
    vim.opt.expandtab = false
    vim.opt.shiftwidth = 8
    vim.opt.tabstop = 8
  end,
})
