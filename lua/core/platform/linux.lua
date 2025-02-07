local function auto_reload_polybar()
    -- 自动重新生成polybar
    vim.api.nvim_create_autocmd("BufWritePost",{
        pattern = "*/polybar/config.ini",
        command = [[
            !polybar_run
        ]]
    })
end


local M = {}

function M.setup(opts)
    auto_reload_polybar()
end

return M
