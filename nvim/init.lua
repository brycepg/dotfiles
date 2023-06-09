-- MOTD: 'gf' to goto file
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim" vim.cmd.source(vimrc)

-- API key required for :Neuralprompt to work
local env = vim.fn.expand('$HOME') .. '/.vim/env.lua'
dofile(env)
local status_neural, neural = pcall(require, 'neural')
if status_neural then
    if vim.env.OPENAI_API_KEY == nil then
        print("Please set the OPENAI_API_KEY environment variable")
    end
    require('neural').setup({
        open_ai = {
            api_key = vim.env.OPENAI_API_KEY
        }
    })
end

require("chatgpt").setup()
