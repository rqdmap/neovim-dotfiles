return {
    -- Gruvbox 配色
    {
        "ellisonleao/gruvbox.nvim",
        commit = "a7cacf59418a6fe52da3d022bfd76a8caf34dc8d",
        init = function()
            require("gruvbox").setup({
                -- Markdown 换行的列表颜色
                palette_overrides = {
                    bright_aqua = "",
                }
            })
            vim.cmd([[colorscheme gruvbox]])
        end
    },

    'Valloric/MatchTagAlways',

    -- 为Rofi提供语法高亮
    'Fymyte/rasi.vim',

    -- .ron高亮
    'ron-rs/ron.vim',

    -- 代码颜色展示
    {
        'norcalli/nvim-colorizer.lua',
        config = function ()
            require('colorizer').setup()
        end
    },
}
