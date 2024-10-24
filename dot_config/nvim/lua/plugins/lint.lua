return {
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPost",
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        graphql = { "eslint_d" },
      }

      -- Refresh lints when leaving insert mode / saving
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        callback = function()
          local lint_status, lint = pcall(require, "lint")
          if lint_status then
            lint.try_lint()
          end
        end,
      })
    end,

    -- for ruff, conform.nvim already applies lint fixes
  },
}
