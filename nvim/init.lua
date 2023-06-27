-- IDEA: gh open github link
-- IDEA: mini.treesitter
--  mini.treesitter.swap
--  mini.treesitter.deletearound
--  mini.treesitter.replacecall
--  mini.treesitter.
--
--
-- install deno for ddc
-- MOTD: 'gf' to goto file
-- TODO: neotest: A modern, powerful testing plugin
-- folke/trouble.nvim A pretty list for showing diagnostics
-- TODO: Make heading for plugin sections
-- TODO: plugin for deleting conditional. For example
-- TODO: How do I make highlight group for XXX red?
-- if (a==b):
--    print("a")
-- print("b")
-- Would become
-- print("a")
-- print("b")
-- TODO: What is turning hyphen character lines unto UTF monstrosities?
-- I could bisect plugins
-- XXX: pyright is not working on Windows
-- XXX I don't like the lsp server autocompletion for lua
-- delta=3 delta=5, delta=10?
-- for wombat256mod, nightfox,
--
-- Currently working on neodev completion for lua
-- : https://github.com/folke/neodev.nvim

require "utils"
-- Where do I put this horseshit?:
-- * `Lua.workspace.library`: add element `"${3rd}/luv/library"` ;
require "lsp_setup"

-- Bootstrap neovim rcfile access in case rcfile loading fails

vim.api.nvim_create_user_command("Nvimrc", ":e ~/dotfiles/nvim/init.lua", {})

-- set leader before plugin loading according to lazy.nvim
vim.g.mapleader=","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Remove bootstrap after installation on linux
-- Afterward create documentation on how to install
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
plugins = {
    -- Foundational stuff
    {'itchyny/lightline.vim'},           -- Status bar, having error upon lazy install
    {'ntpeters/vim-better-whitespace'},  -- Highlight trailing whitespace
    {'nvim-treesitter/nvim-treesitter', build= ':TSUpdate'},

    -- Colorschemes
    {"EdenEast/nightfox.nvim"},
    {"projekt0n/github-nvim-theme"},

    -- LSP stuff
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate" -- :MasonUpdate updates registry contents
    },
    {
        'neovim/nvim-lspconfig',
        dependencies={"SmiteshP/nvim-navbuddy",
            dependencies={"SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
            "numToStr/Comment.nvim",        -- Optional
            "nvim-telescope/telescope.nvim" -- Optional
            }
        }
    },

    -- Autocompletion stuff
    {'m4xshen/autoclose.nvim'},          -- Autoclose functions

    --- XXX: bigger heading
    ------------- Useful tools
    {'mbbill/undotree'},                 -- :UndotreeShow
    {'qpkorr/vim-bufkill'},              -- :BD option to close buffer
    {'ctrlpvim/ctrlp.vim'},              -- Fuzzy search <Space>f <Space>b <Ctrl-p>
    {'junegunn/vim-easy-align'},         -- Align on word
    {'tpope/vim-abolish'},               -- Case smart replace/change: via Subvert/cr[smcu]
    {'brycepg/nvim-eunuch'},             -- :Delete :Move :Rename :SudoWrite :SudoEdit
    {'godlygeek/tabular'},               -- :Tab /{Pattern}
    {'mhinz/vim-signify'},
    {"numToStr/Comment.nvim", -- gcc or <visual>gc
    dependencies="nvim-treesitter/nvim-treesitter"},

    -- 'ds' is not working for some reason
    -- {"kylechui/nvim-surround", dependencies='nvim-treesitter/nvim-treesitter'},
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    -- {'tpope/vim-surround'},        -- Surround motions replacing with nvim surround

    -- maybe try ale instead of neomake sometime
    -- dense-analysis/ale
    {'neomake/neomake'},                 -- Static analysis tools :Neomake
    {'kopischke/vim-fetch'},             -- Opening specific line using colon number ex :3

    -- Both of these trees for now
    {'preservim/nerdtree'},-- :NERDTree :NERDTreeToggle :NERDTd T :Tree
    {"nvim-neo-tree/neo-tree.nvim",  -- :NeoTreeToggle
        branch = "v2.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
        },
        cmd="Neotree",
    },
    -- :Telescope file_browser
    {"nvim-telescope/telescope-file-browser.nvim"},
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },

    -- Do I want these?
    {"tpope/vim-scriptease"}, -- Try out :PP :Scriptnames :Time

    -- Havent used?
    {'AndrewRadev/sideways.vim'},        -- Rearrange function parameters
    {'Chiel92/vim-autoformat'},          -- Auto format with :Autoformat
    {'vim-scripts/ReplaceWithRegister'}, -- griw - replace section with register value
    {'tell-k/vim-autopep8'},             -- :Autopep8 auto formatting
    {'michaeljsmith/vim-indent-object'}, -- Indention objects ai/ii/aI/iI mainly for python
    {'christoomey/vim-sort-motion'},     -- gs to sort python imports
    {'wellle/targets.vim'},              -- extra text objects - cin) da,
    {'tpope/vim-fugitive'},              -- Git from vim
    {'tpope/vim-repeat'},                -- Extending repeat to macros
    -- <leader>d - generate documentation scaffold for function,etc
    {'kkoomen/vim-doge'},                -- Documentation saffold
    {'arnar/vim-matchopen'},             -- Highlight last opened parenthesis
    {'tmhedberg/SimpylFold'},            -- Better Python folding
    {'nvie/vim-flake8'},                 -- Use flake8 for python linting
    {'editorconfig/editorconfig-vim'},   -- Consistent coding styles between editors
    {'tpope/vim-unimpaired'},            -- Bracket shortcuts
    {'Vimjas/vim-python-pep8-indent'},   -- pep8 Formatting on newline
    {'FooSoft/vim-argwrap'},             -- Change argument wrapping
    {'cespare/vim-toml'},                -- toml syntax for vim
