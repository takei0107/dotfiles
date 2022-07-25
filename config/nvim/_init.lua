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

local packer_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path})
end

cmd [[packadd packer.nvim]]
require('packer').startup(function(use)
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
					terminal_colors = false,
					modules = {
						neotree = true,
					},
				}
			})
			vim.cmd [[colorscheme dayfox]]
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

			require('neo-tree').setup({
				close_if_last_window = true,
				enable_git_status = true,
				window = {
					position = 'left',
					width = 30,
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
		config = function()
			require('lualine').setup({
				options = {
					icons_enabled = true,
					theme = 'nord',
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {'filename'},
					lualine_c = {'branch', 'diff'},
					lualine_x = {'filetype'},
					lualine_y = {'fileformat', 'encoding'},
					lualine_z = {'location', 'progress'},
				},
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
			local bufopts = { noremap = true, silent = true }
			local builtin = require('telescope.builtin')
			keymap.set('n', 'ff', builtin.find_files, bufopts)
			keymap.set('n', 'fb', builtin.buffers, bufopts)
			keymap.set('n', 'rg', builtin.live_grep, bufopts)
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

	local cmp = require('cmp') cmp.setup({
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

cmd[[filetype plugin indent on]]
