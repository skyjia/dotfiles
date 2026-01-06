-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",

        -- install LSP servers
        "awk-language-server",
        "bash-language-server",
        -- FIXME: broken language server
        -- "cmake-language-server",
        "dot-language-server",
        "gopls",
        "jdtls",
        "jq-lsp",
        "kotlin-language-server",
        "marksman",
        "taplo",
        "typescript-language-server",
        "yaml-language-server",
        "zls",
      },
    },
  },
}
