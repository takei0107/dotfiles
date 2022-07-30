local cmd = vim.cmd
local fn = vim.fn
local opt = vim.opt

vim.g.loaded_tutor_mode_plugin = true
vim.g.loaded_2html_plugin = true
vim.g.mapleader = " "

opt.encoding = 'utf-8'
opt.fileencodings={'ucs-boom', 'utf-8', 'cp932', 'default'}

cmd [[filetype off]]
cmd [[filetype plugin indent off]]

function ReloadRCFile()
	local vimrc = vim.env.MYVIMRC
	if vimrc == nil then
		return "env $MYVIMRC is nil"
	end
	local arg = string.format(':luafile %s', vimrc)
	local success, errMsg = pcall(vim.cmd, arg)
	if not success then
		return string.format("error %s", errMsg)
	end
	return nil
end

function OpenVimrc()
	local vimrc = vim.env.MYVIMRC
	if vimrc == nil then 
		print "env $MYVIMRC is nil"
		return
	end
	vim.cmd(string.format("edit %s", vimrc))
end

function ToHex(num)
	return string.format("%x", num)
end

function GetHl(name)
	return vim.api.nvim_get_hl_by_name(name, true)
end

-- TODO
--function Trim()
--	local curLine = vim.fn.getline('.')
--	local len = string.len(curLine)
--end

vim.keymap.set('n', '<F4>', function ()
		vim.cmd("tabnew | lua OpenVimrc()")
		vim.cmd("normal gg")
end)

-- install packer.nvim
local packer_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path})
end

-- packer
cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
	-- recompile packer
	local function packerRecompile()
		local errMsg = ReloadRCFile()
		if not (errMsg == nil) then
			print('fail: packer recompile. error = ' .. errMsg)
			return
		end
		local success, errMsg = pcall(require('packer').compile)
		if not success then
			print('fail: packer recompile. error = ' .. errMsg)
			return
		end
		print('success: packer recompile.')
	end
	vim.api.nvim_create_user_command('PackerRecompile', function() packerRecompile() end, {} )

	-- packer self
	use {'wbthomason/packer.nvim', opt = true}

	-- libraries
	use 'nvim-lua/plenary.nvim'
	use 'kyazdani42/nvim-web-devicons'
	use 'vim-jp/vimdoc-ja'

	-- color theme
	use {
		'EdenEast/nightfox.nvim',
		config = function()
			require('nightfox').setup({
				options = {
					dim_inactive = true,
					terminal_colors = true,
					modules = {
						neotree = true,
					},
				}
			})
			vim.cmd [[colorscheme nordfox]]
		end,
	}

	-- syntax
	use {
		'nvim-treesitter/nvim-treesitter',
		run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
		config = function()
			require('nvim-treesitter.configs').setup({
				auto_install = true,
				ignore_install = {
					"help"
				},
				highlight = {
					enable = true,
					disable = {
						"help"
					},
				},
			})
		end
	}

	-- file explorer
	use {
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			-- remove duplicated command
			vim.cmd[[ let g:neo_tree_remove_legacy_commands = 1 ]]

			local keymap = vim.keymap
			local bufopts = { noremap = true, silent = true }
			keymap.set('n', '<leader>nt', function()
				vim.cmd [[ Neotree reveal toggle left ]]
			end, bufopts)

			require('neo-tree').setup({
				close_if_last_window = true,
				enable_git_status = true,
				enable_diagnostics = true,
				window = {
					position = 'left',
					width = 30,
					mappings = {
						['s'] = "open_split",
						['v'] = "open_vsplit"
					}
				},
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
					},
					follow_current_file = true,
				}
			})
		end
	}

	-- statusline
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons' },
		after = 'nightfox.nvim',
		config = function()
			require('lualine').setup({
				options = {
					icons_enabled = true,
					theme = 'nord',
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {
						'filename',
						{
							'diagnostics',
							sources = {'nvim_lsp'},
							diagnostics_color = {
								error = {
									fg = "#".. ToHex(GetHl('DiagnosticError').foreground),
									bg = require("lualine.themes.nord").normal.b.bg
								},
								warn = {
									fg = "#".. ToHex(GetHl('DiagnosticWarn').foreground),
									bg = require("lualine.themes.nord").normal.b.bg
								},
								info = {
									fg = "#".. ToHex(GetHl('DiagnosticInfo').foreground),
									bg = require("lualine.themes.nord").normal.b.bg
								},
								hint = {
									fg = "#".. ToHex(GetHl('DiagnosticHint').foreground),
									bg = require("lualine.themes.nord").normal.b.bg
								},
							},
							symbols = {error = '🚨', warn = '⚠', info = '🔔', hint = '🤔'},
							colored = true,
							update_in_insert = false,
							always_visible = false,
						}
					},
					lualine_c = {'branch', 'diff'},
					lualine_x = {'filetype'},
					lualine_y = {'fileformat', 'encoding'},
					lualine_z = {'location', 'progress'},
				},
			})
		end
	}

	-- tabline
	use {
		"nanozuki/tabby.nvim",
		after = {'nightfox.nvim', 'nvim-web-devicons'},
		config = function ()
			local text = require('tabby.text')
			local hl_head = {
				fg = '#019833',
				bg = "#" .. ToHex(GetHl("TabLine").background)
			}
			local head =  {
				{ '  ', hl = hl_head },
				text.separator('', "TabLine", 'TabLineFill'),
			}
			local tab_only = require("tabby.presets").tab_only
			tab_only.head = head

			require("tabby").setup({
				tabline = tab_only
			})
		end
	}

	-- fuzzy finder
	use {
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		requires = {'nvim-lua/plenary.nvim'},
		config = function()
			local keymap = vim.keymap
			local opts = { noremap = true, silent = true }
			local builtin = require('telescope.builtin')
			keymap.set('n', '<leader>ff', builtin.find_files, opts)
			keymap.set('n', '<leader>gf', builtin.git_files, opts)
			keymap.set('n', '<leader>fb', function()
				builtin.buffers({
					only_cwd = true,
					ignore_current_buffer = true,
				})
			end, opts)
			keymap.set('n', '<leader>fh', builtin.help_tags, opts)
			keymap.set('n', '<leader>rg', builtin.live_grep, opts)
			local actions = require('telescope.actions')
			require('telescope').setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
					},
					mappings = {
						i = {
							['<C-j>'] = actions.move_selection_next,
							['<C-k>'] = actions.move_selection_previous,
							['<C-b>'] = actions.preview_scrolling_up,
							['<C-f>'] = actions.preview_scrolling_down,
							['<C-u>'] = {"<C-u>", type = "command"},
						},
						n = {
							['<Esc>'] = { -- デフォルトのactions.closeだと閉じるのが遅いのでnowaitにする
								"<cmd>q!<cr>",
								type = "command",
								opts = { nowait = true, silent = true }
							},
						}
					}
				},
			})
		end
	}

	-- completion
	use {
		'hrsh7th/nvim-cmp',
	}
	use {
		'hrsh7th/cmp-nvim-lsp'
	}
	use {
		'hrsh7th/cmp-vsnip'
	}
	use {
		'hrsh7th/vim-vsnip'
	}

	-- lsp
	use {
		'neovim/nvim-lspconfig',
	}
	use {
		'williamboman/mason.nvim', -- alternative nvim-lsp-installer
	}
	use {
		'williamboman/mason-lspconfig.nvim',
	}
	use {
		'hrsh7th/cmp-nvim-lsp-signature-help'
	}

	local cmp = require('cmp')
	cmp.setup({
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
			{ name = 'nvim_lsp_signature_help' }
		}),
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		mapping = {
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
		},
		preselect = cmp.PreselectMode.None,
		completion = {},
	})
	local on_attach = function(client, bufnr)
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		local keymap = vim.keymap
		local lsp_buf = vim.lsp.buf
		keymap.set('n', 'gd', lsp_buf.definition, bufopts)
		keymap.set('n', 'gi', lsp_buf.implementation, bufopts)
		keymap.set('n', 'gr', lsp_buf.references, bufopts)
		keymap.set('n', '<leader>rn', lsp_buf.rename, bufopts)
		keymap.set('n', 'K', lsp_buf.hover, bufopts)
	end
	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	require('mason').setup()
	require('mason-lspconfig').setup()
	require('mason-lspconfig').setup_handlers({
		function (server_name)
			require('lspconfig')[server_name].setup{
				on_attach = on_attach,
				capabilities = capabilities
			} end
	})

	-- git
	use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
	use {
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup({
				on_attach = function (bufnr)
					local gs = require('gitsigns')
					local opts = { noremap = true, silent = true }
					vim.keymap.set('n', ']c', function ()
						vim.schedule(function ()
							gs.next_hunk()
						end)
					end, opts)
					vim.keymap.set('n', '[c', function ()
						vim.schedule(function ()
							gs.prev_hunk()
						end)
					end, opts)
				end
			})
		end
	}
	-- lexima
	use 'cohama/lexima.vim'

	-- vim-sandwitch
	use 'machakann/vim-sandwich'

	-- sync packer when packer.nvim installed.
	if packer_bootstrap then
		require('packer').sync()
	end
