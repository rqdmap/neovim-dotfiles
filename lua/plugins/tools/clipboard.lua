return {
    "dfendr/clipboard-image.nvim",
    config = function ()
        local path = vim.fn.expand('%:p:h')
        require'clipboard-image'.setup({
            default = {
                img_dir = path .. "/images",
                img_dir_txt = "./images",
                img_name = function ()
                    return os.date('%Y%m%d-%H%M%S')
                end,
            },
            markdown = {
                affix = [[

{{< img-with-caption src="%s" max-width="600px" >}}

{{< /img-with-caption >}}
]]

            }
        })
        vim.keymap.set("n", "<Leader>p", "<cmd>PasteImg<CR>")
    end
}
