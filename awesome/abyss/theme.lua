--local awesome = require("awesome")
local beautiful = require("beautiful")
local screen = require("awful").screen.focused()

--awesome.set_preferred_icon_size(8)
local home = os.getenv("HOME")
local assets_dir = os.getenv("HOME") .. "/.config/awesome/assets/"

local theme = {
    font = "Iosevka Bold 11",
    useless_gap = screen.dpi * 3,
    border_width = 1,
    border_normal = "#ffffff",
    --border_focus = "#ffcd8f",
    border_focus = "#000000",
    wallpaper = assets_dir .. "wallpaper/Markotop.jpg",
    --awesome_icon = home .. "/.local/icons/pixelitos",
    awesome_icon = assets_dir .. "icons/croa.png",
    icon_theme = home .. ".local/share/icons/pixelitos/16",
    -- Awesome Icon
    --awesome
    -- Taglist colors
    taglist_fg_focus = "#201429",
    taglist_bg_focus = "#201429aa",
    taglist_bg_occupied = "#142920aa",
}

beautiful.init(theme)
