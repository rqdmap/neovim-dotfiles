local notify = vim.notify

-- vim.notify = function(msg, ...)
--     if msg:match("vim.lsp.buf_get_clients() is deprecated. Run \":checkhealth vim.deprecated\" for more infor") then
--         return
--     end
--     notify(msg, ...)
-- end
--

local old_error = error
_G.error = function(msg, level)
  if type(msg) == "string" and msg:match("snippet parsing failed") then
    return
  end
  old_error(msg, level)
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = "~/dream/linux/**/*",
  callback = function()
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.softtabstop = 8
    vim.opt_local.expandtab = false
  end
})

