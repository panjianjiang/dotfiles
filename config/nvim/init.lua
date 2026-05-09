vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

local function has_exe(name)
  return vim.fn.executable(name) == 1
end

local state_dir = vim.fn.stdpath("state")
if vim.fn.isdirectory(state_dir) == 1 and vim.fn.filewritable(state_dir) ~= 2 then
  vim.env.NVIM_LOG_FILE = "/tmp/nvim.log"
  vim.lsp.log._set_filename("/tmp/nvim-lsp.log")
  opt.shadafile = "NONE"
end

local plugins = {
  {
    src = "https://github.com/Saghen/blink.cmp",
    name = "blink.cmp",
  },
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    version = "main",
  },
}

if vim.pack and has_exe("git") then
  vim.pack.add(plugins, { confirm = false })

  vim.api.nvim_create_user_command("PackUpdate", function(command)
    local names = #command.fargs > 0 and command.fargs or nil
    vim.pack.update(names)
  end, {
    nargs = "*",
    complete = function()
      return vim
        .iter(vim.pack.get())
        :map(function(plugin)
          return plugin.spec.name
        end)
        :totable()
    end,
  })

  vim.api.nvim_create_user_command("PackStatus", function()
    local lines = vim
      .iter(vim.pack.get())
      :map(function(plugin)
        return string.format(
          "%-20s %s %s",
          plugin.spec.name,
          plugin.active and "active" or "inactive",
          plugin.path
        )
      end)
      :totable()
    vim.api.nvim_echo({ { table.concat(lines, "\n") } }, false, {})
  end, {})
end

opt.number = true
opt.relativenumber = false
opt.termguicolors = true
opt.title = true
opt.mouse = "a"
opt.confirm = true
opt.hidden = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 400
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.undofile = true

if has_exe("wl-copy") or has_exe("xclip") or has_exe("xsel") then
  opt.clipboard = "unnamedplus"
end

opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.expandtab = true

pcall(vim.cmd.colorscheme, "vim")

local function map(mode, lhs, rhs, desc, opts_)
  local opts_map = { silent = true, desc = desc }
  if opts_ then
    opts_map = vim.tbl_extend("force", opts_map, opts_)
  end
  vim.keymap.set(mode, lhs, rhs, opts_map)
end

map("n", "<leader>w", "<cmd>write<cr>", "Write buffer")
map("n", "<leader>q", "<cmd>quit<cr>", "Quit window")
map("n", "<leader>h", "<cmd>nohlsearch<cr>", "Clear search highlight")

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = {
    spacing = 2,
    source = "if_many",
  },
  float = {
    border = "rounded",
    source = true,
  },
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("user-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 120 })
  end,
})

if has_exe("ansible-language-server") then
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("user-filetypes", { clear = true }),
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
end

local servers = {
  pyright = {
    executable = "pyright-langserver",
    config = {
      cmd = { "pyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        ".git",
      },
    },
  },
  ruff = {
    executable = "ruff",
    config = {
      cmd = { "ruff", "server" },
      filetypes = { "python" },
      root_markers = {
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
        ".git",
      },
    },
  },
  bashls = {
    executable = "bash-language-server",
    config = {
      cmd = { "bash-language-server", "start" },
      filetypes = { "sh", "bash" },
      root_markers = { ".git" },
    },
  },
  taplo = {
    executable = "taplo",
    config = {
      cmd = { "taplo", "lsp", "stdio" },
      filetypes = { "toml" },
      root_markers = { "taplo.toml", "pyproject.toml", "Cargo.toml", ".git" },
    },
  },
  marksman = {
    executable = "marksman",
    config = {
      cmd = { "marksman", "server" },
      filetypes = { "markdown" },
      root_markers = { ".marksman.toml", ".git" },
    },
  },
  jsonls = {
    executable = "vscode-json-language-server",
    config = {
      cmd = { "vscode-json-language-server", "--stdio" },
      filetypes = { "json", "jsonc" },
      root_markers = { "package.json", ".git" },
    },
  },
  yamlls = {
    executable = "yaml-language-server",
    config = {
      cmd = { "yaml-language-server", "--stdio" },
      filetypes = { "yaml" },
      root_markers = { ".git" },
    },
  },
  ansiblels = {
    executable = "ansible-language-server",
    config = {
      cmd = { "ansible-language-server", "--stdio" },
      filetypes = { "yaml.ansible", "ansible" },
      root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
    },
  },
}

local function enable_lsp(name, spec)
  if not (vim.lsp and vim.lsp.config and vim.lsp.enable) then
    return
  end
  if not has_exe(spec.executable) then
    return
  end
  vim.lsp.config(name, spec.config)
  vim.lsp.enable(name)
end

for name, spec in pairs(servers) do
  enable_lsp(name, spec)
end

-- nvim-treesitter `main` branch API:
--   :TSInstall <lang>...  to install parsers (run once per language)
--   :TSUpdate             to update them
local ok_treesitter = pcall(require, "nvim-treesitter")
if ok_treesitter then
  -- ansible files share the YAML grammar
  pcall(vim.treesitter.language.register, "yaml", "yaml.ansible")

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
    callback = function(args)
      local buf = args.buf
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      local ft = args.match
      if ft == nil or ft == "" then
        return
      end
      local lang = vim.treesitter.language.get_lang(ft) or ft
      -- language.add throws on missing/broken parsers; silent skip
      local ok_add, added = pcall(vim.treesitter.language.add, lang)
      if not ok_add or not added then
        return
      end
      if not pcall(vim.treesitter.start, buf, lang) then
        return
      end
      pcall(function()
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end)
    end,
  })
end

local function format_buffer()
  vim.lsp.buf.format({
    async = true,
    filter = function(client)
      return client.name ~= "pyright"
    end,
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local opts_buf = { buffer = bufnr }

    if client and client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    map("n", "K", vim.lsp.buf.hover, "LSP hover", opts_buf)
    map("n", "gd", vim.lsp.buf.definition, "Go to definition", opts_buf)
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration", opts_buf)
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation", opts_buf)
    map("n", "gr", vim.lsp.buf.references, "References", opts_buf)
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol", opts_buf)
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action", opts_buf)
    map("n", "<leader>f", format_buffer, "Format buffer", opts_buf)
    map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics", opts_buf)
    map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic", opts_buf)
    map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic", opts_buf)
  end,
})

local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
  blink.setup({
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
end
