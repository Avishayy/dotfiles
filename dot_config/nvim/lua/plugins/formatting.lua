return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    config = function()
      local slow_format_filetypes = {}
      require("conform").setup {
        format_on_save = function(bufnr)
          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          local function on_format(err)
            if err and err:match("timeout$") then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return { timeout_ms = 200, lsp_fallback = true }, on_format
        end,

        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_fallback = true }
        end,
        formatters_by_ft = {
          javascript = { "eslint_d", "prettierd" },
          typescript = { "eslint_d", "prettierd" },
          javascriptreact = { "eslint_d", "prettierd" },
          typescriptreact = { "eslint_d", "prettierd" },
          python = { { "ruff" }, { "black", "isort" } },
          rust = { "rustfmt" },
          lua = { "stylua" },
        },
      }
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
