-- ~/.config/nvim/lua/plugins/snippets.lua
return {
  -- { "nvim-mini/mini.snippets", enabled = false },
  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip").filetype_extend("javascriptreact", { "html" })
      require("luasnip").filetype_extend("typescriptreact", { "html" })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