--    {'nvim-lualine/lualine.nvim', -- need to configure
--      dependencies={ 'nvim-tree/nvim-web-devicons'}
--    },
    {'majutsushi/tagbar'},               -- Show ctags info
    {'Glench/Vim-Jinja2-Syntax'},        -- Fix jinja syntax highlighting
    {'solarnz/thrift.vim'},              -- Thrift syntax
    {'janko-m/vim-test'},                -- Run tests inside vim :TestNearest :TestFile
    -- {'davidhalter/jedi-vim'},            -- Autocompletion (ctrl + space)
    {'vim-scripts/ingo-library'},        -- Dependent library for JumpToLastOccurrence
    {'vim-scripts/JumpToLastOccurrence'},-- Jump to last occurance of a char with ,f motion ,t
    {'justinmk/vim-sneak'},              -- Two-char search using s motion
    {'AndrewRadev/bufferize.vim'},       -- :Bufferize to output vim functions into buffer
    {'ambv/black'}, -- Python code formatting
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },
    -- prebuilt snippits - do they work with LuaSnip
    {'honza/vim-snippets'},

    -- Search cheatsheet for neovim
    {'sudormrfbin/cheatsheet.nvim'},
    {'nvim-lua/popup.nvim'},
    {'nvim-lua/plenary.nvim'},


    -- Trying out this linter for ansible make sure to install required linters in
    -- Gemfile or requirements.txt
    {'mfussenegger/nvim-lint'},

    -- Doesn't work yet, blocked my Neural config and maybe plug
    -- Does it work now? :checkhealth is all green on quarth
    {'dense-analysis/neural'},
    {'MunifTanjim/nui.nvim'},
    {'elpiloto/significant.nvim'},

    -- Colorschemes
    {'morhetz/gruvbox'},
    {'jackMort/ChatGPT.nvim'}, -- Chatgpt
    {'MunifTanjim/nui.nvim'},
    {'nvim-telescope/telescope.nvim', version= '0.1.1'},
    {'nvim-lua/plenary.nvim'},
    'vim-denops/denops.vim',
    -- deno was timing out on fedora for ddc
    -- {'Shougo/ddc.vim', dependencies='vim-denops/denops.vim'},
    -- 'Shougo/ddc-ui-native',
    -- 'Shougo/ddc-source-around',
    -- 'Shougo/ddc-matcher_head',
    -- 'Shougo/ddc-sorter_rank',
    'phaazon/hop.nvim',
    {
      "folke/edgy.nvim",
      event = "VeryLazy",
      opts = {}
    },
    -- { Getting duplicate output
    --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --   config = function()
    --     require("lsp_lines").setup()
    --     vim.diagnostic.config({ virtual_lines = true })
    --   end,
    -- },
    "fs111/pydoc.vim",
    -- Not working on windows due to python path issue
    -- {'ms-jpq/coq_nvim', branch='coq'}, -- :COQnow
    -- {{"hrsh7th/nvim-cmp"}},
    -- {'xolox/vim-lua-ftplugin', dependencies='xolox/vim-misc'},
    -- alternative to ftplugin
    -- tbastos/vim-lua

    {'mg979/vim-visual-multi'},
    {'liuchengxu/vim-which-key'}, -- show keys with
