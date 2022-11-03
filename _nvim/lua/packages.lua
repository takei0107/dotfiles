local cmd = vim.cmd
local fn = vim.fn

-- install packer.nvim
local ensure_packer = function()
	local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()
cmd('packadd packer.nvim')

-- packer startup
require('packer').startup({ function(use)

	-- [[ packer self ]]
	use {
		'wbthomason/packer.nvim',
		opt = true
	}

	-- [[ utils ]]
	use 'nvim-lua/plenary.nvim'
	use 'kyazdani42/nvim-web-devicons'

	-- [[ 日本語help ]]
	use {
		'vim-jp/vimdoc-ja',
	}

	-- [[ color theme ]]
	use {
		'EdenEast/nightfox.nvim',
		config = require('plugins.nightfox')
	}

	-- [[ syntax ]]
	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			require('nvim-treesitter.install').update({ with_sync = true })
		end,
		config = require('plugins.treesitter')
	}

	-- [[ file explorer ]]
	use {
		'nvim-neo-tree/neo-tree.nvim',
		branch = "v2.x",
		requires = {
			'nvim-lua/plenary.nvim',
			'kyazdani42/nvim-web-devicons',
			'MunifTanjim/nui.nvim',
		},
		config = require('plugins.neotree')
	}

	-- [[ winbar ]]
	use {
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
	}

	-- [[ statusline ]]
	use {
		'nvim-lualine/lualine.nvim',
		requires = {
			'EdenEast/nightfox.nvim',
			'kyazdani42/nvim-web-devicons',
			"SmiteshP/nvim-navic"
		},
		after = { 'nightfox.nvim', 'nvim-navic' },
		config = require('plugins.lualine')
	}

	-- [[ tabline ]]
	use {
		'nanozuki/tabby.nvim',
		requires = {
			'EdenEast/nightfox.nvim',
			'kyazdani42/nvim-web-devicons'
		},
		after = { 'nightfox.nvim', 'nvim-web-devicons' },
		config = require('plugins.tabby')
	}

	-- [[ fuzzy finder ]]
	use {
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		requires = { 'nvim-lua/plenary.nvim' },
		config = require('plugins.telescope')
	}

	-- [[ completion ]]
	use {
		'hrsh7th/nvim-cmp',
		config = function()
			require('editor.cmp')
		end,
	}
	for _, source_cfg in ipairs(
		{
			{
				source = 'hrsh7th/cmp-vsnip',
				event = 'InsertEnter *'
			},
			{
				source = 'hrsh7th/vim-vsnip',
				event = 'InsertEnter *'
			},
			{
				source = 'hrsh7th/cmp-nvim-lsp',
				event = 'InsertEnter *'
			},
			{
				source = 'hrsh7th/cmp-nvim-lsp-signature-help',
				event = 'InsertEnter *'
			},
			{
				source = 'hrsh7th/cmp-path',
				event = 'InsertEnter *'
			},
			{
				source = 'hrsh7th/cmp-buffer',
				event = 'InsertEnter *'
			},
		}
	) do
		use {
			source_cfg.source,
			event = source_cfg.event
		}
	end
	use {
		'uga-rosa/cmp-dictionary',
		event = 'InsertEnter *',
		config = function()
			local dic = {}
			local words = "/usr/share/dict/words"
			if vim.fn.filereadable(words) then
				dic["*"] = { words }
			end
			require('cmp_dictionary').setup({
				dic = dic,
			})
			require('cmp_dictionary').update()
		end
	}
	use {
		'hrsh7th/cmp-cmdline',
		event = 'CmdlineEnter *'
	}

	-- [[ lsp ]]
	use {
		'neovim/nvim-lspconfig',
	}
	use {
		'williamboman/mason.nvim', -- alternative nvim-lsp-installer
		require('mason').setup({
			ui = {
				border = 'rounded',
			},
		})
	}
	use {
		'williamboman/mason-lspconfig.nvim',
		after = { 'nvim-lspconfig', 'mason.nvim', "nvim-navic", 'cmp-nvim-lsp' },
		config = function()
			require('lsp.nvim-lsp')
		end
	}

	-- [[ java lsp ]]
	use {
		'mfussenegger/nvim-jdtls',
		-- javaの時だけ読み込みたいが、ftplugin内でrequireするとこのプラグインがロードされておらず失敗するため
		--ft = {'java'}
	}

	-- [[ git ]]
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

	-- [[ lexima ]]
	use {
		'cohama/lexima.vim',
		event = 'InsertEnter *'
	}

	-- [[ vim-sandwitch ]]
	use {
		'machakann/vim-sandwich',
		keys = { 'v', 's' },
	}

	-- [[ matchup ]]
	--use {
	--	'andymass/vim-matchup',
	--	event = 'CursorMoved <buffer>'
	--}

	-- [[ hop ]]
	use {
		'phaazon/hop.nvim',
		branch = 'v2',
		config = function()
			-- see https://github.com/phaazon/hop.nvim#using-packer
			require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
		end
	}

	-- [[ terminal ]]
	use { "akinsho/toggleterm.nvim", tag = 'v2.*', config = function()
		require("toggleterm").setup({
			open_mapping = [[<c-x>]],
			direction = 'horizontal',
			start_in_insert = true,
			close_on_exit = true,
			shade_terminals = false,
			winbar = {
				enabled = false,
			}
		})
	end }

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
	}
})

-- recompile packer
local function packerRecompile()
	require('vimrc'):load()
	require('packer').compile()
end

vim.api.nvim_create_user_command('PackerRecompile', function() packerRecompile() end, {})
