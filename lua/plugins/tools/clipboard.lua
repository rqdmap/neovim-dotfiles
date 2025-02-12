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

<div align="center">
<img src=%s style="width:100%%; max-width:600px;">
<div class="img-caption"></div>
</div>
]]
            }
		})
        vim.keymap.set("n", "<Leader>p", "<cmd>PasteImg<CR>")
	end
}
