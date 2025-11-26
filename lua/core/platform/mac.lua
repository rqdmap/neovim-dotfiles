-- MacOS 输入法切换, 需要安装 macism
-- issw 与 xkbswitch 均无法正确切换鼠须管, issue: https://github.com/rime/squirrel/issues/402
local function auto_switch_input_method()
    local get_current_layout = function()
        local file = io.popen('macism')
        if file then
            local output = file:read('*all')
            file:close()
            return output
        else
            error("Error occured: macism failed")
            return nil
        end
    end

    local saved_layout = get_current_layout()
    local us_layout_name = "com.apple.keylayout.ABC"

    vim.api.nvim_create_autocmd(
        {'InsertLeave', 'FocusGained'},
        {
            pattern = "*",
            callback = function()
                -- vim.schedule(function()
                    saved_layout = get_current_layout()
                    os.execute('macism ' .. us_layout_name);
                -- end)
            end
        }
    )

    vim.api.nvim_create_autocmd(
        {'InsertEnter'},
        {
            pattern = "*",
            callback = function()
                -- vim.schedule(function()
                if(saved_layout ~= us_layout_name) then
                    os.execute('macism ' .. saved_layout);
                end
                -- end)
            end
        }
    )

    vim.api.nvim_create_autocmd("BufWritePost",{
        pattern = "*/.config/sketchybar/*",
        command = [[
            !sketchybar --reload
        ]]
    })
end


local M = {}

function M.setup(opts)
    auto_switch_input_method()
end

return M
