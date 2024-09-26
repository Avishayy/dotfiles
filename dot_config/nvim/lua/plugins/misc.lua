return {
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "Wansmer/treesj",
    event = "BufReadPost",
    opts = { max_join_length = 150 },
  },
  {
    "tpope/vim-eunuch",
    event = "VeryLazy",
  },
  {
    "kylechui/nvim-surround",
    keys = {
      "ys",
      "ds",
      "cs",
    },
    config = true,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup {
        log_level = "error",
      }
    end,
  },
  {
    "tpope/vim-abolish",
    event = "VeryLazy",
  },
  {
    "dhruvasagar/vim-zoom",
    keys = {
      { "<leader>z", "<Plug>(zoom-toggle)" },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    config = true,
  },
  {
    "lfv89/vim-interestingwords",
    keys = { "<leader>k", "<leader>K" },
  },
  { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  {
    "nvim-neorg/neorg",
    dependencies = { "luarocks.nvim" },
    lazy = false,
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {
            config = {
              icon_preset = "diamond",
            },
          }, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                work = "~/notes",
                personal = "~/personal_notes",
              },
            },
          },
          ["core.keybinds"] = {
            config = {
              hook = function(keybinds)
                -- I want my regualar <CR> saves mapping, use K instead
                keybinds.remap_key("norg", "n", "<CR>", "K")

                -- Can't use <C-Space> on my mac as I use it for language switch, CTRL-T is fine
                keybinds.remap_key("norg", "n", "<C-Space>", "<C-t>")
              end,
            },
          },
          -- Convert unordered lists to ordered lists or vice versa with <LL>LT
          ["core.pivot"] = {},
          -- Continue current type of item (heading, list, todo) with Alt-Enter
          ["core.itero"] = {},
          -- Support completion in norg files
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          -- External templates plugin (pysan3/neorg-templates)
          ["external.templates"] = {},
        },
      }

      -- Create autocmd for journal template file for each workspace
      local config_dir = vim.fn.stdpath("config")
      local neorg_dirman = require("neorg.core.modules")["loaded_modules"]["core.dirman"]["public"]
      for workspace_name, neorg_dir in pairs(neorg_dirman.get_workspaces()) do
        local template_name = workspace_name .. "_journal"
        local workspace_journal_file = config_dir .. "/templates/norg/" .. template_name .. ".norg"
        if require("utils").file_exists(workspace_journal_file) then
          vim.api.nvim_create_autocmd("BufNewFile", {
            command = "Neorg templates fload " .. template_name,
            pattern = { neorg_dir .. "/journal/*.norg" },
          })
        end
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "black",
        "isort",
        "prettierd",
        "stylua",
        "eslint_d",
        "debugpy",
      },
    },
  },
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },
  {
    "chrisgrieser/nvim-early-retirement",
    config = function()
      require("early-retirement").setup {
        minimumBufferNum = 10,
      }
    end,
    event = "VeryLazy",
  },
}
