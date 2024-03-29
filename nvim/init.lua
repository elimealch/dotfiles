require("mmushrooms")

--if os.getenv('TERM') == 'xterm-kitty' then
--    --local augroup = vim.api.nvim_create_augroup
--    --local autocmd = vim.api.nvim_create_autocmd
--
--    --augroup('kitty_padd')
--    --autocmd('
--    vim.cmd[[
--        augroup kitty_padd
--            autocmd!
--            au VimEnter * :silent !kitty @ set-spacing padding=0
--            au VimLeave * :silent !kitty @ set-spacing padding=default
--        augroup END
--    ]]
--end
