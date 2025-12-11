-- Todo
return {
    {
        --[[
        -- Install instructions:
            cd ~/.local/share/nvim/lazy
            git clone https://github.com/iamcco/markdown-preview.nvim.git
            cd markdown-preview.nvim
            npx --yes yarn install
            npx --yes yarn build
        ]]
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        config = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.keymap.set('n', '<leader>mm', "<Plug>MarkdownPreview")
        end,
        ft = { "markdown" },
    },
}



