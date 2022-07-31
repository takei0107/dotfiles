local cmp = require('cmp')

local mapping = {
	['<C-s>'] = function(fallback) 
		if cmp.visible() then
			cmp.close()
		else
			cmp.complete()
		end
	end,
	['<Tab>'] = function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		else
			fallback()
		end
	end,
	['<S-Tab>'] = function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		else
			fallback()
		end
	end,
	['<CR>'] = function(fallback)
		if cmp.visible() then
			cmp.confirm()
		else
			fallback()
		end
	end,
}

cmp.setup({
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
		{ name = 'nvim_lsp_signature_help' }
	}),
	snippet = {
		expand = function(args)
			vim.fn['vsnip#anonymous'](args.body)
		end,
	},
	mapping = mapping,
	preselect = cmp.PreselectMode.None,
	completion = {},
})
