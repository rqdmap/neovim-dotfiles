-- MacOS 输入法切换, 需要安装 macism
-- xkbswitch 无法正确切换鼠须管, issue: https://github.com/rime/squirrel/issues/402
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
        {'InsertLeave', 'FocusLost'},
        {
            pattern = "*",
            callback = function()
                saved_layout = get_current_layout()
                vim.fn.system('~/Applications/input-source-switcher/build/issw ' .. us_layout_name)
            end
        }
    )

    vim.api.nvim_create_autocmd(
        {'InsertEnter', 'FocusGained'},
        {
            pattern = "*",
            callback = function()
                if(saved_layout ~= us_layout_name) then
                    vim.fn.system('~/Applications/input-source-switcher/build/issw ' .. saved_layout)
                end
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
