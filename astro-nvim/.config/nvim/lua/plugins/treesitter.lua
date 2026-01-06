-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      -- add more arguments for adding more treesitter parsers
      "asm",
      "awk",
      "bash",
      "c",
      "cmake",
      "cpp",
      "csv",
      "git_config",
      "gitcommit",
      "gitignore",
      -- FIXME: broken parser
    --   "latex",
      "nu",
      "powershell",
      "python",
      "typst",
    },
  },
}
