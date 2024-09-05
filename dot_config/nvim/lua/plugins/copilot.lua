return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    cmd = "Copilot",
  },
  {

    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    cmd = "CopilotChat",
    keys = {
      { "<leader>cc", "<cmd>CopilotChat<cr>" },
    },
    opts = {
      debug = true,
    },
  },
}
