-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("kevin_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("filetypes"),
  pattern = { "*.cls" },
  callback = function(event)
    vim.bo[event.buf].filetype = "apex"
    vim.bo[event.buf].shiftwidth = 4
    vim.bo[event.buf].tabstop = 4
  end,
})
