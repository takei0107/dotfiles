local function resolve_deps()
	local deps = {"L3MON4D3/LuaSnip"}
	local sources = require("cmp.nvim-cmp-sources")
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
	event = "InsertEnter",
	dependencies = resolve_deps(),
	config = function()
		local cmp = require("cmp")
		local types = require("cmp.types")
		cmp.setup({
			enabled = true,
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end
			},
			mapping = {
				['<C-n>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
					else
						cmp.complete()
					end
				end, {'i'}),
				['<C-p>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
					else
						cmp.complete()
					end
				end, {'i'}),
				['<CR>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace})
					else
						fallback()
					end
				end, {'i'}),
				['<C-[>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if cmp.get_selected_entry() then
							cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace})
						else
							cmp.abort()
						end
					else
						fallback()
					end
				end, {'i'})
			},
			sources = require("cmp.nvim-cmp-sources")(),
			formatting = {
				format = function(entry, vim_item)
					if entry.source.name == "buffer" then
						vim_item.kind = "buffer"
					end
					return vim_item
				end
			}
		})
	end
}
