return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format { async = true, timeout_ms = 500, lsp_fallback = true }
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "eslint_d", "prettierd" },
        typescript = { "eslint_d", "prettierd" },
        javascriptreact = { "eslint_d", "prettierd" },
        typescriptreact = { "eslint_d", "prettierd" },
        python = { { "ruff" }, { "black", "isort" } },
        rust = { "rustfmt" },
        lua = { "stylua" },
      },
      format_on_save = {
        async = true,
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
