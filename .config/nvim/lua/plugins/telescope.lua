local Telescope = require("telescope.builtin")

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<c-p>", Telescope.find_files, desc = "Find Files (root dir)" },
  },
}
