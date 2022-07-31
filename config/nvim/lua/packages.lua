local cmd = vim.cmd
local fn = vim.fn

-- install packer.nvim
local packer_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path})
end

cmd('packadd packer.nvim')

-- packer startup
require('packer').startup({function(use)

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
			vim.cmd('colorscheme nordfox')
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
		'nvim-neo-tree/neo-tree.nvim',
		branch = "v2.x",
		requires = {
			'nvim-lua/plenary.nvim',
			'kyazdani42/nvim-web-devicons',
			'MunifTanjim/nui.nvim',
		},
		config = function ()
			require('plugins.neotree')
		end
	}

	-- statusline
	use {
		'nvim-lualine/lualine.nvim',
		requires = {
			'EdenEast/nightfox.nvim',
			'kyazdani42/nvim-web-devicons'
		},
		after = 'nightfox.nvim',
		config = function ()
			require('plugins.lualine')
		end
	}

	-- tabline
	use {
		'nanozuki/tabby.nvim',
		requires = {
			'EdenEast/nightfox.nvim',
			'kyazdani42/nvim-web-devicons'
		},
		after = {'nightfox.nvim', 'nvim-web-devicons'},
		config = function ()
			require('plugins.tabby')
		end
	}

	-- fuzzy finder
	use {
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		requires = {'nvim-lua/plenary.nvim'},
		config = function ()
			require('plugins.telescope')
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
	use {
		'hrsh7th/cmp-nvim-lsp-signature-help'
	}
	require('editor.cmp')

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
	require('lsp.nvim-lsp')


	-- git
	use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
	use {
		'lewis6991/gitsigns.nvim',
		config = function()
			require('plugins.gitsigns')
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
end,

-- packer configurations
config = {
	display = {
		open_fn = require('packer.util').float,
	}
}})

-- recompile packer
local function packerRecompile()
	require('vimrc'):load()
	require('packer').compile()
end
vim.api.nvim_create_user_command('PackerRecompile', function() packerRecompile() end, {} )
