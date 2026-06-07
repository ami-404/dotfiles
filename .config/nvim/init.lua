vim.opt.clipboard = "unnamedplus"

vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })

vim.g.mapleader = " "

-- save file and quit
vim.keymap.set("n", "<leader>w", ":update<Return>", opts)
vim.keymap.set("n", "<leader>q", ":quit<Return>", opts)
vim.keymap.set("n", "<leader>Q", ":qa<Return>", opts)
vim.keymap.set("n", "<leader>e", ":Lex<Return>", opts)

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

vim.opt.scrolloff = 8
vim.opt.cursorline = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.expandtab = true

-- Move line(s) up/down in normal/visual mode
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

vim.keymap.set('i', '(', '()<Left>')
vim.keymap.set('i', '[', '[]<Left>')
vim.keymap.set('i', '{', '{}<Left>')
vim.keymap.set('i', '"', '""<Left>')
vim.keymap.set('i', "'", "''<Left>")

require("nvim-tree").setup()

-- -- Set Netrw to tree view
-- vim.g.netrw_liststyle = 3
-- -- Open file in previous window
-- vim.g.netrw_browse_split = 0
-- -- Use 25% of screen width
-- vim.g.netrw_winsize = 25
-- -- Hide banner
-- vim.g.netrw_banner = 0
-- -- Automatically change directory when browsing
-- vim.g.netrw_chgwin = 1
