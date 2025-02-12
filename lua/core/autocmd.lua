-- 自动跳转到上次编辑的位置
vim.api.nvim_create_autocmd("BufReadPost",{
	command = [[
		if line("'\"") > 0 && line("'\"") <= line("$") |
		exe "normal! g`\"" |
		endif
	]]
})


-- 自动生成dot文件的png图片
vim.api.nvim_create_autocmd("BufWritePost",{
	pattern = "*.dot",
	command = [[
		!dot -Tpng -o %.png % 
	]]
})

-- 修改giph源码时则修改对应的缩进
vim.api.nvim_create_autocmd("BufRead",{
	pattern = "giph",
	command = [[
		setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
	]]
})

-- 自动更新账本
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*/beancount/*/*.yaml",
    callback = function()
        -- 获取当前文件的完整路径
        local current_file = vim.fn.expand("%:p")
        -- 从路径中提取 beancount 目录
        local beancount_dir = current_file:match("(.*)/beancount/")

        if beancount_dir then
            -- 使用 beancount_dir/beancount 作为工作目录
            local cmd = string.format("silent !cd %s/beancount && make run > /dev/null 2>&1 &", beancount_dir)
            vim.cmd(cmd)
        end
    end
})
