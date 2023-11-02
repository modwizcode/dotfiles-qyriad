scriptencoding utf-8

lua << EOF
-- Bootstrap lazy.nvim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

plugin_spec = {}
post_plugin_callbacks = {}
function use(spec)
	table.insert(plugin_spec, spec)
end
function post_plugins(fn)
	table.insert(post_plugin_callbacks, fn)
end
EOF

runtime ftplugin/man.vim

let $CONFIGPATH = stdpath('config')

source $CONFIGPATH/core.vim
source $CONFIGPATH/utils.vim
source $CONFIGPATH/syntax.vim
source $CONFIGPATH/highlight.vim
source $CONFIGPATH/lsp.vim
source $CONFIGPATH/statusline.vim


""" Other mappings.

" Copy to tmux.
vnoremap <leader>y :Tyank<CR>

" Easy-Align
xmap ga <Plug>(EasyAlign)

" Capitalize the last inserted text
function! Capitalize_and_return()
	normal `[v`]gU`]
	silent s/-/_/
	normal ``a
endfunction

" Usable from <C-o>
nnoremap <leader>c :normal `[v`]gU`]a<CR>
" Usable from insert mode, and replaces - with _
inoremap <F3> <C-o>:call Capitalize_and_return()<CR>

let g:ranger_map_keys = 0
nnoremap <leader>f :RangerCurrentDirectory<CR>


nnoremap ]g <Cmd>lua gitsigns.next_hunk({ preview = true })<CR>
nnoremap [g <Cmd>lua gitsigns.prev_hunk({ preview = true })<CR>
nnoremap gs <Cmd>lua gitsigns.preview_hunk()<CR>


function CopyOnWrite() abort
	augroup CopyFile
		" Yank the entire file into "+
		autocmd! BufWritePost <buffer> silent %yank +
	augroup END
endfunction

command! CopyOnWrite call CopyOnWrite()

lua << EOF
-- Text editing.
use 'tmhedberg/SimpylFold' -- Python folds.
use 'junegunn/vim-easy-align'

-- Utilities.
use 'tpope/vim-eunuch'
use 'rbgrouleff/bclose.vim' -- Dependency for ranger.vim
use {
	'francoiscabrol/ranger.vim',
	dependencies = { 'rbgrouleff/bclose.vim' },
}
use 'tpope/vim-tbone' -- :Tyank and :Tput
use {
	'lewis6991/gitsigns.nvim',
	config = function()
		gitsigns = require("gitsigns")
		gitsigns.setup {
			-- Don't fill the signcolumn for untracked files.
			attach_to_untracked = false,
		}
	end,
}
use {
	'akinsho/git-conflict.nvim',
	opts = {},
}
use 'tpope/vim-characterize' -- ga
use 'tpope/vim-abolish'
use 'gennaro-tedesco/nvim-peekup'
use 'AndrewRadev/bufferize.vim'
use {
	'windwp/nvim-projectconfig',
	opts = { },
}

-- Pickers
use 'ctrlpvim/ctrlp.vim'
use 'nvim-lua/plenary.nvim' -- Dependency for telescope.
use {
	'nvim-telescope/telescope.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		telescope = require("telescope")
		telescope.setup {}
		telescope.builtin = require("telescope.builtin")
		telescope.load_extension("ui-select")

		local mappings = {
			{ "<leader>tg", telescope.builtin.git_files },
			{ "<leader>tb", telescope.builtin.buffers },
			{ "<leader>tm", telescope.builtin.marks }, -- Let's see if we use this one.
			{ "<leader>tt", telescope.builtin.tags },
		}

		for _i, mapspec in ipairs(mappings) do
			local lhs = mapspec[1]
			local func = mapspec[2]
			vim.keymap.set("n", lhs, func, { noremap = true })
		end
	end,
}
use {
	-- Use telescope as the picker for things like vim.lsp.buf.code_action()
	"nvim-telescope/telescope-ui-select.nvim",
}

-- Display.
use 'dhruvasagar/vim-zoom' -- <C-w>m

-- We don't really like the icons but we're getting tired of plugin stuff just showing question marks
-- and we don't want to worry about overriding it all right now.
use {
	'nvim-tree/nvim-web-devicons',
	opts = {},
}

--use 'Konfekt/vim-alias'
--use 'thinca/vim-ft-vim_fold'

-- For our convenience, let's create a table that'll have all the main lua modules
-- for each of our plugins, with a normalized key name.
p = {}

vim.api.nvim_create_autocmd("User", {
	pattern = "LazyLoad",
	callback = function(autocmd_event)
		lazy_import_plugin(autocmd_event.data)
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "LazyDone",
	callback = function(autocmd_event)
		for i, lazy_plugin in ipairs(lazy.plugins()) do
			lazy_import_plugin(lazy_plugin.name, lazy_plugin)
		end
	end,
})

lazy = require('lazy')
-- These submodules aren't used here, but are used in the above autocommands,
-- and are also handy for convenience.
lazy.core = {
	config = require("lazy.core.config"),
	util = require("lazy.core.util"),
	loader = require("lazy.core.loader"),
}

lazy.setup(plugin_spec, {
	install = {
		missing = true, -- Default
		colorscheme = { "solorized8_grey" },
	},
})

EOF

" vim:textwidth=0
