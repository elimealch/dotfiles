-- Standard awesome library
-- Utilities such as color parsing and objects
local gears = require("gears")

-- Everything related to window managment
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
--local menubar = require("menubar")
--local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
--local debian = require("debian.menu")
--local has_fdo, freedesktop = pcall(require, "freedesktop")

-- Error Handling
-- Check if AwesomeWM encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "There were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "An error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- Error Handling

-- Loading theme
require("mmushrooms")
local menu = require("mmushrooms.menu")
--local apps = require("mmushrooms.apps")

--local file = assert(io.open("awesome.log", "w"))
--file:write(tostring(mmushrooms))
--file:close()
--error(type(apps.terminal))
--error(type("Hola"))

-- Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("~/.config/awesome/theme.lua")

-- Variable definitions

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


awful.screen.connect_for_each_screen(
    function(s)
        -- Wallpaper
        set_wallpaper(s)

        menu.bar(s)
    end
)
-- }}}

-- Define a function to be called when the tag is changed
--local function on_tag_changed(tag)
--    -- Do something when the tag is changed, e.g., print the tag's name
--    naughty.notify({text = "Tag changed to: " .. tag.name})
--end

-- Connect the function to the "property::selected" signal of each tag
--naughty.notify({text = "Screen: " .. tostring(#screen[1].tags)})
--for _, t in ipairs(screen[1].tags) do
--    naughty.notify({text = "Connecting: " .. t.name})
--    t:connect_signal("property::selected", on_tag_changed)
--end

--tag.connect_signal("property::index",
--    function(s)
--        naughty.notify({text = tostring(s.name)})
--        --error("tag changed")
--    end
--)

-- {{{ Mouse bindings
root.buttons(
    gears.table.join(
        awful.button({}, 3, function() menu.main_menu:toggle() end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    )
)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage",
    function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup
            and not c.size_hints.user_position
            and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars",
    function(c)
        --local bg_focus = "#222222" -- beautiful.titlebar_bg_normal
        --if c.isterminal then
        --    bg_color = beautiful.titlebar_bg_terminal
        --end

        -- buttons for the titlebar
        local buttons = gears.table.join(
            awful.button({}, 1,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.move(c)
                end
            ),
            awful.button({}, 3,
                function()
                    c:emit_signal("request::activate", "titlebar", {raise = true})
                    awful.mouse.client.resize(c)
                end
            )
        )

        awful.titlebar(c, { size = 17, bg_focus = "#171a1f" }):setup({
            -- Left
            {
                wibox.widget.base.empty_widget(),
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            wibox.widget.base.empty_widget(),--{ -- Middle
            --
            --    { -- Title
            --        align  = "center",
            --        widget = awful.titlebar.widget.titlewidget(c)
            --    },
            --    buttons = buttons,
            --    layout  = wibox.layout.flex.horizontal
            --},

            -- Right
            {
                --awful.titlebar.widget.floatingbutton(c),
                awful.titlebar.widget.stickybutton(c),
                awful.titlebar.widget.minimizebutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                --awful.titlebar.widget.ontopbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal
            },
            --inner_fill_strategy = "center",
            layout = wibox.layout.align.horizontal
        })
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", { raise = false })
    end
)
client.connect_signal("focus",
    function(c)
        c.border_color = beautiful.border_focus
    end
)
client.connect_signal("unfocus",
    function(c)
        c.border_color = beautiful.border_normal
    end
)
-- }}}

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
