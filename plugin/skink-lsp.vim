" skink-lsp.vim — auto-start skink-lsp for *.skink buffers (Neovim >= 0.8).
" For Vim8/other clients (vim-lsp, coc.nvim, ALE) see README.md.
if !has('nvim-0.8')
  finish
endif

lua <<LUA
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'skink',
  callback = function(ev)
    local path = vim.api.nvim_buf_get_name(ev.buf)
    -- root = nearest skink.toml ancestor, else the file's directory
    local found = vim.fs.find({'skink.toml'}, { upward = true, path = path })[1]
    local root = found and vim.fs.dirname(found) or vim.fs.dirname(path)
    vim.lsp.start({
      name = 'skink-lsp',
      cmd = { 'skink-lsp' },
      root_dir = root,
    }, { bufnr = ev.buf })
  end,
})
LUA
