-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local max_height = vim.o.lines
local max_width = vim.o.columns
local fullscreen_inset = 2

function toggle_background()
  if vim.opt.background:get() == "dark" then
    vim.opt.background = "light"
  else
    vim.opt.background = "dark"
  end
end

function ToggleFullscreen()
  local bufid = vim.api.nvim_get_current_buf()
  local winid = vim.api.nvim_get_current_win()

  local fullscreen_win = vim.w.fullscreen_win
  if fullscreen_win then
    vim.api.nvim_win_close(winid, false)
    return
  end

  for _, id in ipairs(vim.api.nvim_list_wins()) do
    local res
    res, fullscreen_win = pcall(function()
      return vim.api.nvim_win_get_var(id, "fullscreen_win")
    end)
    if res and fullscreen_win then
      vim.api.nvim_set_current_win(id)
      vim.print(true)
      return
    end
  end

  winid = vim.api.nvim_open_win(bufid, true, {
    relative = "editor",
    border = "rounded",
    row = fullscreen_inset,
    col = fullscreen_inset,
    width = max_width - fullscreen_inset - fullscreen_inset,
    height = max_height - fullscreen_inset - fullscreen_inset - 1,
    title = "Fullscreen (" .. vim.api.nvim_buf_get_name(bufid) .. ")",
    title_pos = "center",
  })
  vim.api.nvim_win_set_var(winid, "fullscreen_win", true)
end

vim.keymap.set(
  "n",
  "<F5>",
  "<cmd>lua toggle_background()<cr>",
  { desc = "Switch between dark and light themes", noremap = true }
)

vim.keymap.set("n", "<leader>m", ToggleFullscreen, { desc = "Maximize window", noremap = true })
