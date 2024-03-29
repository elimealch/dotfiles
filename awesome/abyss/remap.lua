--require("mmushrooms.apps")

-- Keybindings
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")

require("mmushrooms.set")
local menu = require("mmushrooms.menu")

-- Menubar configuration
menubar.utils.terminal = Terminal -- Set the terminal for applications that require it

--local Modkey = "Mod4"

local globalkeys = gears.table.join(
    awful.key({ Modkey }, "s", hotkeys_popup.show_help,
        {
            description = "show help",
            group = "awesome"
        }
    ),

    -- Navigate through tags and windows
    awful.key({ Modkey, "Shift" }, "j", awful.tag.viewprev,
        {
            description = "view previous",
            group = "tag"
        }
    ),
    awful.key({ Modkey, "Shift" }, "k", awful.tag.viewnext,
        {
            description = "view next",
            group = "tag"
        }
    ),
    awful.key({ Modkey, "Control" }, "j", awful.tag.history.restore,
        {
            description = "go back",
            group = "tag"
        }
    ),
    awful.key({ Modkey }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        {
            description = "focus next by index",
            group = "client"
        }
    ),
    awful.key({ Modkey }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        {
            description = "focus previous by index",
            group = "client"
        }
    ),
    awful.key({ Modkey }, "w",
        function()
            menu.main_menu:show()
        end,
        {
            description = "show main menu",
            group = "awesome"
        }
    ),

    -- Layout manipulation
    awful.key({ Modkey, "Shift" }, "l",
        function()
            awful.client.swap.byidx(1)
        end,
        {
            description = "swap with next client by index",
            group = "client"
        }
    ),
    awful.key({ Modkey, "Shift" }, "h",
        function()
            awful.client.swap.byidx(-1)
        end,
        {
            description = "swap with previous client by index",
            group = "client"
        }
    ),
    awful.key({ Modkey, "Control" }, "j",
        function()
            awful.screen.focus_relative(1)
        end,
        {
            description = "focus the next screen",
            group = "screen"
        }
    ),
    awful.key({ Modkey, "Control" }, "k",
        function()
            awful.screen.focus_relative(-1)
        end,
        {
            description = "focus the previous screen",
            group = "screen"
        }
    ),
    awful.key({ Modkey }, "u",
        awful.client.urgent.jumpto,
        {
            description = "jump to urgent client",
            group = "client"
        }
    ),
    awful.key({ Modkey }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {
            description = "go back",
            group = "client"
        }
    ),

    -- Standard program
    awful.key({ Modkey }, "Return",
        function ()
            awful.spawn(Terminal)
        end,
        {
            description = "open a terminal",
            group = "launcher"
        }
    ),

    -- AwesomeWM control
    awful.key({ Modkey, "Control" }, "r",
        awesome.restart,
        {
            description = "reload awesome",
            group = "awesome"
        }
    ),
    awful.key({ Modkey, "Shift" }, "q",
        awesome.quit,
        {
            description = "quit awesome",
            group = "awesome"
        }
    ),

    -- Tag layout control?
    awful.key({ Modkey }, "l",
        function()
            awful.tag.incmwfact( 0.05)
        end,
        {
            description = "increase master width factor",
            group = "layout"
        }
    ),
    awful.key({ Modkey }, "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {
            description = "decrease master width factor",
            group = "layout"
        }
    ),
    awful.key({ Modkey, "Shift" }, "h",
        function()
            awful.tag.incnmaster( 1, nil, true)
        end,
        {
            description = "increase the number of master clients",
            group = "layout"
        }
    ),
    awful.key({ Modkey, "Shift" }, "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {
            description = "decrease the number of master clients",
            group = "layout"
        }
    ),
    awful.key({ Modkey, "Control" }, "h",
        function()
            awful.tag.incncol( 1, nil, true)
        end,
        {
            description = "increase the number of columns",
            group = "layout"
        }
    ),
    awful.key({ Modkey, "Control" }, "l",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {
            description = "decrease the number of columns",
            group = "layout"
        }
    ),

    -- Tag layout control
    awful.key({ Modkey }, "space",
        function()
            awful.layout.inc(1)
        end,
        {
            description = "select next",
            group = "layout"
        }
    ),
    awful.key({ Modkey, "Shift" }, "space",
        function()
            awful.layout.inc(-1)
        end,
        {
            description = "select previous",
            group = "layout"
        }
    ),
    awful.key({ Modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        {
            description = "restore minimized",
            group = "client"
        }
    ),

    -- Prompt
    awful.key({ Modkey }, "r",
        function()
            awful.screen.focused().mypromptbox:run()
        end,
        {
            description = "run prompt",
            group = "launcher"
        }
    ),

    awful.key({ Modkey }, "x",
        function()
            awful.prompt.run({
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            })
        end,
        {
            description = "lua execute prompt",
            group = "awesome"
        }
    ),

    -- Menubar
    awful.key({ Modkey }, "p",
        function()
            menubar.show()
        end,
        {
            description = "show the menubar",
            group = "launcher"
        }
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ Modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {
                description = "view tag #"..i,
                group = "tag"
            }
        ),

        -- Toggle tag display.
        awful.key({ Modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {
                description = "toggle tag #" .. i,
                group = "tag"
            }
        ),

        -- Move client to tag.
        awful.key({ Modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {
                description = "move focused client to tag #"..i,
                group = "tag"
            }
        ),

        -- Toggle tag on focused client.
        awful.key({ Modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {
                description = "toggle focused client on tag #" .. i,
                group = "tag"
            }
        )
    )
end

local clientkeys = gears.table.join(
    awful.key({ Modkey }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {
            description = "toggle fullscreen",
            group = "client"
        }
    ),

    awful.key({ Modkey, "Shift" }, "c",
        function(c)
            c:kill()
        end,
        {
            description = "close",
            group = "client"
        }
    ),

    awful.key({ Modkey, "Control" }, "space",
        awful.client.floating.toggle,
        {
            description = "toggle floating",
            group = "client"
        }
    ),

    awful.key({ Modkey, "Control" }, "Return",
        function(c)
            c:swap(awful.client.getmaster())
        end,
        {
            description = "move to master",
            group = "client"
        }
    ),

    awful.key({ Modkey }, "o",
        function(c)
            c:move_to_screen()
        end,
        {
            description = "move to screen",
            group = "client"
        }
    ),

    awful.key({ Modkey }, "t",
        function(c)
            c.ontop = not c.ontop
        end,
        {
            description = "toggle keep on top",
            group = "client"
        }
    ),

    awful.key({ Modkey }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {
            description = "minimize",
            group = "client"
        }
    ),

    awful.key({ Modkey }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {
            description = "(un)maximize",
            group = "client"
        }
    ),

    awful.key({ Modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {
            description = "(un)maximize vertically",
            group = "client"
        }
    ),

    awful.key({ Modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {
            description = "(un)maximize horizontally",
            group = "client"
        }
    )
)


local clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ Modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ Modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = { "normal", "dialog" }
        },
        properties = { titlebars_enabled = true }
    },

    -- Set Web Browser to always map on the tag named "2" on screen 1.
    {
        rule = { class = "Brave" },
        properties = {
            screen = 1,
            tag = "2"
        },
    },
}
-- Rules 
