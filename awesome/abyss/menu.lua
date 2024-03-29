local M = {}

-- Utilities such as color parsing and objects
local gears = require("gears")

-- Everything related to window managment
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local hotkeys_popup = require("awful.hotkeys_popup")

-- Notification library
local naughty = require("naughty")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

local rubato = require("lib.rubato")

require("mmushrooms.set")

-- Menu
-- Create a launcher widget and a main menu
--local awesome_menu = {
--    { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
--    { "Manual", Terminal .. " -e man awesome" },
--    { "Edit Configuration", editor_cmd .. " " .. awesome.conffile },
--    { "Restart", awesome.restart },
--    { "Quit", function() awesome.quit() end },
--}

--local menu_awesome = { "Awesome", awesome_menu, beautiful.awesome_icon }
local menu_awesome = {
    "Awesome",
    {
        { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
        { "Manual", Terminal .. " -e man awesome" },
        { "Edit Configuration", Editor_cmd .. " " .. awesome.conffile },
        { "Restart", awesome.restart },
        { "Quit", function() awesome.quit() end },
    },
    beautiful.awesome_icon
}
local menu_terminal = { "Terminal", Terminal }

-- I probably should fix this
--M.main_menu = nil
if has_fdo then
    M.main_menu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    M.main_menu = awful.menu({
        items = {
            menu_awesome,
            { "Debian", debian.menu.Debian_menu.Debian },
            menu_terminal,
        }
    })
end

local launcher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = M.main_menu
})

-- Menu

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local praise_widget = wibox.widget.textbox("Never give up!")
--praise_widget.text = "Never give up!"

local tasklist_buttons = gears.table.join(
    awful.button({}, 1,
        function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", { raise = true })
            end
        end
    ),
    awful.button({}, 3,
        function()
            awful.menu.client_list({ theme = { width = 250 } })
        end
    ),
    awful.button({}, 4,
        function()
            awful.client.focus.byidx(1)
        end
    ),
    awful.button({}, 5,
        function()
            awful.client.focus.byidx(-1)
        end
    )
)

-- Keyboard map indicator and switcher
local keyboard_layout = awful.widget.keyboardlayout()

-- Create a textclock widget
local text_clock = wibox.widget.textclock()

