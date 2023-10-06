local Util = require("lazyvim.util")

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<c-p>", Util.telescope("files"), desc = "Find Files (root dir)" },
  },
}
