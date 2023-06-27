function SetupLspServers()
    local navbuddy = require("nvim-navbuddy")
    require'lspconfig'.pyright.setup{}
    require'lspconfig'.vimls.setup{
        on_attach = function(client, bufnr)
            navbuddy.attach(client, bufnr)
        end
    }
    -- require'lspconfig'.lua_ls.settings.Lua.workspace.checkThirdParty = false
    require'lspconfig'.lua_ls.setup {
      on_attach = function(client, bufnr)
          navbuddy.attach(client, bufnr)
      end,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
            disable = {"lowercase-global"},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
end


function ConfigureLSPShortcuts()
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local lsp_opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, lsp_opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, lsp_opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, lsp_opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, lsp_opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, lsp_opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, lsp_opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, lsp_opts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, lsp_opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, lsp_opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, lsp_opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, lsp_opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, lsp_opts)
        vim.keymap.set('n', '<space>F', function()
          vim.lsp.buf.format { async = true }
        end, lsp_opts)
      end,
    })
end
