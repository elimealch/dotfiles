-- Disabling mouse clicks
vim.opt.mouse = ""

vim.opt.guicursor = {
    "n-v-c:block",
    "i-ci:ver25",
    "r-cr-o:hor20",
    "sm:block",
    "a:blinkwait1000-blinkoff1000-blinkon1000-Cursor",
}
--vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.rnu = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
--vim.opt.smarttab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.directory = os.getenv("HOME") .. "/.vim/swap/"
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 2000

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

--vim.opt.colorcolumn = "80"

local autocmd = vim.api.nvim_create_autocmd

--autocmd({"VimEnter"}, {
--    pattern = "*",
--    command = [[silent !printf "\033]12;\#FEF6BD\007"]]
--})

autocmd({"VimLeave"}, {
    pattern = "*",
    --command = [[silent !echo -ne "\033]112\007"]]
    callback = function()
        --local id = vim.fn.jobstart("echo -ne '\033[0 q'")
        --vim.fn.jobwait({ id })

        vim.opt.guicursor = "n:hor20-blinkoff1000-blinkon1000"
        --vim.api.nvim_command('echo "Hello"')
        --vim.api.nvim_command([[!reset]])
        --vim.cmd([[!echo -ne '\033[0 q']])
        --vim.fn.system({ "echo", "-ne", "'\033[0 q'" }, { text = true }):wait()
    end,
})
