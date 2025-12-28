return {

  {
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd [[colorscheme tokyodark]]
    end,
  },

	{
		'scottmckendry/cyberdream.nvim',
		opts = {
			transparent = false,
			italic_comments = true,
			hide_fillchars = false,
			borderless_telescope = true,
			terminal_colors = true,
		},
	},
}
