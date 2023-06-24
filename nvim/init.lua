-- IDEA: gh open github link
--
-- install deno for ddc
-- MOTD: 'gf' to goto file
-- TODO: neotest: A modern, powerful testing plugin
-- TODO: nvim-navbuddy! A simple popup window that provides
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
-- XXX: How do I supress the lazy.nvim source warning
-- XXX: pyright is not working on Windows
-- XXX I don't like the lsp server autocompletion for lua

require "utils"
-- Where do I put this horseshit?:
-- * `Lua.workspace.library`: add element `"${3rd}/luv/library"` ;
-- require "lsp_setup"

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
    {"nxvu699134/vn-night.nvim"},
    {"projekt0n/github-nvim-theme"},
    {"adisen99/codeschool.nvim"},
    {"catppuccin/nvim"},
    {"dasupradyumna/midnight.nvim"},
    {"sekke276/dark_flat.nvim"},

    -- LSP stuff
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate" -- :MasonUpdate updates registry contents
    },
    -- {
    --     'neovim/nvim-lspconfig',
    --     dependencies={"SmiteshP/nvim-navbuddy",
    --         dependencies={"SmiteshP/nvim-navic",
    --         "MunifTanjim/nui.nvim",
    --         "numToStr/Comment.nvim",        -- Optional
    --         "nvim-telescope/telescope.nvim" -- Optional
    --         }
    --     }
    -- },

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
    {'Shougo/ddc.vim', dependencies='vim-denops/denops.vim'},
    'Shougo/ddc-ui-native',
    'Shougo/ddc-source-around',
    'Shougo/ddc-matcher_head',
    'Shougo/ddc-sorter_rank',
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
    -- The alternative is https://github.com/hrsh7th/nvim-cmp
    {'ms-jpq/coq_nvim', branch='coq'}, -- :COQnow
    -- {{"hrsh7th/nvim-cmp"}},
    {'xolox/vim-lua-ftplugin', dependencies='xolox/vim-misc'},
    -- alternative to ftplugin
    -- tbastos/vim-lua
    {'mg979/vim-visual-multi'},
    {'eandrju/cellular-automaton.nvim'}, -- how do I make colorscheme persist?
    {'liuchengxu/vim-which-key'}, -- show keys with
--    {'tpope/vim-endwise'}, -- automatically end functions

    -- ^^^ How can I get some timed highlightning when the end is inserted?
    {'tyru/capture.vim', cmd="Capture"}, -- Show Ex command output in a buffer
    {dir="~/dotfiles/vim-myhelp/"}, -- My help plugin
    'mhinz/vim-startify', -- Startup menu that works
    {'michaelb/vim-tips', -- I'm liking this one a lot actually
    },
    {"nvim-treesitter/playground"},
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
    {
      "folke/todo-comments.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
      }
    },
    {"alec-gibson/nvim-tetris"}, -- :Tetris
    {"lukas-reineke/indent-blankline.nvim"},
    {"seandewar/killersheep.nvim"}, -- :KillKillKill
}
local opts = {}
require("lazy").setup(plugins, opts)

vim.cmd("colorscheme wombat256mod")

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
-- SetupLspServers()
-- ConfigureLSPShortcuts()

-- transform nodes with treesitter
vim.keymap.set({ "n" }, "<leader>k", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
vim.keymap.set({ "n" }, "<leader>n", require("ts-node-action").node_action, { desc = "Trigger Node Action" })

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

require "indent_highlight"
