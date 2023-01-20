local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim" vim.cmd.source(vimrc)

-- API key required for :Neuralprompt to work
local env = vim.fn.expand('$HOME') .. '/.config/nvim/env.lua'
if vim.env.OPENAI_API_KEY == nil then
    print("Please set the OPENAI_API_KEY environment variable")
    return
end
local status_neural, neural = pcall(require, 'neural')
if status_neural then
    require('neural').setup({
        open_ai = {
            api_key = vim.env.OPEN_API_KEY
        }
    })
end
