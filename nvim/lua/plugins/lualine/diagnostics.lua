return function(lualine_theme, lualine_sectinon)
	local vimlib = require('lib.vim')
	local diagnostics = require('diagnostics')

	local function convert_hl_to_diagnostics_color(hl_name)
		return vimlib.get_hl_by_name(hl_name)
	end

	local function get_lualine_theme_hl_nomal(theme, section)
		return require('lualine.themes.' .. theme).normal[section]
	end

	local function error_diagnostics_settings(theme, section)
		local hg = convert_hl_to_diagnostics_color('DiagnosticError')
		return {
			color = {
				fg = hg.fg or "",
				bg = get_lualine_theme_hl_nomal(theme, section).bg or "",
			},
			symbol = diagnostics.Error.symbol
		}
	end

	local function warn_diagnostics_settings(theme, section)
		local hg = convert_hl_to_diagnostics_color('DiagnosticWarn')
		return {
			color = {
				fg = hg.fg or "",
				bg = get_lualine_theme_hl_nomal(theme, section).bg or "",
			},
			symbol = diagnostics.Warn.symbol
		}
	end

	local function info_diagnostics_settings(theme, section)
		local hg = convert_hl_to_diagnostics_color('DiagnosticInfo')
		return {
			color = {
				fg = hg.fg or "",
				bg = get_lualine_theme_hl_nomal(theme, section).bg or "",
			},
			symbol = diagnostics.Info.symbol
		}
	end

	local function hint_diagnostics_settings(theme, section)
		local hg = convert_hl_to_diagnostics_color('DiagnosticHint')
		return {
			color = {
				fg = hg.fg or "",
				bg = get_lualine_theme_hl_nomal(theme, section).bg or "",
			},
			symbol = diagnostics.Hint.symbol
		}
	end

	local diagnostics_settings_by_level = {
		error = error_diagnostics_settings(lualine_theme, lualine_sectinon),
		warn = warn_diagnostics_settings(lualine_theme, lualine_sectinon),
		info = info_diagnostics_settings(lualine_theme, lualine_sectinon),
		hint = hint_diagnostics_settings(lualine_theme, lualine_sectinon)
	}
	local diagnostics_color = {
		error = diagnostics_settings_by_level.error.color,
		warn = diagnostics_settings_by_level.warn.color,
		info = diagnostics_settings_by_level.info.color,
		hint = diagnostics_settings_by_level.hint.color
	}
	local diagnostics_symbols = {
		error = diagnostics_settings_by_level.error.symbol,
		warn = diagnostics_settings_by_level.warn.symbol,
		info = diagnostics_settings_by_level.info.symbol,
		hint = diagnostics_settings_by_level.hint.symbol
	}

	return {
		'diagnostics',
		sections = { 'error', 'warn', 'info', 'hint' },
		sources = { 'nvim_lsp' },
		diagnostics_color = diagnostics_color,
		symbols = diagnostics_symbols,
		colored = true,
		update_in_insert = false,
		always_visible = false,
	}
end
