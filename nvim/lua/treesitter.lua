require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
	highlight = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	playground = {
		enable = true,
		updatetime = 25,
	}
}
vim.o.foldmethod='expr'
vim.o.foldexpr='nvim_treesitter#foldexpr()'
