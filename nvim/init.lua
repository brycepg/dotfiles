-- MOTD: 'gf' to goto file
-- IDEA: gh open github link
-- IDEA: mini.treesitter
--  mini.treesitter.swap
--  mini.treesitter.deletearound
--  mini.treesitter.replacecall
--
--  mini.treesitter.
--
-- install deno for ddc
-- folke/trouble.nvim A pretty list for showing diagnostics
-- TODO: Make heading for plugin sections
-- TODO: plugin for deleting conditional. For example
-- IDEA: Mini.github for neovim
-- if (a==b):
--    print("a")
-- print("b")
-- Would become
-- print("a")
-- print("b")
-- I could bisect plugins
-- XXX I don't like the lsp server autocompletion for lua
-- delta=3 delta=5, delta=10?
-- for wombat256mod, nightfox,

-- custom node manipulation:
-- ~/dotfiles/nvim/lua/node_mani.lua

require "utils"
-- Where do I put this horseshit?:
-- * `Lua.workspace.library`: add element `"${3rd}/luv/library"` ;
require "lsp_setup"

-- Bootstrap neovim rcfile access in case rcfile loading fails

vim.api.nvim_create_user_command("Nvimrc", ":e ~/dotfiles/nvim/init.lua", {})

-- set leader before plugin loading according to lazy.nvim
vim.g.mapleader=","
vim.opt.termguicolors = true

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
{
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
},
{
  'nvim-lualine/lualine.nvim',
  dependencies={'nvim-tree/nvim-web-devicons'}
},
{'ntpeters/vim-better-whitespace'},  -- Highlight trailing whitespace
{ 'anuvyklack/pretty-fold.nvim'},
{'nvim-treesitter/nvim-treesitter', build= ':TSUpdate'},

-- Colorschemes
{"EdenEast/nightfox.nvim"},
{"projekt0n/github-nvim-theme"},
{"navarasu/onedark.nvim"},

