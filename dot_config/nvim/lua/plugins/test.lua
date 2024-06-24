return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    -- so lazy..
    lazy = false,
    config = function()
      require("neotest").setup {
        adapters = {
          require("neotest-python") {
            dap = { justMyCode = false },
          },
        },
      }
    end,
  },
}
