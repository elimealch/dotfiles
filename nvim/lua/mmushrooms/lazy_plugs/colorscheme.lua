--[[
local function load_colorscheme()
    require("tokyonight").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        light_style = "night", -- The theme is used when the background is set to light
        transparent = true, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
        styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            comments = { italic = true },
            keywords = { italic = true },
            functions = { italic = false },
            variables = { underline = false },
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = "dark", -- style for sidebars, see below
            floats = "dark", -- style for floating windows
        },
        sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false, -- dims inactive windows
        lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

        --- You can override specific color groups to use other groups or a hex color
        --- function will be called with a ColorScheme table
        ---@param colors ColorScheme
        on_colors = function(colors) end,

        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with a Highlights and ColorScheme table
        ---@param highlights Highlights
        ---@param colors ColorScheme
        on_highlights = function(highlights, colors) end,
    })

    vim.cmd[[colorscheme tokyonight]]
--end
--[[
return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    init = load_colorscheme,
}
--]]

return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {},
    init = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true, -- disables setting the background color.
            show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
            term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
            dim_inactive = {
                enabled = false, -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.15, -- percentage of the shade to apply to the inactive window
            },
            no_italic = false, -- Force no italic
            no_bold = false, -- Force no bold
            no_underline = false, -- Force no underline
            styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
                comments = { "italic" }, -- Change the style of comments
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
                -- miscs = {}, -- Uncomment to turn off hard-coded styles
            },
            highlight_overrides = {},
            color_overrides = {
                mocha = {
                    rosewater = "#efc9c2",
                    flamingo = "#ebb2b2",
                    pink = "#f2a7de",
                    mauve = "#b889f4",
                    red = "#ea7183",
                    maroon = "#ea838c",
                    peach = "#f39967",
                    yellow = "#eaca89",
                    green = "#96d382",
                    teal = "#78cec1",
                    sky = "#91d7e3",
                    sapphire = "#68bae0",
                    blue = "#739df2",
                    lavender = "#a0a8f6",
                    text = "#F4CDE9",
                    subtext1 = "#DEBAD4",
                    subtext0 = "#C8A6BE",
                    overlay2 = "#B293A8",
                    overlay1 = "#9C7F92",
                    overlay0 = "#866C7D",
                    surface2 = "#705867",
                    surface1 = "#5A4551",
                    surface0 = "#44313B",

                    base = "#352939",
                    mantle = "#211924",
                    crust = "#1a1016",
                },
            },
            custom_highlights = {
                String = {
                    fg = "#F0C0E4",
                    style = { "bold" }
                },
                --Cursor = {
                --    fg = "#F0C0E4",
                --},
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = false,
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        })

        -- setup must be called before loading
        vim.cmd[[colorscheme catppuccin]]
        --vim.api.nvim_set_hl(0, "Cursor", {
        --    --gui=NONE,
        --    fg="#F0C0E4",
        --    bg="#F0C0E4"
        --})
    end
}
