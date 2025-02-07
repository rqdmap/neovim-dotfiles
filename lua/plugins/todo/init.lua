return {
	-- 图片预览: Alacrity, Waiting for pull/4763
	{
		'adelarsq/image_preview.nvim',
		config = function()
			require("image_preview").setup()
		end
	},
}
