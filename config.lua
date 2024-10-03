-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- auto install treesitter parsers
lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.treesitter.ensure_installed = { "cpp", "c", "python" }

-- install plugins
lvim.plugins = {
    "ChristianChiarulli/swenv.nvim",
    "stevearc/dressing.nvim",
    "nvim-neotest/nvim-nio",
    "iamcco/markdown-preview.nvim",
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "ggandor/leap.nvim",
        lazy = false
    },
    "mfussenegger/nvim-dap",
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            handlers = {}
        },
    },
}

-- color scheme
require("tokyonight").setup({})
lvim.colorscheme = "tokyonight-storm"

-- Leap setup
require('leap').create_default_mappings()

-- automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
    "python", "cpp", "javascript"
}

-- setup markdown preview
require("lvim.lsp.manager").setup("markdown-preview")

local lspconfig = require("lspconfig")
lspconfig.clangd.setup({
  cmd = { "clangd", "--offset-encoding=utf-16" },
  -- Include any other settings you want for clangd here
  on_attach = lvim.lsp.on_attach,
  capabilities = lvim.lsp.capabilities,
})

-- setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    { name = "stylua" },
    { name = "black" }, -- Python formatting
    {
        name = "clang_format",
        filetypes = { "cpp", "hpp", "cc", "h", "cxx", "hxx" },
        extra_args = { "—filter", "-legal/copyright" }
    }
    --TODO: setup JS linter
}



-- Configure LunarVim's built-in terminal to open at the bottom
lvim.builtin.terminal.direction = "horizontal"

-- switch to next/previous tabs
vim.api.nvim_set_keymap('n', 'gt', ':BufferLineCycleNext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'gT', ':BufferLineCyclePrev<CR>', { noremap = true })
-- Redirect all normal mode delete operations to the black hole register
vim.api.nvim_set_keymap('n', 'd', '"_d', { noremap = true })
-- Redirect all visual mode delete operations to the black hole register
vim.api.nvim_set_keymap('v', 'd', '"_d', { noremap = true })
-- In insert mode, map Ctrl-h to act like the left arrow key
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', { noremap = true })
-- In insert mode, map Ctrl-j to act like the down arrow key
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', { noremap = true })
-- In insert mode, map Ctrl-k to act like the up arrow key
vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', { noremap = true })
-- In insert mode, map Ctrl-l to act like the right arrow key
vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', { noremap = true })
-- Move selected text up and down with j and k
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })
-- J with cursor kept in place
vim.api.nvim_set_keymap("n", "J", "mzJ`z", { noremap = true })
-- half page jumps but keep cursor in the middle
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })
-- keep search terms in middle
vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true })
vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true })
-- Replace the current word youre on
vim.api.nvim_set_keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { noremap = true })
-- Add a breakpoint at the current line
vim.api.nvim_set_keymap("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { noremap = true })
-- Start or continue debugging
vim.api.nvim_set_keymap("n", "<leader>dr", "<cmd>DapContinue<CR>", { noremap = true, silent = true })
-- Live grep
-- vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>")

-- Disable arrow keys
local function disable_arrow_keys()
    local keymap = vim.api.nvim_set_keymap
    local opts = { noremap = true }

    local modes = {'n', 'i', 'v', 'x'}  -- Normal, Insert, Visual, Visual Block, Command-line

    for _, mode in ipairs(modes) do
        keymap(mode, '<Up>', '<Nop>', opts)
        keymap(mode, '<Down>', '<Nop>', opts)
        keymap(mode, '<Left>', '<Nop>', opts)
        keymap(mode, '<Right>', '<Nop>', opts)
    end
 end

disable_arrow_keys()

-- Open filetree by default
local function open_nvim_tree()
    require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


-- Filter out shit from nvim-tree
lvim.builtin.nvimtree.setup.filters.custom = { "node_modules", "\\.cache", "lv-settings.lua",
    ".git", "*.pyc", "pyrightconfig.json", "__pycache__", ".mypy_cache", ".DS_store", "*.o" }

-- Filter out shit from telescope
lvim.builtin.telescope.defaults.file_ignore_patterns = {
    "node_modules",
    "\\.cache",
    "lv%-settings%.lua",
    "\\.git",
    "%.pyc",
    "pyrightconfig%.json",
    "__pycache__",
    "%.mypy_cache",
    "\\.DS_store",
    "%.o"
}

-- Turn on relative line numbers
vim.opt.relativenumber = true

-- Use system clipboard
vim.api.nvim_set_option("clipboard", "unnamed")

-- TODO: setup neoscroll.nvim

-- Close lazy with escape
require('lazy.view.config').keys.close = '<Esc>'

-- Set default tab size to 4 spaces
vim.opt.tabstop = 4      -- The number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4   -- The size of an 'indent'
vim.opt.expandtab = true -- Converts tabs to spaces
