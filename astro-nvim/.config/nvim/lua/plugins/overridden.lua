return {
  -- customize treesitter parsers

  {
    -- nvim-neo-tree show hidden files by defaults
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
        opts.filesystem.filtered_items.hide_dotfiles = false
        opts.filesystem.filtered_items.hide_gitignored = false
        return opts
    end,
  },
}
