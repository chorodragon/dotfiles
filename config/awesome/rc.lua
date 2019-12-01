local tags      = { }
local statusbar = { }
local promptbox = { }
local taglist   = { }
local tasklist  = { }
local layoutbox = { }
local settings  = { }

local gears 	  = require("gears")
local awful 	  = require("awful")
local wibox 	  = require("wibox")
local beautiful = require("beautiful")
local naughty	  = require("naughty")
local vicious	  = require("vicious")


require("awful.autofocus")

-- {{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- }}

-- {{Directories
home		= os.getenv("HOME")
confdir 	= home .. "/.config/awesome/"
-- }}



-- {{Variables
settings.modkey     = "Mod4"
settings.term       = "kitty"
settings.browser    = "firefox"
settings.dateformat = "%Y/%m/%d %H:%M"
settings.bar_height = 16


naughty.config.defaults.screen = 1

-- }}

beautiful.init(confdir .. "themes/theme.lua")


-- {{ Layouts and Tags
settings.layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.spirtal,
}

tags.settings = {
  {
    { name = "term",    props = { layout = settings.layouts[2], master_width_factor = .6815 } },
    { name = "browser", props = { layout = settings.layouts[2], master_width_factor = .6815 } },
    { name = "code",    props = { layout = settings.layouts[2], master_width_factor = .6815 } },
    { name = "media",   props = { layout = settings.layouts[2], master_width_factor = .6815 } },
    { name = "vn",      props = { layout = settings.layouts[2], master_width_factor = .6815 } },
  },
  {
    { name = "term",    props = { layout = settings.layouts[2], master_width_factor = .6815 } },
    { name = "browser", props = { layout = settings.layouts[2], master_width_factor = .6815 } },
    { name = "code",    props = { layout = settings.layouts[2], master_width_factor = .6815 } },
    { name = "media",   props = { layout = settings.layouts[2], master_width_factor = .6815 } },
    { name = "vn",      props = { layout = settings.layouts[2], master_width_factor = .6815 } },
  }

}

for s = 1, screen.count() do
  tags[s] = {}
  for i, v in ipairs(tags.settings[s]) do
    v.props.screen = s
    tags[s][i] = awful.tag.add(v.name, v.props)
  end
  tags[s][1].selected = true
end

-- }}

-- {{ Menu
menu = awful.menu({
  items = {
    --[[
    { settings.term,      settings.term,    theme.menu_terminal },
    { settings.browser,   settings.browser, theme.menu_terminal },
    --]]
    { settings.term,      settings.term},
    { settings.browser,   settings.browser},
  }
})

-- }}

-- {{ Widgets
function make_fixed_textbox(w, a, t)
    local tb = wibox.widget.textbox()
    local widget = wibox.container.margin(tb, 0, 0, -1, 0)
    widget.tb = tb
    tb.fit = function(_, _, h) return w, h end
    if a then
        tb.align = a
    end
    if t then
        tb.markup = t
    end
    return widget
end

padding       = wibox.widget.textbox()
separator     = wibox.widget.textbox()
cpuwidget     = wibox.widget.textbox()
clockwidget   = wibox.widget.textbox()
memwidget     = wibox.widget.textbox()
tempwidget    = wibox.widget.textbox()
batterywidget = wibox.widget.textbox()

padding:set_text(" ")
separator:set_markup("<span color='#444'> | </span>")

vicious.register(clockwidget, vicious.widgets.date, " " .. settings.dateformat, 1)
vicious.register(cpuwidget, vicious.widgets.cpu, "$1%", 1)
vicious.register(memwidget, vicious.widgets.mem, "$2 mb", 1)
vicious.register(tempwidget, vicious.widgets.thermal, "$1℃", 1, "thermal_zone0")
vicious.register(batterywidget, vicious.widgets.bat, "$2%", 1, "BAT1")
-- }}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () menu:toggle() end)
))
-- }}}

-- Menubar configuration
--menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
for s = 1, screen.count() do
	gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

awful.screen.connect_for_each_screen(function(s)
    promptbox[s] = awful.widget.prompt()
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
      awful.button({  }, 1, function() awful.layout.inc(settings.layouts, 1) end),
      awful.button({  }, 3, function() awful.layout.inc(settings.layouts, -1) end)
    ))
    taglist[s]  = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)
    tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist.buttons)

    local left_layout   = wibox.layout.fixed.horizontal()
    local right_layout  = wibox.layout.fixed.horizontal()

    statusbar[s] = awful.wibar({
      position = "top",
      height = settings.bar_height,
      screen = s
    })

    left_layout:add(taglist[s])
    left_layout:add(promptbox[s])
    if s.index == naughty.config.defaults.screen then
    right_layout:add(padding)
    right_layout:add(tempwidget)
    right_layout:add(padding)
    right_layout:add(separator)
    right_layout:add(padding)
    right_layout:add(memwidget)
    right_layout:add(padding)
    right_layout:add(separator)
    right_layout:add(padding)
    right_layout:add(cpuwidget)
    right_layout:add(padding)
    right_layout:add(separator)
    right_layout:add(padding)
    right_layout:add(batterywidget)
    right_layout:add(padding)
    right_layout:add(separator)
    right_layout:add(padding)
    right_layout:add(clockwidget)
  end
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(tasklist[s])
    layout:set_right(right_layout)
    statusbar[s]:set_widget(layout)
