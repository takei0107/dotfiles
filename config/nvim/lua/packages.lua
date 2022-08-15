local cmd = vim.cmd
local fn = vim.fn

-- install packer.nvim
local packer_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
	packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path })
end

cmd('packadd packer.nvim')

-- packer startup
require('packer').startup({ function(use)

	-- packer self
	use { 'wbthomason/packer.nvim', opt = true }

	-- libraries
	use 'nvim-lua/plenary.nvim'
	use 'kyazdani42/nvim-web-devicons'

	-- 日本語help
	use {
		'vim-jp/vimdoc-ja',
	}

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
		config = function()
			require('plugins.neotree')
		end,
		keys = '<leader>nt',
	}

	-- statusline
	use {
		'nvim-lualine/lualine.nvim',
		requires = {
			'EdenEast/nightfox.nvim',
			'kyazdani42/nvim-web-devicons',
			"SmiteshP/nvim-navic"
		},
		after = { 'nightfox.nvim', 'nvim-navic' },
		config = function()
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
		after = { 'nightfox.nvim', 'nvim-web-devicons' },
		config = function()
			require('plugins.tabby')
		end
	}

	-- [[ navigation ]]
	use {
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
	}

	-- fuzzy finder
	use {
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		requires = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('plugins.telescope')
		end,
	}

	-- completion
	use {
		'hrsh7th/nvim-cmp',
		config = function()
			require('editor.cmp')
		end,
	}
	use {
		'hrsh7th/cmp-nvim-lsp',
		after = 'nvim-cmp'
	}
	use {
		'hrsh7th/cmp-vsnip',
		after = 'nvim-cmp'
	}
	use {
		'hrsh7th/vim-vsnip',
		after = 'nvim-cmp'
	}
	use {
		'hrsh7th/cmp-nvim-lsp-signature-help',
		after = 'nvim-cmp'
	}
	use {
		'hrsh7th/cmp-path',
		after = 'nvim-cmp'
	}
	use {
		'hrsh7th/cmp-buffer',
		after = 'nvim-cmp'
	}
	use {
		'uga-rosa/cmp-dictionary',
		after = 'nvim-cmp',
		configure = function()
			local dic = {}
			local dict_en = vim.fn.stdpath('data') .. '/dicts/en.dict'
			if vim.fn.filereadable(dict_en) then
				dic.spelllang = {
					en = dict_en
				}
			end
			require('cmp_dictionary').setup({
				dic = dic
			})
		end

	}
	use {
		'hrsh7th/cmp-cmdline',
		requires = 'hrsh7th/nvim-cmp',
		event = 'CmdlineEnter *'
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
		after = { 'nvim-lspconfig', 'mason.nvim', "nvim-navic", 'cmp-nvim-lsp' },
		config = function()
			require('lsp.nvim-lsp')
		end
	}

	-- java lsp
	use {
		'mfussenegger/nvim-jdtls',
		-- javaの時だけ読み込みたいが、ftplugin内でrequireするとこのプラグインがロードされておらず失敗するため
		--ft = {'java'}
	}

	-- git
	use {
		'TimUntersberger/neogit',
		requires = 'nvim-lua/plenary.nvim',
		cmd = "Neogit",
	}
	use {
		'lewis6991/gitsigns.nvim',
		config = function()
			require('plugins.gitsigns')
		end
	}

	-- lexima
	use {
		'cohama/lexima.vim',
		event = 'InsertEnter *'
	}

	-- vim-sandwitch
	use 'machakann/vim-sandwich'

	-- matchup
	use {
		'andymass/vim-matchup',
		event = 'CursorMoved <buffer>'
	}

	-- hop
	use {
		'phaazon/hop.nvim',
		branch = 'v2',
		config = function()
			-- see https://github.com/phaazon/hop.nvim#using-packer
			require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
		end
	}

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
	} })

-- recompile packer
local function packerRecompile()
	require('vimrc'):load()
	require('packer').compile()
end

vim.api.nvim_create_user_command('PackerRecompile', function() packerRecompile() end, {})