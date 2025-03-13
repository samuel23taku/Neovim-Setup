-- Load lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)
-- AutoSave
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = { "*" },
  command = "silent! wall",
  nested = true,
})

vim.opt.number = true
vim.cmd [[
  autocmd CursorHold * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved * lua vim.lsp.buf.clear_references()
]]
-- Shortcuts
vim.api.nvim_set_keymap("v","<C-c>", '"+y', {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<C-v>", '"+p', {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<A-1>", ":NvimTreeToggle<CR>", {noremap = true, silent = true})

-- Plugins
require("lazy").setup({
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },

  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  -- Syntax Highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
},
 
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "mfussenegger/nvim-jdtls" }, 

  -- Better Hover docs
  {"glepnir/lspsaga.nvim", branch = "main"}
})

-- LSP Servers Setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "jdtls" }
})

local lspconfig = require("lspconfig")

lspconfig.pyright.setup{}
lspconfig.jdtls.setup{}

-- Autocompletion
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" }
  })
})

-- AutoClosing brackets

-- File Explorer
require("nvim-tree").setup()
vim.keymap.set("n", "M-1", ":NvimTreeToggle<CR>")

-- Treesitter Syntax Highlighting
require("nvim-treesitter.configs").setup({
  ensure_installed = { "python", "java", "lua" },
  highlight = { enable = true }
})

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
  end
}