end)

opt.hidden = true
opt.helplang = 'ja'
opt.smartindent = true
opt.shiftwidth = 0
opt.softtabstop = -1
opt.number = true
opt.belloff = 'all'
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.laststatus = 2
opt.wildmenu = true
opt.showcmd = true
opt.display = 'truncate'
opt.backspace = {'indent', 'eol', 'start'}
opt.list = true
opt.updatetime = 555
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.backup = false
opt.completeopt = {'menu', 'menuone', 'noselect'}
local undoDir = fn.stdpath('cache') .. '/undo'
if not(fn.isdirectory(undoDir)) then
	fn.mkdir(undoDir)
end
opt.undodir = undoDir
opt.undofile = true
if fn.has('unix') then
	opt.clipboard:prepend{'unnamedplus', 'unnamed'}
elseif fn.has('mac') then
	opt.clipboard:append{'unnamde'}
end
if fn.has('termguicolors') then
	opt.termguicolors = true
end

vim.keymap.set('n', '<ESC><ESC>', function() cmd('nohlsearch') end, {silent = true})
vim.keymap.set('n', '<F5>', function ()
	ReloadRCFile()
end, {silent = true})

vim.cmd [[
augroup filetype
	autocmd!
	autocmd FileType java setlocal expandtab shiftwidth=4
	autocmd FileType jsp setlocal expandtab shiftwidth=2
	autocmd FileType go setlocal tabstop=4
	autocmd FileType vim setlocal tabstop=2
	autocmd FileType lua setlocal tabstop=2
	autocmd FileType sh,zsh setlocal tabstop=2
	autocmd FileType toml setlocal tabstop=2
	autocmd FileType diff setlocal tabstop=2
augroup END
]]

-- go organizeImports & format
-- see https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
function OrgImports(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = {only = {"source.organizeImports"}}
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
	vim.lsp.buf.formatting()
end
vim.cmd [[autocmd BufWritePre *.go lua OrgImports(1000)]]

cmd[[filetype plugin indent on]]
