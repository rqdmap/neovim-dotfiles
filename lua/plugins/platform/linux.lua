return {
    {
        -- 切换模式时切换输入法
        'lilydjwg/fcitx.vim',
        enabled = require("core.utils").is_linux(),
    },

	-- {
	-- 	'ivanesmantovich/xkbswitch.nvim',
	-- 	init = function ()
	-- 		require('xkbswitch').setup()
	-- 	end
	-- },
}

