-- install deno for ddc
-- MOTD: 'gf' to goto file
-- TODO: neotest: A modern, powerful testing plugin
-- TODO: nvim-navbuddy! A simple popup window that provides

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
plugins = {
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
    {'junegunn/vim-easy-align'},         -- Align on word
    {'m4xshen/autoclose.nvim'},          -- Autoclose functions
    {'kkoomen/vim-doge'},                -- Documentation saffold
    -- - [ ] did this work?
    {'editorconfig/editorconfig-vim'},   -- Consistent coding styles between editors
    -- <leader>d - generate documentation scaffold for function,etc
    {'tpope/vim-eunuch'},                -- :Delete :Move :Rename :SudoWrite :SudoEdit
    {'qpkorr/vim-bufkill'},              -- :BD option to close buffer
    {'mbbill/undotree'},                 -- :UndotreeShow
    {'ctrlpvim/ctrlp.vim'},              -- Fuzzy search
--    {'tpope/vim-surround'},              -- Surround motions replacing with nvim surround
    {'tpope/vim-repeat'},                -- Extending repeat to macros
    {'tpope/vim-fugitive'},              -- Git from vim
    {'tpope/vim-abolish'},               -- Case smart replace/change: via Subvert/cr[smcu]
    {'arnar/vim-matchopen'},             -- Highlight last opened parenthesis
    {'tpope/vim-unimpaired'},            -- Bracket shortcuts
    {'ntpeters/vim-better-whitespace'},  -- Highlight trailing whitespace
    {'tmhedberg/SimpylFold'},            -- Better Python folding
    {'godlygeek/tabular'},               -- Alignment with :Tab /{Pattern}
    {'AndrewRadev/sideways.vim'},        -- Rearrange function parameters
    {'Chiel92/vim-autoformat'},          -- Auto format with :Autoformat
    {'neomake/neomake'},                 -- Static analysis tools :Neomake
    -- maybe try ale instead of neomake sometime
    -- dense-analysis/ale
    {'tell-k/vim-autopep8'},             -- :Autopep8 auto formatting
    {'Vimjas/vim-python-pep8-indent'},   -- pep8 Formatting on newline
    {'nvie/vim-flake8'},                 -- Use flake8 for python linting
    {'christoomey/vim-sort-motion'},     -- gs to sort python imports
    {'michaeljsmith/vim-indent-object'}, -- Indention objects ai/ii/aI/iI mainly for python
    {'vim-scripts/ReplaceWithRegister'}, -- griw - replace section with register value
    {'wellle/targets.vim'},              -- extra text objects - cin) da,
    {'FooSoft/vim-argwrap'},             -- Change argument wrapping
    {'kopischke/vim-fetch'},             -- Opening to specific line using colon number ex :3
    {'cespare/vim-toml'},                -- toml syntax for vim
    {'itchyny/lightline.vim'},           -- Status bar, having error upon lazy install
--    {'nvim-lualine/lualine.nvim', -- need to configure
--      dependencies={ 'nvim-tree/nvim-web-devicons'}
--    },
    {'majutsushi/tagbar'},               -- Show ctags info
    {'Glench/Vim-Jinja2-Syntax'},        -- Fix jinja syntax highlighting
    {'solarnz/thrift.vim'},              -- Thrift syntax
    {'janko-m/vim-test'},                -- Run tests inside vim :TestNearest :TestFile
    {'davidhalter/jedi-vim'},            -- Autocompletion (ctrl + space)
    {'vim-scripts/ingo-library'},        -- Dependent library for JumpToLastOccurrence
    {'vim-scripts/JumpToLastOccurrence'},-- Jump to last occurance of a char with ,f motion ,t
    {'justinmk/vim-sneak'},              -- Two-char search using s motion
    {'AndrewRadev/bufferize.vim'},       -- :Bufferize to output vim functions into buffer
    {'preservim/nerdtree'},-- :NERDTree :NERDTreeToggle :NERDTd T :Tree
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
    -- Python code formatting
    {'ambv/black'},
    {'jackMort/ChatGPT.nvim'}, -- Chatgpt
    {'MunifTanjim/nui.nvim'},
    {'nvim-telescope/telescope.nvim', version= '0.1.1'},
    {'nvim-lua/plenary.nvim'},
    {'nvim-treesitter/nvim-treesitter', build= ':TSUpdate'},
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
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
        vim.diagnostic.config({ virtual_lines = true })
      end,
    },
    "fs111/pydoc.vim",
    -- The alternative is https://github.com/hrsh7th/nvim-cmp
    {'ms-jpq/coq_nvim', branch='coq'}, -- :COQNow
    {'xolox/vim-lua-ftplugin', dependencies='xolox/vim-misc'},
    -- alternative to ftplugin
    -- tbastos/vim-lua
    {'mg979/vim-visual-multi'},
    {  -- unfortunately neotree icons don't all work atm
       -- in power shell (blocked by powershell)
      "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
        },
        cmd="Neotree",
    },
    {'eandrju/cellular-automaton.nvim'}, -- how do I make colorscheme persist?
    {'liuchengxu/vim-which-key'}, -- show keys with
    {'tpope/vim-endwise'}, -- automatically end functions (TESTING)

    -- ^^^ How can I get some timed highlightning when the end is inserted?
    {'tyru/capture.vim', cmd="Capture"}, -- Show Ex command output in a buffer
    {dir="~/dotfiles/vim-myhelp/"}, -- My help plugin
    'mhinz/vim-startify', -- Startup menu that works
    {'michaelb/vim-tips', -- I'm liking this one a lot actually
    },
    {"nvim-treesitter/playground"},
    {"RRethy/nvim-treesitter-endwise"},
    {"kylechui/nvim-surround"},
    {"tpope/vim-scriptease"}, -- Try out :PP :Scriptnames :Time
 -- :Bufferize dump output of command into a buffer
    {"AndrewRadev/bufferize.vim"},
}
-- XXX: How do I embed this?
require("lazy").setup(plugins, opts)

require('nvim-treesitter.configs').setup {
    endwise = {
        enable = true,
    },
}

local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim" vim.cmd.source(vimrc)

vim.api.nvim_set_keymap("n", "-", "@@", {}) -- quickly repeat macros with @@

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- API key required for :Neuralprompt to work
local env = vim.fn.expand('$HOME') .. '/.vim/env.lua'
if file_exists(env) then
    dofile(env)
end
-- TODO lazy load chatgpt plugin
local status_neural, neural = pcall(require, 'neural')
if status_neural then
    require('neural').setup({
        open_ai = {
            api_key = vim.env.OPENAI_API_KEY
        }
    })
end
require("chatgpt").setup()

vim.keymap.set(
  "",
  "<Leader>l",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)

-- fun
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
