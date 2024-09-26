return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "gbrlsnchs/telescope-lsp-handlers.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    keys = {
      { "<space>t", ":Telescope " },
      { "<C-p>", "<cmd>Telescope find_files hidden=true<cr>" },
      { "<C-d>", '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>' },
      { "q:", "<cmd>Telescope command_history<cr>" },
      { "q/", "<cmd>Telescope search_history<cr>" },
      { "<C-f>", ":<cmd>Telescope grep_string<cr>" },
      { "<space>B", ":<cmd>Telescope git_branches<cr>" },
      { "<space>c", ":<cmd>Telescope git_commits<cr>" },
      { "<space>b", ":<cmd>Telescope buffers<cr>" },
      { "<space>r", ":<cmd>Telescope resume<cr>" },
    },
    cmd = {
      "Telescope",
    },
    config = function()
      local lga_actions = require("telescope-live-grep-args.actions")

      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            -- Show hidden files / dirs except .git/ files
            "--hidden",
            "-g",
            "!.git/*",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
              },
            },
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

      -- load telescope-live-grep-args.nvim
      require("telescope").load_extension("live_grep_args")
    end,
  },
}
