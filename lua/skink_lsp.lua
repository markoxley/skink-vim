-- skink_lsp.lua — ready-made skink-lsp client config for manual setup.
--   require('skink_lsp').setup()        -- auto-start on FileType skink
--   require('skink_lsp').setup{cmd=…}   -- custom binary path
-- Works standalone (nvim >= 0.8, vim.lsp.start) or as input to a
-- client framework (vim-lsp / lspconfig-style wrappers).

local M = {}

M.defaults = {
  name = 'skink-lsp',
  cmd = { 'skink-lsp' },
}

local function find_root(bufname)
  local found = vim.fs.find({'skink.toml'}, { upward = true, path = bufname })[1]
  return found and vim.fs.dirname(found) or vim.fs.dirname(bufname)
end

function M.start(bufnr)
  bufnr = bufnr or 0
  local path = vim.api.nvim_buf_get_name(bufnr)
  local cfg = vim.tbl_deep_extend('force', M.defaults, { root_dir = find_root(path) })
  return vim.lsp.start(cfg, { bufnr = bufnr })
end

function M.setup(opts)
  M.defaults = vim.tbl_deep_extend('force', M.defaults, opts or {})
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'skink',
    callback = function(ev) M.start(ev.buf) end,
  })
end

return M
