return {
  {
    "folke/noice.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          inc_rename = true,
        },
        routes = {
          {
            filter = { event = "msg_show", kind = "search_count" },
            opts = { skip = true },
          },
          {
            filter = { event = "msg_show", kind = "", find = "written" },
            opts = { skip = true },
          },
        },
      }
    end,
  },
}
