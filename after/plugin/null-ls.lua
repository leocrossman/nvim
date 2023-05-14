local null_ls = require("null-ls")

-- code action sources
local code_actions = null_ls.builtins.code_actions

-- diagnostic sources
local diagnostics = null_ls.builtins.diagnostics

-- formatting sources
local formatting = null_ls.builtins.formatting

-- hover sources
local hover = null_ls.builtins.hover

-- completion sources
local completion = null_ls.builtins.completion

local eslint = require("eslint")
eslint.setup({
  bin = 'eslint', -- or `eslint_d`
  -- bin = 'eslint_d', -- or `eslint`
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = false,
      types = { "directive", "problem", "suggestion", "layout" },
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line", -- or `same_line`
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "type", -- or `save`
  },
  settings = {
    nodePath = ''
  }
})


local sources = {
  -- formatting.eslint,
  -- formatting.prettierd.with({
    -- env = { PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.prettierrc") },
    -- prefer_local = "node_modules/.bin",
    -- filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss",
      -- "less", "html", "json", "jsonc", "yaml", "markdown", "markdown.mdx", "graphql", "handlebars" }
  -- }),
  diagnostics.eslint.with({
    env = { ESLINT_DEFAULT_CONFIG = vim.fn.expand('~/.eslintrc.js') },
    -- nodePath = ''
  }),
  completion.spell,
  code_actions.eslint
}



-- PRETTIER SETUP
local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

-- END PRETTIER SETUP

local defaults = {
  border = nil,
  cmd = { "nvim" },
  debounce = 250,
  debug = false,
  default_timeout = 5000,
  diagnostic_config = {},
  diagnostics_format = "#{m}",
  fallback_severity = vim.diagnostic.severity.ERROR,
  log_level = "warn",
  notify_format = "[null-ls] %s",
  on_attach = nil,
  on_init = nil,
  on_exit = nil,
  root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
  should_attach = nil,
  sources = nil,
  temp_dir = nil,
  update_in_insert = false,
}

-- null_ls.setup({ sources = sources, autostart = true })
null_ls.setup({
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})
