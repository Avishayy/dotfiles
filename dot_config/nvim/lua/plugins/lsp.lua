local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Enable inlay hints
  require("lsp-inlayhints").on_attach(client, bufnr)

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  local nsilent_bufopts = { noremap = true, buffer = bufnr }

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>s", vim.lsp.buf.workspace_symbol, nsilent_bufopts)
  vim.keymap.set("n", "<space>d", vim.lsp.buf.document_symbol, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  -- Uses IncRename instead
  -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  -- code actions is setup in actions-preview below

  if client.server_capabilities.semanticTokensProvider then
    vim.lsp.semantic_tokens.start(bufnr, client.id)
    vim.cmd([[ highlight link @interface @type ]])
  end
end

return {
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      vim.keymap.set({ "v", "n" }, "<space>ca", require("actions-preview").code_actions)
      require("actions-preview").setup {
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "folke/neodev.nvim",
      "b0o/SchemaStore.nvim",
      "lvimuser/lsp-inlayhints.nvim",
      "simrat39/rust-tools.nvim",
      "nvim-telescope/telescope.nvim",
      "aznhe21/actions-preview.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      require("neodev").setup {
        library = { plugins = { "nvim-dap-ui" }, types = true },
      }

      require("lspconfig").lua_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      require("lspconfig").jsonls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }

      require("lspconfig").pyright.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        before_init = function(_, config)
          local Path = require("plenary.path")

          -- Check if CONDA_PREFIX exists and use it
          if os.getenv("CONDA_PREFIX") then
            config.settings.python.pythonPath = os.getenv("CONDA_PREFIX") .. "/bin/python"
            return
          end

          -- Check for .venv and use it if exists
          local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
          if venv:joinpath("bin"):is_dir() then
            config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
          end
        end,
      }

      require("lspconfig").clangd.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      require("rust-tools").setup {
        server = {
          on_attach = on_attach,
        },
      }

      require("lspconfig").kotlin_language_server.setup {
        server = {
          capabilities = capabilities,
          on_attach = on_attach,
        },
      }

      require("lspconfig").html.setup {
        server = {
          capabilities = capabilities,
          on_attach = on_attach,
        },
      }

      require("lspconfig").tailwindcss.setup {
        server = {
          capabilities = capabilities,
          on_attach = on_attach,
        },
      }

      require("lspconfig").cssls.setup {
        server = {
          capabilities = capabilities,
          on_attach = on_attach,
        },
      }

      require("lspconfig").cssmodules_ls.setup {
        server = {
          capabilities = capabilities,
          on_attach = on_attach,
        },
      }

      require("lspconfig").graphql.setup {
        server = {
          capabilities = capabilities,
          on_attach = on_attach,
        },
        root_dir = require("lspconfig").util.root_pattern(
          ".git",
          ".graphqlrc*",
          ".graphql.config.*",
          "graphql.config.*"
        ),
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup {
        ui = {
          border = "rounded",
        },
        PATH = "append",
      }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPost",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "ts_ls",
          "pyright",
          "lua_ls",
          "jsonls",
          "rust_analyzer",
          "kotlin_language_server",
          "tailwindcss",
          "cssls",
          "cssmodules_ls",
          "graphql",
        },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>t", "<cmd>TroubleToggle<cr>" },
    },
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    config = true,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function()
      require("lsp-inlayhints").setup {
        inlay_hints = {
          only_current_line = true,
        },
      }
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = {
      "IncRename",
    },
    keys = {
      { "<space>rn", ":IncRename " },
    },
    config = true,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    event = "BufReadPost",
    config = function()
      require("typescript-tools").setup {
        on_attach = on_attach,
        settings = {
          tsserver_max_memory = 16384,
          tsserver_file_preferences = {
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
            importModuleSpecifierPreference = "relative",
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      }
    end,
  },
}
