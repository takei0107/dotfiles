local sources = require("plugins.cmp.nvim-cmp-sources") or {}

-- resolve dependencies for 'lazy.nvim'
local function resolve_deps()
	local deps = {"L3MON4D3/LuaSnip"}
	for _, source in ipairs(sources) do
		local spec = {
			[1] = source.name,
			lazy = true
		}
		table.insert(deps, spec)
	end
	return deps
end

return {
	"hrsh7th/nvim-cmp",
	--cond = false,
	event = "InsertEnter",
	dependencies = resolve_deps(),
	config = function()
		local cmp = require("cmp")
		local types = require("cmp.types")
		cmp.setup({
			enabled = true,

			-- required
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end
			},

			mapping = {
				-- 'ctrl-n' to select next item
				['<C-n>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
					else
						cmp.complete()
					end
				end, {'i'}),

				-- 'ctrl-p' to select prev item
				['<C-p>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
					else
						cmp.complete()
					end
				end, {'i'}),

				-- 'enter' to accept item
				['<CR>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace})
					else
						fallback()
					end
				end, {'i'}),

				-- 'ESC/ctrl-[' to abort completion
				['<C-[>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if cmp.get_selected_entry() then
							cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace})
							vim.api.nvim_feedkeys(termcodes("<Esc>"), 'n', false)
						else
							cmp.abort()
							vim.api.nvim_feedkeys(termcodes("<Esc>"), 'n', false)
						end
					else
						fallback()
					end
				end, {'i'})
			},

			sources = sources() or {},

			-- :h cmp-config.formatting.format
			formatting = {
				format = function(entry, vim_item)
					local source = sources[entry.source.name]
					if source and source.format then
						return source.format(vim_item)
					end
					return vim_item
				end
			}

		})
	end
}
