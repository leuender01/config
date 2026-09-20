--  ███╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗
--  ████╗  ██║██╔════╝██║   ██║██║████╗ ████║
--  ██╔██╗ ██║█████╗  ██║   ██║██║██╔████╔██║
--  ██║╚██╗██║██╔══╝  ██║   ██║██║██║╚██╔╝██║
--  ██║ ╚████║███████╗╚██████╔╝██║██║ ╚═╝ ██║
--  ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝╚═╝     ╚═╝

-- ============================================================================{{{ 
    -- CONFIGURAÇÕES INICIAIS DO NEOVIM
-- ============================================================================
local opt = vim.opt
local g = vim.g
local keymap = vim.keymap.set

vim.cmd([[
	call plug#begin('~/.local/share/nvim/plugged')
    Plug 'OXY2DEV/markview.nvim'
	Plug 'Mofiqul/dracula.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'nvim-tree/nvim-tree.lua'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'MunifTanjim/nui.nvim'
    Plug 'folke/noice.nvim'
    Plug 'tpope/vim-dadbod'
    Plug 'kristijanhusak/vim-dadbod-ui'
    Plug 'kristijanhusak/vim-dadbod-completion'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'github/copilot.vim'
	call plug#end()
]])

vim.cmd[[colorscheme dracula]]-- }}}

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

-- ============================================================================{{{
-- CMDILINE CENTRO NEOVIM
-- ============================================================================
require("noice").setup({
  cmdline = {
    enabled = true,
    view = "cmdline_popup", -- Posiciona a caixa de comando no centro da tela
    opts = {},
  },
  messages = {
    enabled = true, -- Redireciona as mensagens nativas para a interface flutuante
  },
  popupmenu = {
    enabled = true, -- Utiliza menu flutuante para autocompletar da linha de comando
  },
  lsp = {
    -- Desativa integrações LSP caso você esteja usando apenas o CoC.nvim
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.set_styled_text_op"] = true,
    },
  },
  presets = {
    bottom_search = true,    -- Mantém a busca `/` no pop-up central
    command_palette = true,   -- Estiliza a linha de comandos como uma paleta
    long_message_to_split = true, 
  },
})
--}}}

-- ============================================================================{{{
-- BACO DE DADOS
-- ============================================================================

-- Salva as conexões salvas na pasta do Neovim
vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"

-- Abre a interface em uma aba nova ou painel lateral
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1

-- Mapeamento para abrir/fechar a interface do Banco de Dados (<leader>db)
vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { silent = true, desc = "Alternar DB UI" })

-- }}}

-- ============================================================================{{{
-- LUALINE NEOVIM
-- ============================================================================

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'dracula',
    section_separators = '',
    component_separators = '',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {' '}
    }
})
---}}}

-- ============================================================================{{{
-- LUASCRPT NEOVIM
-- ============================================================================

--vim.api.nvim_create_autocmd("FileType", {
--    pattern = "java",
--    callback = function()
--        local function compilar_javac_src()
--            vim.cmd("write")
--            
--            if vim.fn.isdirectory("src") == 0 then
--                vim.fn.mkdir("src", "p")
--            end
--            
--            local file_current = vim.fn.expand("%:p")
--            vim.cmd("!javac -d src " .. file_current)
--
--        keymap.set("n", "C-x", compilar_javac_src, {
--            buffer = true, desc = "Compilar arquivo Java" }) end,
--})
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*",
  callback = function()
    local ext = vim.fn.expand("%:e")
    local skel_path = vim.fn.expand("~/.config/nvim/skel/skel." .. ext)
    if vim.fn.filereadable(skel_path) == 1 then
      vim.cmd("silent! 0r " .. skel_path)
      if ext == "java" then
        local filename = vim.fn.expand('%:t:r')
        vim.cmd("silent! %s/Underfield/" .. filename .. "/ge")
        end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java", -- Monitora e ativa apenas quando o arquivo for Java
  callback = function()
    
    -- Função interna que cria a pasta e compila
    local function compilar_java_src()
      vim.cmd("write") -- Salva o arquivo atual

      -- Cria o diretório 'src' se ele não existir
      if vim.fn.isdirectory("src") == 0 then
        vim.fn.mkdir("src", "p")
      end

      local arquivo_atual = vim.fn.expand("%")
      vim.cmd("!javac -d src " .. arquivo_atual)
    end

    -- Define o atalho APENAS para o buffer (arquivo) Java que foi aberto
    keymap("n", "<C-x>", compilar_java_src, {
      buffer = true, -- CRUCIAL: impede que o atalho vaze para outros tipos de arquivos
      desc = "Cria arquiv .class",
    })

  end,
})

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


local cocenter = vim.api.nvim_create_augroup("cocenter", { clear = true })
vim.api.nvim_create_autocmd({ "User" }, {
  group = cocenter,
  pattern = "CocNvimInit",
  callback = function()
    local ext = vim.fn.expand("%:e")
    local extenções_validas = {java = true, py = true, js = true, ts = true, c = true, cpp = true}
    if extenções_validas[ext] then
        vim.cmd("CocDiagnostic")
    end
  end,
})


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