-- LSP stuff
{
    "williamboman/mason.nvim",
    build=":MasonUpdate",
    -- config = function()
    --     vim.cmd[[normal :MasonUpdate]] -- :MasonUpdate updates registry contents
    -- end
},
{"williamboman/mason-lspconfig.nvim"},
{
    'neovim/nvim-lspconfig',
    -- neovim inlay_hint feature: wait for 0.10
    -- opts = {
    --     inlay_hints = { enabled = true },
    -- },
    dependencies={"SmiteshP/nvim-navbuddy",
        dependencies={"SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
        "numToStr/Comment.nvim",        -- Optional
        "nvim-telescope/telescope.nvim" -- Optional
        }
    }
},
{"jose-elias-alvarez/null-ls.nvim"},

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
{'majutsushi/tagbar'},               -- Show ctags info
{'Glench/Vim-Jinja2-Syntax'},        -- Fix jinja syntax highlighting
{'solarnz/thrift.vim'},              -- Thrift syntax
{ -- Run tests inside vim
'janko-m/vim-test'}, -- :TestNearest :TestFile
{ -- A framework for interacting with tests within NeoVim.
  "nvim-neotest/neotest", -- :Neotest <args>
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim"
    }
},

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
    -- {'jackMort/ChatGPT.nvim'}, -- Chatgpt
    {'MunifTanjim/nui.nvim'},
    {'nvim-telescope/telescope.nvim', version= '0.1.1'},
    {'nvim-lua/plenary.nvim'},
    -- 'vim-denops/denops.vim',
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
    {'junegunn/fzf', build=function()
        vim.cmd[[fzf#install()]]
    end
    },
    {'junegunn/fzf.vim'},
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
    { -- open ipynb in vim
        "meatballs/notebook.nvim",
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
     -- {dir="~/myneovimplugin"},
     -- {dir="~/colo-blankline-indent.nvim"},
    {"echasnovski/mini.ai"}, -- TODO
    {'vladdoster/remember.nvim'},
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = "nvim-treesitter/nvim-treesitter",
    },
    -- currently treeclimber is broken
    -- {"Dkendal/nvim-treeclimber",
    --  dependencies={
    --     "rktjmp/lush.nvim",
    --     "nvim-treesitter/nvim-treesitter",
    -- }
    -- },
{"ziontee113/syntax-tree-surfer", -- vd to swap node
 dependencies="nvim-treesitter/nvim-treesitter"},
-- {"rktjmp/lush.nvim"}, -- :LushRunQuickstart
{ -- modify arguments under cursor
    'echasnovski/mini.splitjoin', -- gS
    version = "*" },
{"RRethy/nvim-treesitter-textsubjects"},
{
    "HampusHauffman/block.nvim", -- :Block
},
{"crispgm/telescope-heading.nvim"}, -- :Telescope heading
{ -- quickfix menu
  'weilbith/nvim-code-action-menu',
  cmd='CodeActionMenu',
},
{"rlane/pounce.nvim"}, -- :Pounce
{
  "folke/flash.nvim", -- s/S/gs
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
  function()
          require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
},

{ -- IDE like search and replace with
    'nvim-pack/nvim-spectre', -- :Spectre
    dependencies={"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons"}
},
{"romainchapou/nostalgic-term.nvim"}, -- better :term defaults

}
require("lazy").setup(plugins, {})
require("neodev").setup{
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    -- these settings will be used for your Neovim config directory
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    -- you can also specify the list of plugins to make available as a workspace library
    plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
  -- for your Neovim config directory, the config.library settings will be used as is
  -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
  -- for any other directory, config.library.enabled will be set to false
  override = function(root_dir, options) end,
  -- With lspconfig, Neodev will automatically setup your lua-language-server
  -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
  -- in your lsp start options
  lspconfig = true,
  -- much faster, but needs a recent built of lua-language-server
  -- needs lua-language-server >= 3.6.0
  pathStrict = true,
}
require "node_mani" -- custom
require'alpha'.setup(require'alpha.themes.startify'.config)
require('mini.splitjoin').setup{}
require("block").setup{}
require('pretty-fold').setup{
  fill_char = ' ',
}
require('spectre').setup()
require('telescope').load_extension('heading')

require('nostalgic-term').setup({
  mappings = {
    {'<c-h>', 'h'},
    {'<c-j>', 'j'},
    {'<c-k>', 'k'},
    {'<c-l>', 'l'},
  },
  add_normal_mode_mappings = true,
  add_vim_ctrl_w = false,
})

-- Lualine configuration
require('lualine').setup {
  options = {
      theme = "codedark",
      component_separators = { left = '|', right = '|' },
      icons_enabled = false,
  },
  sections = {
      lualine_a = {'mode'},
      -- removed branch due to disuse for now
      lualine_b = {'diagnostics'},
      lualine_c = {
        {
            'filename',
            path=1,
            shorting_target=0,
        },
      },
      lualine_x={'diff', 'encoding', 'fileformat'},
  },
  inactive_sections = {
      lualine_c = {
          -- 'diff', 'diagnostics',
          'filetype',
          {
              'filename',
              path=1,
          }
      },
  }
}

-- Evaluate syntax-tree-surfer, compare to treeclimber
local status_treeclimber, treeclimber = pcall(require, 'nvim-treeclimber')
if status_treeclimber then
    treeclimber.setup()
end

-- write to swap file immediately
vim.cmd[[ set updatetime=100 ]]

-- vim.cmd("colorscheme wombat256mod")
vim.cmd("colorscheme nightfox")

require('Comment').setup()
require('todo-comments').setup{
    keywords = {
        WARN = { icon = " ", color = "#FF0000", alt = { "WARNING", "XXX" } },

    }
}
require("neodev").setup({})

-- then setup your lsp server as usual

require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<cr>", "ciw")
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
vim.keymap.set('n', '<leader>nb', require("nvim-navbuddy").open)

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
    endwise = {
        enable = true,
    },
    indent = {
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
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
  },
    textsubjects = {
        enable = true,
        -- prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
        },
    },
}