end)
-- }}}


-- {{{ Key bindings
local globalkeys = awful.util.table.join (
  awful.key({ settings.modkey               }, "Left",       awful.tag.viewprev),
  awful.key({ settings.modkey               }, "Right",      awful.tag.viewnext),
  awful.key({ settings.modkey               }, "Escape",     awful.tag.history.restore),
  awful.key({ settings.modkey,  "Control"   }, "r",          awesome.restart),
  awful.key({ settings.modkey               }, "r",          function () promptbox[mouse.screen]:run() end),
  awful.key({ settings.modkey               }, "q",          awesome.quit),
  awful.key({ "Control"                     }, "Print",      function() awful.spawn.with_shell("sleep 0.5s && scrot -s") end),
  awful.key({ settings.modkey               }, "Return",     function() awful.spawn(settings.term) end),
  awful.key({ settings.modkey               }, "Tab",        function()
    awful.client.focus.history.previous()
    if client.focus then client.focus:raise() end
  end),
  awful.key({ settings.modkey               }, "j",          function()
    awful.client.focus.bydirection("down")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ settings.modkey               }, "k",          function()
    awful.client.focus.bydirection("up")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ settings.modkey               }, "h",          function()
    awful.client.focus.bydirection("left")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ settings.modkey               }, "l",          function()
    awful.client.focus.bydirection("right")
    if client.focus then client.focus:raise() end
  end),
  awful.key({ settings.modkey, "Shift"      }, "l",          function () awful.tag.incmwfact(-0.05) end),
  awful.key({ settings.modkey, "Shift"      }, "h",          function () awful.tag.incmwfact(0.05) end),
  awful.key({ settings.modkey,              }, "space",      function () awful.layout.inc( 1) end),
  awful.key({ settings.modkey, "Control"    }, "j",          function () awful.screen.focus_relative( 1) end),
  awful.key({ settings.modkey, "Control"    }, "k",          function () awful.screen.focus_relative(-1) end)
)

local clientkeys = gears.table.join (
  awful.key({ settings.modkey             }, "c",                       function(c) c:kill() end),
  awful.key({ settings.modkey, "Control"  }, "space",                   awful.client.floating.toggle),
  awful.key({ settings.modkey, "Shift"    }, "f",                       function(c) c.fullscreen = not c.fullscreen end),
  awful.key({ settings.modkey             }, "m",                       function(c) c.maximized = not c.maximized end),
  awful.key({                             }, "XF86AudioRaiseVolume",    function(c) awful.spawn.with_shell("amixer sset Master 2%+") end),
  awful.key({                             }, "XF86AudioLowerVolume",    function(c) awful.spawn.with_shell("amixer sset Master 2%-") end),
  awful.key({                             }, "XF86AudioMute",           function(c) awful.spawn.with_shell("amixer -q set Master toggle") end),
  awful.key({                             }, "XF86AudioPrev",           function(c) awful.spawn.with_shell("playerctl --player=spotify previous") end),
  awful.key({                             }, "XF86AudioNext",           function(c) awful.spawn.with_shell("playerctl --player=spotify next") end),
  awful.key({                             }, "XF86AudioPlay",           function(c) awful.spawn.with_shell("playerctl --player=spotify play-pause") end)
)

keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
  globalkeys = awful.util.table.join(globalkeys,
  awful.key({ settings.modkey }, "#" .. i + 9, function()
    local screen = mouse.screen.index
    if tags[screen][i] then
      tags[screen][i]:view_only()
    end
  end),
  awful.key({ settings.modkey, "Control" }, "#" .. i + 9, function()
            local screen = mouse.screen.index
            if tags[screen][i] then
                tags[screen][i]:view_only()
            end
        end),
        awful.key({ settings.modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end),
        awful.key({ settings.modkey, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end)
    )
end

function nth_next_tag(n)
  return gears.math.cycle(#tags[client.focus.screen.index], client.focus.first_tag.index + n)
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ settings.modkey }, 1, function (c)
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({ settings.modkey }, 3, function(c)
        c:raise()
        awful.mouse.client.resize(c)
    end),
    awful.button({ settings.modkey }, 4, function()
        if client.focus then
            local tag = client.focus.screen.tags[nth_next_tag(1)]
            if tag then
                client.focus:move_to_tag(tag)
            end
            tag:view_only()
        end
    end),
    awful.button({ settings.modkey }, 5, function()
        if client.focus then
            local tag = client.focus.screen.tags[nth_next_tag(-1)]
            if tag then
                client.focus:move_to_tag(tag)
            end
            tag:view_only()
        end
    end)
)


-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = 
{
    { 
      rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     size_hints_honor = false
     }
    },

    -- Floating clients.
    { rule_any = {
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
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart Applications
awful.spawn.with_shell(confdir ..	"autorun.sh")