--    {'tpope/vim-endwise'}, -- automatically end functions

    -- ^^^ How can I get some timed highlightning when the end is inserted?
    {'tyru/capture.vim', cmd="Capture"}, -- Show Ex command output in a buffer
    {dir="~/dotfiles/vim-myhelp/"}, -- My help plugin
    {"nvim-treesitter/playground"}, -- :TSPlaygroundToggle
    {"RRethy/nvim-treesitter-endwise"},

    -- Does this work?
    {"xolox/vim-colorscheme-switcher", dependencies="xolox/vim-misc"},
 -- :Bufferize dump output of command into a buffer
    {"AndrewRadev/bufferize.vim"},
    {"justinmk/vim-dirvish"}, -- Create files in netrw using :e %foo.txt
    {"mattn/emmet-vim"},
    -- {"Olical/conjure"}, Getting documentation lookup errors
    {"HiPhish/nvim-ts-rainbow2"},
    {"mileszs/ack.vim"},
    {"junegunn/fzf"},
    {"easymotion/vim-easymotion"}, -- TODO Test
    {"tzachar/highlight-undo.nvim"}, -- XXX does it work do i like?
    {"ThePrimeagen/refactoring.nvim"}, -- TODO
    {
        'ckolkey/ts-node-action',
         dependencies = { 'nvim-treesitter' },
         opts = {},
    },
    {"github/copilot.vim"}, -- :Copilot enable
    { -- highlight todo comments
      "folke/todo-comments.nvim",
      dependencies = {"nvim-lua/plenary.nvim", "folke/trouble.nvim", "nvim-telescope/telescope.nvim"},
      opts = {
--          signs = false,
      }
    },
    -- Games
    {"alec-gibson/nvim-tetris"}, -- :Tetris
    {"seandewar/killersheep.nvim"}, -- :KillKillKill
    {'eandrju/cellular-automaton.nvim'}, -- how do I make colorscheme persist?
    {--  Focus on current  function
        "koenverburg/peepsight.nvim"}, -- :PeepsightEnable
    {"folke/twilight.nvim"}, -- :TwilightEnable
    { -- "A code outline window for skimming and quick navigation"
      'stevearc/aerial.nvim',
      opts = {},
      -- Optional dependencies
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons"
      },
    },
   {'hrsh7th/cmp-nvim-lsp', dependencies="neovim/nvim-lspconfig"},
   {'hrsh7th/cmp-buffer'},
   {'hrsh7th/cmp-path'},
   {'hrsh7th/cmp-cmdline'},
   {'hrsh7th/nvim-cmp'}, -- uses lspconfig
    { "folke/neodev.nvim", opts = {} },
    -- {"~/colo-blankline-indent.nvim" init=function
    --     require("colo-blankline-indent").setup({delta=5})
    -- end},
    { -- open ipynb in vim
        "meatballs/notebook.nvim"},
    {"startup-nvim/startup.nvim",
  dependencies={"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
  },
    {
        "SmiteshP/nvim-navbuddy", -- :NavBuddy
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
            "numToStr/Comment.nvim",        -- Optional
            "nvim-telescope/telescope.nvim" -- Optional
        }
    },
    {dir="~/myneovimplugin"},
}
local opts = {}
require("lazy").setup(plugins, opts)
require("startup").setup()
vim.cmd[[ set updatetime=100 ]]

-- vim.cmd("colorscheme wombat256mod")
vim.cmd("colorscheme nightfox")

require('Comment').setup()
require("neodev").setup({})

-- then setup your lsp server as usual
local lspconfig = require('lspconfig')

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
vim.keymap.set('n', '<leader>nb', require("nvim-navbuddy").open)

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
    endwise = {
        enable = true,
    },
    rainbow = {
      enable = true,
      -- list of languages you want to disable the plugin for
      disable = { 'vim', 'lua' },
      -- Which query to use for finding delimiters
      query = 'rainbow-parens',
      -- Highlight the entire buffer all at once
      strategy = require('ts-rainbow').strategy.global,
    },
}

-- The language servers keep breaking
-- LSP configuration
SetupLspServers()
ConfigureLSPShortcuts()

-- transform nodes with treesitter
vim.keymap.set({ "n" }, "<leader>k", require("ts-node-action").node_action, { desc = "Trigger Node Action" })

-- Source ~/dotfiles/nvim/vimrc.vim here
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim" vim.cmd.source(vimrc)

vim.api.nvim_set_keymap("n", "-", "@@", {}) -- quickly repeat macros with @@

-- API key required for :Neuralprompt to work
local env = vim.fn.expand('$HOME') .. '/.vim/env.lua'
if file_exists(env) then
    dofile(env)
end

local status_neural, _ = pcall(require, 'neural')
if status_neural then
    require('neural').setup({
        open_ai = {
            api_key = vim.env.OPENAI_API_KEY
        }
    })
end
local status_chatgpt, _ = pcall(require, 'chatgpt')
if status_chatgpt then
    require("chatgpt").setup()
end

-- Jump to todo comments
vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- require "indent_highlight"

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-u>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-a>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
    })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--   require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--     capabilities = capabilities
--   }
-- I had to manually remove cro from runtime via :verbose set formatoptions?
vim.cmd([[
set formatoptions-=cro
]])

-- Supress re source warning for lazy.nvim
vim.g.lazy_did_setup = false
