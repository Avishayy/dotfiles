return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
             cmake --build build --config Release && \
             cmake --install build --prefix build",
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "gbrlsnchs/telescope-lsp-handlers.nvim",
    },
    keys = {
      { "<space>t", ":Telescope " },
      { "<C-p>", "<cmd>Telescope find_files<cr>" },
      { "<C-d>", "<cmd>Telescope live_grep<cr>" },
      { "q:", "<cmd>Telescope command_history<cr>" },
      { "q/", "<cmd>Telescope search_story<cr>" },
      { "<C-f>", ":<cmd>Telescope grep_string<cr>" },
      { "<space>b", ":<cmd>Telescope git_branches<cr>" },
      { "<space>c", ":<cmd>Telescope git_commits<cr>" },
    },
    cmd = {
      "Telescope",
    },
    config = function()
      require("telescope").setup {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
        pickers = {
          git_branches = {
            -- By default <cr> does a detached checkout, use switch instead
            mappings = {
              i = { ["<cr>"] = require("telescope.actions").git_switch_branch },
            },
          },
        },
      }

      -- load telescope-fzf-native.nvim
      require("telescope").load_extension("fzf")

      -- load telescope-lsp-handlers.nvim
      require("telescope").load_extension("lsp_handlers")
    end,
  },
}
