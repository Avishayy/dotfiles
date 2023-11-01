return {
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPost",
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
      }
    end,

    -- for ruff, conform.nvim already applies lint fixes
  },
}
