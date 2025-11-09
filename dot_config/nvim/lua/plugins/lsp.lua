-- Setup LspAttach autocmd to configure buffer-local keymaps and options
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

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
  end,
})

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
      "nvim-telescope/telescope.nvim",
      "aznhe21/actions-preview.nvim",
    },
    config = function()
      -- Setup neodev for Neovim Lua development
      require("neodev").setup {
        library = { plugins = { "nvim-dap-ui" }, types = true },
      }

      -- Configure global capabilities from nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Lua Language Server
      vim.lsp.config("lua_ls", {
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
      })
      vim.lsp.enable("lua_ls")

      -- JSON Language Server with SchemaStore
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.enable("jsonls")

      -- basedpyright with virtual environment detection
      vim.lsp.config("basedpyright", {
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
      })
      vim.lsp.enable("basedpyright")

      -- Deno Language Server (only start if deno.json/deno.jsonc exists)
      vim.lsp.config("denols", {
        root_markers = { "deno.json", "deno.jsonc" },
        workspace_required = true,
      })
      vim.lsp.enable("denols")

      -- C/C++ Language Server
      vim.lsp.enable("clangd")

      -- Rust Analyzer (handled by rustaceanvim plugin)
      -- Note: rustaceanvim is configured separately and doesn't need setup here

      -- Kotlin Language Server
      vim.lsp.enable("kotlin_language_server")

      -- HTML Language Server
      vim.lsp.enable("html")

      -- Tailwind CSS Language Server
      vim.lsp.enable("tailwindcss")

      -- CSS Language Server
      vim.lsp.enable("cssls")

      -- CSS Modules Language Server
      vim.lsp.enable("cssmodules_ls")

      -- GraphQL Language Server
      vim.lsp.config("graphql", {
        root_markers = {
          ".git",
          ".graphqlrc*",
          ".graphql.config.*",
          "graphql.config.*",
        },
      })
      vim.lsp.enable("graphql")

      -- Copilot Language Server
      vim.lsp.enable("copilot")
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
        automatic_enable = false,
        ensure_installed = {
          "biome",
          "copilot",
          "cssls",
          "cssmodules_ls",
          "denols",
          "graphql",
          "jsonls",
          "kotlin_language_server",
          "lua_ls",
          "basedpyright",
          "rust_analyzer",
          "tailwindcss",
          "ts_ls",
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
        single_file_support = false,
        root_dir = function(fname)
          -- Avoid starting if deno.json/deno.jsonc exists (let denols handle it)
          local util = require("lspconfig.util")
          if util.root_pattern("deno.json", "deno.jsonc")(fname) then
            return nil
          end
          return util.root_pattern("package.json", "tsconfig.json")(fname)
        end,
        settings = {
          tsserver_max_memory = 16384,
          tsserver_file_preferences = {
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
            importModuleSpecifierPreference = "relative",
          },
        },
      }
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
  },
}
