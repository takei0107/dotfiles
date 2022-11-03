return function()
	local theme = 'nord'

	local function winbar_enable()
		return not (package.loaded['nvim-navic'])
	end

	local function navic_location()
		local navic = require('nvim-navic')
		local none_display = "🙈🙊🙉"
		if navic.is_available() then
			local location = navic.get_location()
			return (location ~= "") and location or none_display
		else
			return none_display
		end
	end

	local settings = {
		options = {
			icons_enabled = true,
			theme = theme,
		},
		sections = {
			lualine_a = { 'mode' },
			lualine_b = {
				'filename',
				require 'plugins.lualine.diagnostics' (theme, 'b')
			},
			lualine_c = { 'branch', 'diff' },
			lualine_x = { 'filetype' },
			lualine_y = { 'fileformat', 'encoding' },
			lualine_z = { 'location', 'progress' },
		},
	}
	if winbar_enable() then
		settings.winbar = {
			lualine_a = {
				{ navic_location }
			},
		}
	end

	require('lualine').setup(settings)
end
