--███╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗
--████╗  ██║██╔════╝██║   ██║██║████╗ ████║
--██╔██╗ ██║█████╗  ██║   ██║██║██╔████╔██║
--██║╚██╗██║██╔══╝  ██║   ██║██║██║╚██╔╝██║
--██║ ╚████║███████╗╚██████╔╝██║██║ ╚═╝ ██║
--╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝╚═╝     ╚═╝

local opt = vim.opt
local g = vim.g
local keymap = vim.keymap.set

vim.cmd([[
	call plug#begin('~/.local/share/nvim/plugged')
	Plug 'Mofiqul/dracula.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
	call plug#end()
]])

vim.cmd[[colorscheme dracula]]

-- ============================================================================{{{
-- CONFIGURAÇÕES DE INTERFACE E OPÇÕES GERAIS DO SISTEMA
-- ============================================================================
opt.termguicolors = true
opt.title = true
opt.encoding = "utf-8"
opt.backspace = { "indent", "eol", "start" }
opt.errorbells = false
opt.confirm = true
opt.hidden = true
opt.splitbelow = true
opt.splitright = true
opt.fillchars = { vert = "│", fold = "-", eob = "~", lastline = "@" }
opt.clipboard = "unnamedplus"

opt.path:append({ ".", "**" })
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true

opt.wrap = false
opt.linebreak = true
opt.list = false
opt.listchars = { tab = "›-", space = "·", trail = "◀", eol = "↲" }

opt.number = true
opt.relativenumber = true
opt.scrolloff = 2
opt.cursorline = true

opt.autoindent = true
opt.smartindent = true

opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.wildmenu = true
opt.wildmode = { "longest", "full" }
opt.wildoptions = "pum"

opt.spelllang = { "pt_br", "en" }
opt.spell = false
opt.complete:append("kspell")
opt.completeopt = { "menuone", "longest" }
opt.shortmess:append("c")
opt.showmode = false
opt.laststatus = 2
opt.autoread = true
opt.updatetime = 200

vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])


opt.viminfo = "'50,<1000,s10,h,n~/.config/nvim/.viminfo/.viminfo"
opt.guicursor = "n-v-c:block,i-ci-ve:ver25"


-- }}}

-- {{{
local auto_save = vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = auto_save,
  pattern = "*",
  command = "silent! update",
})

local filetype_vim = vim.api.nvim_create_augroup("filetype_vim", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_vim,
  pattern = { "vim", "lua" },
  callback = function()
    vim.opt_local.foldmethod = "marker"
  end,
})

local sincronizar = vim.api.nvim_create_augroup("sincronizar", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "CursorHold", "CursorHoldI" }, {
  group = sincronizar,
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*",
  callback = function()
    local ext = vim.fn.expand("%:e")
    local skel_path = vim.fn.expand("~/.config/nvim/skel/skel." .. ext)
    if vim.fn.filereadable(skel_path) == 1 then
      vim.cmd("silent! 0r " .. skel_path)
    end
  end,
})

-- }}}

-- ============================================================================{{{
-- MAPEAMENTOS DE TECLAS (KEYMAPS)
-- ============================================================================
keymap("n", "<C-t>", ":tabn<CR>", { silent = true })
keymap("n", "<C-b>", ":bn<CR>", { silent = true })

keymap("n", "<Up>", "<Nop>")
keymap("n", "<Down>", "<Nop>")
keymap("n", "<Left>", "<Nop>")
keymap("n", "<Right>", "<Nop>")
keymap("n", "&", ":s/^/\\/\\//g<CR>", { silent = true })-- }}}

-- ============================================================================{{{
-- TELESCOPE NEOVIM
-- ============================================================================

require('telescope').setup({
    prompt_prefix = "🔍"
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>', builtin.find_files, { desc = 'Telescope buscar arquivos' })
vim.keymap.set('n', '<C-t>', builtin.live_grep, { desc = 'Telescope buscar texto' })
vim.keymap.set('n', '<C-b>', builtin.buffers, { desc = 'Telescope listar buffers' })
vim.keymap.set('n', '<C-h>', builtin.help_tags, { desc = 'Telescope ajuda' })-- }}}

-- ============================================================================{{{
-- TREE NEOVIM
-- ============================================================================


require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    icons = {
      show = {
        git = true, -- Exibe os ícones de status do Git
      },
      glyphs = {
        git = {
          unstaged  = "✗",
          staged    = "✓",
          unmerged  = "═",
          renamed   = "➜",
          untracked = "★",
          deleted   = "✖",
          ignored   = "☒",
        },
      },
    },
  },
  filters = {
    dotfiles = false, -- Exibe arquivos ocultos (ex: .gitignore, .env)
  },
  git = {
    enable = true,
    ignore = false,  -- Exibe arquivos ignorados pelo git
    timeout = 400,  -- Tempo limite em ms para checar o status do repositório
  },
})

vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>", { silent = true })
--}}}

-- ============================================================================{{{
-- COC NEOVIM
-- ============================================================================
keymap("i", "<Tab>", 'coc#pum#visible() ? coc#pum#next(1) : "\\<Tab>"', { expr = true, silent = true })
keymap("i", "<S-Tab>", 'coc#pum#visible() ? coc#pum#prev(1) : "\\<Tab>"', { expr = true, silent = true })

keymap("i", "<CR>", 'coc#pum#visible() ? coc#pum#confirm() : "\\<C-g>u\\<CR>\\<c-r>=coc#on_enter()\\<CR>"', { expr = true, silent = true })

function _G.show_docs()
  local cw = vim.fn.expand("<cword>")
  if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
    vim.cmd("h " .. cw)
  elseif vim.api.nvim_eval("coc#rpc#ready()") then
    vim.fn.CocActionAsync("doHover")
  else
    vim.cmd("!" .. vim.o.keywordprg .. " " .. cw)
  end
end

keymap("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })
local coc_group = vim.api.nvim_create_augroup("CocGroup", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
  group = coc_group,
  pattern = "*",
  callback = function()
    vim.fn.CocActionAsync("highlight")
  end,
})
--}}}
