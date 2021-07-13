local actions = require('telescope.actions')
local trouble = require('trouble.providers.telescope')

local telescope = require('telescope')

telescope.setup{
	defaults={
		initial_mode="insert",
		mappings={
			i = { ["<c-t>"] = trouble.open_with_trouble },
			n = { ["<c-t>"] = trouble.open_with_trouble },
		},
	},
}
--telescope.load_extension('coc')
telescope.load_extension('gh')
