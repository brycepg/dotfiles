local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim" vim.cmd.source(vimrc)
require('neural').setup({
    open_ai = {
        api_key = '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'
    }
})
