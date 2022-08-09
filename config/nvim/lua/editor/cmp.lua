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
			-- 何も選択してないときのエンター
			if not cmp.get_selected_entry() then
				cmp.abort()
			else
				cmp.confirm()
			end
		else
			fallback()
		end
	end,
}

cmp.setup({
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'path' }
	},{
		{
			name = 'buffer',
		}
	},
	{
		{
			name = 'dictionary',
			keyword_length = 2
		}
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

cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'buffer' }
	})
})

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'cmdline' }
	},{
		{ name = 'path' }
	})
})

local dic = {}
local dict_en = vim.fn.stdpath('data')..'/dicts/en.dict'
if vim.fn.filereadable(dict_en) then
	dic.spelllang = {
		en = dict_en
	}
end
require('cmp_dictionary').setup({
	dic = dic
})