require("mason").setup()
require("mason-lspconfig").setup()
-- The language servers keep breaking
-- LSP configuration
-- SetupLspServers()
-- embeded due to lua_ls issues
local navbuddy = require("nvim-navbuddy")
require'lspconfig'.pyright.setup{}
require'lspconfig'.vimls.setup{
    on_attach = function(client, bufnr)
        navbuddy.attach(client, bufnr)
    end
}
-- require'lspconfig'.lua_ls.settings.Lua.workspace.checkThirdParty = false
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require'lspconfig'.lua_ls.setup {
  on_attach = function(client, bufnr)
      navbuddy.attach(client, bufnr)
  end,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
        },
      runtime = {
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
      telemetry = {
        enable = false,
      },
    },
  },
  capabilities = capabilities,
}
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- See
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#refactoring
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#ts_node_action
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#luasnip
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#vsnip
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#ansiblelint
        null_ls.builtins.diagnostics.ansiblelint,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
        -- `luarocks install luacheck`
        -- null_ls.builtins.diagnostics.luacheck,
        -- `npm install markdownlint --save-dev`
        -- null_ls.builtins.diagnostics.markdownlint,
        -- Does neomake do the same thing?
        -- null_ls.builtins.diagnostics.flake8
        -- null_ls.builtins.diagnostics.pydocstyle
        -- null_ls.builtins.diagnostics.vulture
        -- null_ls.builtins.formatting.isort
        -- :'<,'>lua vim.lsp.buf.range_code_action()
        -- :'<,'>Telescope lsp_range_code_actions
        null_ls.builtins.code_actions.refactoring,
    },
})
ConfigureLSPShortcuts()

-- transform nodes with treesitter
vim.keymap.set({ "n" }, "<leader>k", require("ts-node-action").node_action, { desc = "Trigger Node Action" })

-- Source ~/dotfiles/nvim/vimrc.vim here
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim" vim.cmd.source(vimrc)

vim.api.nvim_set_keymap("n", "-", "@@", {}) -- quickly repeat macros with @@
vim.keymap.set("n", "dp", delete_function_declaration_lines)

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
    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
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
  ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
-- cmp.setup.cmdline({ '/', '?' }, {
-- mapping = cmp.mapping.preset.cmdline(),
-- sources = {
--   { name = 'buffer' }
-- }
-- })

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
-- I had to manually remove cro from runtime via :verbose set formatoptions?
vim.cmd([[
set formatoptions-=cro
]])

-- Supress re source warning for lazy.nvim
vim.g.lazy_did_setup = false


-- Syntax Tree Surfer
local surfer_opts = {noremap = true, silent = true}
require"syntax-tree-surfer".setup()

-- Normal Mode Swapping:
-- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
-- Syntax tree surfer
vim.keymap.set("n", "vU", function()
	vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })
vim.keymap.set("n", "vD", function()
	vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })

-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
vim.keymap.set("n", "vd", function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })
vim.keymap.set("n", "vu", function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })

--> If the mappings above don't work, use these instead (no dot repeatable)
-- vim.keymap.set("n", "vd", '<cmd>STSSwapCurrentNodeNextNormal<cr>', surfer_opts)
-- vim.keymap.set("n", "vu", '<cmd>STSSwapCurrentNodePrevNormal<cr>', surfer_opts)
-- vim.keymap.set("n", "vD", '<cmd>STSSwapDownNormal<cr>', surfer_opts)
-- vim.keymap.set("n", "vU", '<cmd>STSSwapUpNormal<cr>', surfer_opts)

-- Visual Selection from Normal Mode
vim.keymap.set("n", "vx", '<cmd>STSSelectMasterNode<cr>', surfer_opts)
vim.keymap.set("n", "vn", '<cmd>STSSelectCurrentNode<cr>', surfer_opts)

-- Select Nodes in Visual Mode
vim.keymap.set("x", "J", '<cmd>STSSelectNextSiblingNode<cr>', surfer_opts)
vim.keymap.set("x", "K", '<cmd>STSSelectPrevSiblingNode<cr>', surfer_opts)
vim.keymap.set("x", "H", '<cmd>STSSelectParentNode<cr>', surfer_opts)
vim.keymap.set("x", "L", '<cmd>STSSelectChildNode<cr>', surfer_opts)

-- Swapping Nodes in Visual Mode
vim.keymap.set("x", "<A-j>", '<cmd>STSSwapNextVisual<cr>', surfer_opts)
vim.keymap.set("x", "<A-k>", '<cmd>STSSwapPrevVisual<cr>', surfer_opts)


-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], {noremap = true, silent = true, expr = false})

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})


vim.api.nvim_create_user_command(
    "DisableAutoComplete",
    function(opts)
        require('cmp').setup.buffer { enabled = false }
    end, {}
)
vim.api.nvim_create_user_command(
    "EnableAutoComplete",
    function(opts)
        require('cmp').setup.buffer { enabled = true }
    end, {}
)
