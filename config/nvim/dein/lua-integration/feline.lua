local bg = '#DBDBDB'
local fg = '#233F5E'
local vi_modes = {
	n = "NORMAL",
	no = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	[""] = "V-BLOCK",
	c = "COMMAND",
	cv = "COMMAND",
	ce = "COMMAND",
	R = "REPLACE",
	Rv = "REPLACE",
	s = "SELECT",
	S = "SELECT",
	[""] = "SELECT",
	t = "TERMINAL",
}
local vi_modes_hl = {
	n = { fg = fg, bg = 'green' },
	no = { fg = fg, bg = 'green' },
	i = { fg = bg, bg = 'red' },
	v = { fg = fg, bg = 'orange' },
	V = { fg = fg, bg = 'orange' },
	[""] = { fg = fg, bg = 'orange' },
	c = { fg = bg, bg = 'oceanblue' },
	cv = { fg = bg, bg = 'oceanblue' },
	ce = { fg = bg, bg = 'oceanblue' },
	R = { fg = bg, bg = 'red' },
	Rv = { fg = bg, bg = 'red' },
	s = { fg = fg, bg = 'skyblue' },
	S = { fg = fg, bg = 'skyblue' },
	[""] = { fg = fg, bg = 'skyblue' },
	t = { fg = fg, bg = 'green' },
}
local c_dummy = {
	provider = ''
}
local c_vi_mode = {
	provider = function()
		return string.format(" %s ", vi_modes[vim.fn.mode()])
	end,
	hl = function()
		return {
			fg = vi_modes_hl[vim.fn.mode()]['fg'],
			bg = vi_modes_hl[vim.fn.mode()]['bg'],
			style = 'bold'
		}
	end,
	right_sep = {
		{
			str = 'right_filled',
			hl = function()
				return {
					fg = vi_modes_hl[vim.fn.mode()]['bg'],
				}
			end
		},
	}
}
local c_dir_name = {
	provider = function()
		return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
	end,
	left_sep = {
		str = ' ',
	},
	right_sep = {
		{ str = ' ', },
		{
			str = 'slant_right_2',
			hl = {
				fg = bg,
				bg = fg
			}
		}
	}
}
local c_file_info = {
	provider = {
		name = 'file_info',
		opts = {
			type = 'relative-short'
		},
	},
	hl = {
		fg = bg,
		bg = fg,
		style = 'bold'
	},
	left_sep = {
		{
			str = ' ',
			hl = {
				bg = fg,
			},
		}
	},
	right_sep = {
		{
			str = ' ',
			hl = {
				bg = fg,
			},
		},
		{
			str = 'slant_right_2',
		}
	},
	icon = '',
}
local c_git_branch = {
	provider = 'git_branch',
	hl = {
		style = 'bold',
	},
	left_sep = {
		str = ' ',
	},
}
local c_git_diff_added = {
	provider = 'git_diff_added',
	hl = {
		style = 'bold',
		fg = 'skyblue',
	},
}
local c_git_diff_changed = {
	provider = 'git_diff_changed',
	hl = {
		style = 'bold',
		fg = '#FFFB66',
	},
}
local c_git_diff_removed = {
	provider = 'git_diff_removed',
	hl = {
		style = 'bold',
		fg = 'red',
	},
}
local c_diagnostic_errors = {
	provider = 'diagnostic_errors',
	hl = {
		fg = 'red',
	}
}
local c_diagnostic_warnings = {
	provider = 'diagnostic_warnings',
	hl = {
		fg = 'orange',
	}
}
local c_file_type = {
	provider = {
		name = 'file_type',
		opts = {
			case = 'lowercase',
			filetype_icon = true
		},
	},
	hl = {
		style = 'bold',
		fg = bg,
		bg = fg,
	},
	left_sep = {
		{
			str = 'slant_left_2',
		},
		{
			str = ' ',
			hl = {
				bg = fg
			}
		}
	},
	right_sep = {
		{
			str = ' ',
			hl = {
				bg = fg
			}
		},
		{
			str = 'slant_right',
		}
	}
}
local c_file_format = {
	provider = 'file_format',
	hl = {
		style = 'bold',
	},
	left_sep = {
		str = ' '
	}
}
local c_file_encoding = {
	provider = 'file_encoding',
	hl = {
		style = 'bold',
	},
	left_sep = {
		str = ' ',
	}
}
local c_position = {
	provider = 'position',
	left_sep = {
		str = ' ',
	}
}
local c_line_percentage = {
	provider = 'line_percentage',
	left_sep = {
		str = ' ',
	},
	right_sep = {
		str = ' ',
	}
}
local left_components = { c_vi_mode, c_dir_name, c_file_info, c_git_branch, c_git_diff_added, c_git_diff_changed,
	c_git_diff_removed, c_dummy }
local middle_components = { c_diagnostic_errors, c_diagnostic_warnings }
local right_components = { c_file_type, c_file_format, c_file_encoding, c_position, c_line_percentage }
local components = {
	active = {},
	inactive = {}
}
table.insert(components.active, left_components)
table.insert(components.active, middle_components)
table.insert(components.active, right_components)
require('feline').setup({
	components = components,
	theme = { bg = bg, fg = fg },
	force_inactive = {
		filetypes = {
			'^fern$',
		}
	}
})
