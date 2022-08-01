local vimlib = require('lib.vim')
local base_theme = 'nord'

local setting_diagnostics = {
	sources = {'nvim_lsp'},
	diagnostics_color = {
		error = {
			fg = vimlib.get_hl_by_name('DiagnosticError').fg,
			bg = require('lualine.themes.'..base_theme).normal.b.bg
		},
		warn = {
			fg = vimlib.get_hl_by_name('DiagnosticWarn').fg,
			bg = require('lualine.themes.'..base_theme).normal.b.bg
		},
		info = {
			fg = vimlib.get_hl_by_name('DiagnosticInfo').fg,
			bg = require('lualine.themes.'..base_theme).normal.b.bg
		},
		hint = {
			fg = vimlib.get_hl_by_name('DiagnosticHint').fg,
			bg = require('lualine.themes.'..base_theme).normal.b.bg
		},
	},
	symbols = {error = '🚨', warn = '⚠', info = '🔔', hint = '🤔'},
	colored = true,
	update_in_insert = false,
	always_visible = false,
}

require('lualine').setup({
	options = {
		icons_enabled = true,
		theme = base_theme,
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {
			'filename',
			{
				'diagnostics',
				sources = setting_diagnostics.sources,
				diagnostics_color = setting_diagnostics.diagnostics_color,
				symbols = setting_diagnostics.symbols,
				colored = setting_diagnostics.colored,
				update_in_insert = setting_diagnostics.update_in_insert,
				always_visible = setting_diagnostics.always_visible,
			}
		},
		lualine_c = {'branch', 'diff'},
		lualine_x = {'filetype'},
		lualine_y = {'fileformat', 'encoding'},
		lualine_z = {'location', 'progress'},
	},
})
