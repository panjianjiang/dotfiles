vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.cmd.colorscheme("vim")

vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.title = true

require("nvim-treesitter.configs").setup({
  ensure_installed = { "ocaml", "ocaml_interface" },
  highlight = { enable = true },
  indent = { enable = true },
})

vim.lsp.config("ocamllsp", {
  cmd = { "ocamllsp" },
  filetypes = { "ocaml", "ocaml.interface" },
  root_markers = { "dune-project", ".git" },
})

vim.lsp.enable("ocamllsp")

vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
})

vim.lsp.config("ruff", {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  },
})

vim.lsp.enable("pyright")
vim.lsp.enable("ruff")

vim.lsp.config("marksman", {
  cmd = { "marksman", "server" },
  filetypes = { "markdown" },
  root_markers = { ".marksman.toml", ".git" },
})

vim.lsp.config("jsonls", {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git" },
})

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  root_markers = { ".git" },
})

vim.lsp.config("ansiblels", {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible", "ansible" },
  root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*/playbooks/*.yml",
    "*/playbooks/*.yaml",
    "*/roles/*/tasks/*.yml",
    "*/roles/*/tasks/*.yaml",
    "*/roles/*/handlers/*.yml",
    "*/roles/*/handlers/*.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})

vim.lsp.config("racket_langserver", {
  cmd = { "racket", "-l", "racket-langserver" },
  filetypes = { "racket", "scheme" },
  root_markers = { "info.rkt", ".git" },
})

vim.lsp.enable("marksman")
vim.lsp.enable("jsonls")
vim.lsp.enable("yamlls")
vim.lsp.enable("ansiblels")
vim.lsp.enable("racket_langserver")

vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end)

require("blink.cmp").setup({
  keymap = {
    preset = "default",
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = { auto_show = true },
    menu = { auto_show = true },
  },
  sources = {
    default = { "lsp", "path", "buffer" },
  },
  fuzzy = {
    implementation = "lua",
  },
})
