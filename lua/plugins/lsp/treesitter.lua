return {
    "nvim-treesitter/nvim-treesitter",
    {
        "nvim-treesitter/nvim-treesitter-refactor",
        config = function()
            require'nvim-treesitter.configs'.setup {
                  -- 代码块语法高亮
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "markdown" },
                },
                refactor = {
                    highlight_definitions = {
                        enable = true,
                        -- Set to false if you have an `updatetime` of ~100.
                        clear_on_cursor_move = true,
                    },
                    -- highlight_current_scope = { enable = true },
                },
            }
        end
    }
}