local timed = rubato.timed({
    duration = 1 / 2, -- Half a second
    intro = 1 / 6,
    override_dt = true,
    subscribed = function(pos) print(pos) end,
})
--gears.debug.print_warning("here")
-- Creates the bar
-- Receives a screen object as parameter
function M.bar(s)
    -- Each screen has its own tag table.
    awful.tag({ "◆", "◆", "◆", "◆", "◆" }, s, awful.layout.layouts[1])
    awful.tag.attached_connect_signal(s, "property::selected",
        function(tag)
            -- Do something when the tag is changed, e.g., print the tag's name
            --naughty.notify({text = "Tag changed to: " .. tag.index})
        end
    )
    -- Create a promptbox for each screen
    s.promptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(
        gears.table.join(
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(1) end),
            awful.button({}, 5, function() awful.layout.inc(-1) end)
        )
    )

    -- Create a taglist widget
    s.taglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        style = {
            shape = gears.shape.rounded_bar,
            font = "Iosevka Bold 13",
        },
        layout = {
            spacing = 5,
            spacing_widget = {
                color = "#c8ddb8aa",--'#20142900',
                shape = gears.shape.rect,
                widget = wibox.widget.separator,
            },
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        -- The shape where should appear the tag index
                        {
                            {
                                id = 'index_role',
                                widget = wibox.widget.textbox,
                            },
                            margins = 0, -- The shape size
                            widget = wibox.container.margin,
                        },
                        bg = '#372247',--000000ff', -- The shape color
                        shape = gears.shape.circle,
                        widget = wibox.container.background,
                    },
                    -- I don't know what it is
                    {
                        {
                            id = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 0, -- The distance between the circle and the tag name
                        widget = wibox.container.margin,
                    },
                    -- I also don't know what it is
                    {
                        id = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 7, -- I think it is the left distance between the tag name (or whatever that could stay on the tag) and the left margin of the tag
                right = 7, -- And I think it is the same as the left in the right 
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background,
            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                --self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
                self:connect_signal('mouse::enter', function()
                    if self.bg ~= '#372247' then--#ff0000' then
                        self.backup = self.bg
                        self.has_backup = true
                    end
                    self.bg = '#372247'
                end)
                self:connect_signal('mouse::leave', function()
                    if self.has_backup then self.bg = self.backup end
                end)
            end,
            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                --self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
            end,
        },
        buttons = taglist_buttons
    })

    -- Create a tasklist widget
    local tasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        --style = {
        --    --shape_border_width = 1,
        --    --shape_border_color = '#201429',
        --    --shape = "",
        --    --bg_normal = '#372247',
        --    bg_normal = '#222222aa',
        --    --spacing = 100,
        --},
        --layout = {
        --    spacing = 3,
        --    layout = wibox.layout.fixed.horizontal
        --},
        layout = {
            spacing = 5,
            spacing_widget = {
                color = "#c8ddb8aa",--'#20142900',
                --shape = gears.shape.rect,
                --forced_width = 100,
                widget = wibox.widget.separator,
            },
            max_widget_size = 150,
            --layout  = wibox.layout.fixed.horizontal
            layout  = wibox.layout.flex.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    {
                        id = "indicator_background_role",
                        widget = wibox.container.background,
                        --bg = "#372247ff",
                        forced_height = 1,
                        --forced_width = 10
                    },
                    {
                        id = "background_shading_role",
                        widget = wibox.container.background,
                        bg = "#372247aa",
                    },
                    --fill_space = true,
                    layout = wibox.layout.fixed.horizontal,
                },
                --{
                --    {
                --        {
                --            id = 'icon_role',
                --            widget = wibox.widget.imagebox,
                --        },
                --        margins = 2,
                --        widget = wibox.container.margin,
                --    },
                --    {
                --        id = 'text_role',
                --        widget = wibox.widget.textbox,
                --        --forced_width = 140,
                --        --wrap = "char",
                --        --valign = "top",
                --    },
                --    layout = wibox.layout.fixed.horizontal,
                --},
                --left = 5,
                --right = 5,
                forced_width = 170,
                --widget = wibox.container.margin,
                layout = wibox.layout.stack,
            },
            --layout = wibox.layout.stack,
            id = 'background_role',
            widget = wibox.container.background,

            update_common = function(self, c, index, objects)
                local widgets = self:get_children_by_id('background_shading_role')
                local bg = '#00000000'
                local icon_opacity = 1--beautiful.tasklist_icon_opacity_normal or 1
                if c.active then
                    bg = "#372247aa"--beautiful.tasklist_bg_focus or beautiful.bg_focus or bg_normal
                    icon_opacity = beautiful.tasklist_icon_opacity_focus or 1
                elseif c.urgent then
                    bg = "#372247aa"--beautiful.tasklist_bg_urgent or beautiful.bg_urgent or bg_normal
                    icon_opacity = 1--beautiful.tasklist_icon_opacity_focus or 1
                end
                --bg = utils.set_color_alpha(bg, beautiful.tasklist_bg_opacity or 0.2)
                for _, w in ipairs(widgets) do
                    w.bg = bg
                end
                --widgets = self:get_children_by_id('client_icon_role')
                --for _, w in ipairs(widgets) do
                --    w:set_opacity(icon_opacity)
                --end
            end,
            create_callback = function(self, c, index, objects)
                --self:get_children_by_id('icon_role')[1].image = c.icon
                --self:get_children_by_id('text_role')[1].text = c.name
                --local t = self:get_children_by_id('text_role')[1].text
                --error(tostring(t))
                --naughty.notify({text = tostring(t)})

                --error("Here")
                self.client = c
                if c.icon == nil then
                    local widgets = self:get_children_by_id('icon_margins_role')
                    for _, w in ipairs(widgets) do
                        w:set_left(0)
                    end
                end
                self.update_common(self, c, index, objects)

                --self:connect_signal('mouse::enter', function()
                    --    if self.bg ~= '#372247' then--#ff0000' then
                    --        self.backup = self.bg
                    --        self.has_backup = true
                    --    end
                    --    self.bg = '#372247'
                    --end)
                    --self:connect_signal('mouse::leave', function()
                        --    if self.has_backup then self.bg = self.backup end
                        --end)
            end,

            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                --error("here")
                self:update_common(c3, index, objects)
            end,
        },
    })

    -- Create a new indicator widget
    local indicator = wibox.widget({
        widget = wibox.widget.base.make_widget,
        forced_height = 2,
        bg = "#00FF00", -- Set the color of the indicator bar
    })

    local function custom_shape(cr, width, height)
        --gears.shape.rounded_rect(cr, width, height, 6)
        gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, 17)
    end
    -- Create the wibox
    s.wibox = awful.wibar({
        position = "top",
        border_width = 5,
        border_color = "#00000000",--"#20142900",
        screen = s,
        --stretch = false,
        --width = 1200,
        height = 24,
        shape = custom_shape,
        bg = "#372247aa",
    })
    -- Add widgets to the wibox
    s.wibox:setup({
        layout = wibox.layout.align.horizontal,

        -- Left widgets
        {
            layout = wibox.layout.fixed.horizontal,
            launcher,
            --{
            --    widget = wibox.widget.separator,
            --    --spacing = 4,
            --    shape = gears.shape.rounded_bar,
            --    color = '#20142900',
            --    layout = wibox.layout.align.horizontal,
            --},
            s.taglist,
            s.promptbox,
            praise_widget,
        },
        tasklist, -- Middle widget

        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            keyboard_layout,
            wibox.widget.systray(),
            text_clock,
            s.layoutbox,
        },
    })

    --s.mywibox = awful.wibar({ position = "top", screen = s, height = <bar_height * bar_count> })

    --s.mywibox:setup {
    --    { -- First bar. Contains the default bar content in this example
    --        { -- Left widgets
    --            layout = wibox.layout.fixed.horizontal,
    --            mylauncher,
    --            s.mytaglist,
    --            s.mypromptbox,
    --        },
    --        s.mytasklist, -- Middle widget
    --        { -- Right widgets
    --            layout = wibox.layout.fixed.horizontal,
    --            mykeyboardlayout,
    --            wibox.widget.systray(),
    --            mytextclock,
    --            s.mylayoutbox,
    --        },
    --        layout = wibox.layout.align.horizontal,
    --    },
    --    { -- Second bar. Can be composed of multiple widgets in a layout, or just a single widget, e.g.`s.mytasklist`
    --        -- Add your content here
    --        -- Choose a layout as appropriate
    --        layout = wibox.layout.align.horizontal,
    --    },
    --    -- add more entries here to create a third/fourth/etc. bar
    --    -- `flex` to create equally sized sections, `fixed` to have them sized based on their content
    --    layout = wibox.layout.flex.vertical,
    --}
end

return M
--return setmetatable({}, M)
