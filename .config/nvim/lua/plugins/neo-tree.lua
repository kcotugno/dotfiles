return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<c-\\>", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false
      }
    }
  }
}
