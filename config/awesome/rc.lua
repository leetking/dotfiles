local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.autofocus")
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

local widget = require("widget")
local popen = require("common").popen
local brightness = require("common").brightness

--local tags_label = { "❻", "❼", "❽", "❾", }
--local tags_label = {"Main", "Code", "Essay", "Amuse", }
local tags_label = {"壹", "貳", "叄", "肆", "伍", "陆", "柒",}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,})
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),})
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_dir("config") .. "themes/A/init.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "termite"
local editor = os.getenv("EDITOR")
--editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    --awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e \"man awesome\"" },
   { "edit config", ("%s -e %q"):format(terminal, editor .. " " .. awesome.conffile) },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
   { "shutdown", function() awful.spawn("shutdown -h now") end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
        awful.button({ }, 1, function(t) t:view_only() end),
        awful.button({ modkey }, 1,
                     function(t)
                       if client.focus then
                         client.focus:move_to_tag(t)
                       end
                     end),
        awful.button({ }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
                                  if client.focus then
                                      client.focus:toggle_tag(t)
                                  end
                              end),
        awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end))

local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end),
        awful.button({}, 3, client_menu_toggle_fn()),
        awful.button({}, 4, function() awful.client.focus.byidx(1)  end),
        awful.button({}, 5, function() awful.client.focus.byidx(-1) end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, false)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.brightness = brightness("eDP-1")
-- Init a screen
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(tags_label, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.layout = awful.widget.layoutbox(s)
    s.layout:buttons(gears.table.join(
            awful.button({ }, 1, function() awful.layout.inc( 1) end),
            awful.button({ }, 3, function() awful.layout.inc(-1) end),
            awful.button({ }, 4, function() awful.layout.inc( 1) end),
            awful.button({ }, 5, function() awful.layout.inc(-1) end)))
    s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    s.prompt = awful.widget.prompt()
    s.power = widget.power("BAT1")
    s.volume = widget.volume()
    s.sensor = widget.sensor("hwmon1")
    s.clock = widget.clock()
    s.cpu = widget.cpu()
    s.mem = widget.mem()
    s.sysload = widget.sysload()
    s.weather = widget.weather("丹棱")
    s.net = widget.net("wlp8s0", "enp7s0")
    s.sprtr = wibox.widget.textbox("  ")

    -- Create the status bar
    s.wibar = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibar
    s.wibar:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.taglist,
            s.prompt,
        },
        s.tasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

            wibox.widget.systray(), s.sprtr,

            s.weather, s.sprtr,
            s.net,     s.sprtr,
            s.cpu, s.mem, s.sysload, s.sprtr,
            s.sensor,  s.sprtr,
            s.volume,  s.sprtr,
            s.power,   s.sprtr,
            s.clock,
            s.layout,
        },
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
awful.button({ }, 3, function() mymainmenu:toggle() end),
awful.button({ }, 4, awful.tag.viewnext),
awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
{description="show help", group="awesome"}),
awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
{description = "view previous", group = "tag"}),
awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
{description = "view next", group = "tag"}),
awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
{description = "go back", group = "tag"}),

awful.key({ modkey,           }, "j",
function()
  awful.client.focus.byidx( 1)
end,
{description = "focus next by index", group = "client"}
),
awful.key({ modkey,           }, "k",
function()
  awful.client.focus.byidx(-1)
end,
{description = "focus previous by index", group = "client"}
),
awful.key({ modkey,           }, "w", function() mymainmenu:show() end,
{description = "show main menu", group = "awesome"}),

-- Layout manipulation
awful.key({ modkey, "Shift"   }, "j", function() awful.client.swap.byidx(  1)    end,
{description = "swap with next client by index", group = "client"}),
awful.key({ modkey, "Shift"   }, "k", function() awful.client.swap.byidx( -1)    end,
{description = "swap with previous client by index", group = "client"}),
awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative( 1) end,
{description = "focus the next screen", group = "screen"}),
awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
{description = "focus the previous screen", group = "screen"}),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
{description = "jump to urgent client", group = "client"}),
awful.key({ modkey,           }, "Tab",
function()
  awful.client.focus.history.previous()
  if client.focus then
    client.focus:raise()
  end
end,
{description = "go back", group = "client"}),

-- Standard program
awful.key({ modkey,           }, "Return", function() awful.spawn(terminal) end,
{description = "open a terminal", group = "launcher"}),
awful.key({ modkey, "Control" }, "r", awesome.restart,
{description = "reload awesome", group = "awesome"}),
awful.key({ modkey, "Shift"   }, "q", awesome.quit,
{description = "quit awesome", group = "awesome"}),

awful.key({ modkey,           }, "l",     function() awful.tag.incmwfact( 0.05)          end,
{description = "increase master width factor", group = "layout"}),
awful.key({ modkey,           }, "h",     function() awful.tag.incmwfact(-0.05)          end,
{description = "decrease master width factor", group = "layout"}),
awful.key({ modkey, "Shift"   }, "h",     function() awful.tag.incnmaster( 1, nil, true) end,
{description = "increase the number of master clients", group = "layout"}),
awful.key({ modkey, "Shift"   }, "l",     function() awful.tag.incnmaster(-1, nil, true) end,
{description = "decrease the number of master clients", group = "layout"}),
awful.key({ modkey, "Control" }, "h",     function() awful.tag.incncol( 1, nil, true)    end,
{description = "increase the number of columns", group = "layout"}),
awful.key({ modkey, "Control" }, "l",     function() awful.tag.incncol(-1, nil, true)    end,
{description = "decrease the number of columns", group = "layout"}),
awful.key({ modkey,           }, "space", function() awful.layout.inc( 1)                end,
{description = "select next", group = "layout"}),
awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(-1)                end,
{description = "select previous", group = "layout"}),

awful.key({ modkey, "Control" }, "n",
function()
  local c = awful.client.restore()
  -- Focus restored client
  if c then
    client.focus = c
    c:raise()
  end
end,
{description = "restore minimized", group = "client"}),

-- Prompt
awful.key({modkey}, ";",
        function() awful.spawn("rofi -show run") end,
        {description = "run rofi to launcher a app", group = "rofi"}),
awful.key({modkey}, "'",
        function() awful.spawn("rofi -show window") end,
        {description = "switch a window", group = "rofi"}),
awful.key({modkey}, "/",
        function() awful.spawn("rofi -show ssh") end,
        {description = "ssh remote marchine", group = "rofi"}),
awful.key({modkey}, "x",
        function()
            awful.prompt.run({
                prompt       = "Lua% ",
                textbox      = awful.screen.focused().prompt.widget,
                exe_callback = function(input)
                    local ret = awful.util.eval(input)
                    naughty.notify({title = "Lua!", text = ret})
                end,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            })
        end,
        {description = "lua execute prompt", group = "prompt"}),
awful.key({modkey}, ",",
        function()
            awful.prompt.run({
                prompt       = "tran: ",
                textbox      = awful.screen.focused().prompt.widget,
                bg_cursor    = '#cccccc',
                exe_callback = function(input)
                    awful.spawn.easy_async_with_shell(("ldcv \"%s\""):format(input),  function(stdout)
                        local notify = awful.screen.focused().prompt.notify
                        if notify then
                            naughty.destroy(notify)
                        end
                        awful.screen.focused().prompt.notify = naughty.notify({
                                title = "Translation",
                                text = stdout,
                                timeout = 3,
                                hover_timeout = 60,
                                position = "top_left",
                            })
                    end)
                end,
                history_path = awful.util.get_cache_dir().."/translation.history"
            })
        end,
        {description = "translate a word", group = "prompt"}),
awful.key({modkey}, ".",
        function()
            awful.prompt.run({
                prompt       = "$ ",
                textbox      = awful.screen.focused().prompt.widget,
                bg_cursor    = '#cccccc',
                exe_callback = function(cmd)
                    awful.spawn.easy_async_with_shell(cmd, function(stdout)
                        local notify = awful.screen.focused().prompt.notify
                        if notify then
                            naughty.destroy(notify)
                        end
                        awful.screen.focused().prompt.notify = naughty.notify({
                                title = ("Output of the command: \n$ %s"):format(cmd),
                                text = stdout,
                                timeout = 3,
                                hover_timeout = 60,
                            })
                    end)
                end,
                completion_callback = awful.completion.shell,
                history_path = awful.util.get_cache_dir().."/command.history"
            })
        end,
        {description = "run a command simply", group = "prompt"}),

awful.key({}, "XF86AudioLowerVolume",
        function() awful.screen.focused().volume:drain(5) end,
        {description = "Turn Down volume 5%", group="Fn"}),
awful.key({"Control"}, "XF86AudioLowerVolume",
        function() awful.screen.focused().volume:mute() end,
        {description = "Mute volmue", group="Fn"}),
awful.key({}, "XF86AudioRaiseVolume",
        function() awful.screen.focused().volume:raise(5) end,
        {description = "Turn Up volume 5%", group="Fn"}),
awful.key({"Control"}, "XF86AudioRaiseVolume",
        function() awful.screen.focused().volume:unmute() end,
        {description = "Unmute volume", group="Fn"}),
awful.key({}, "XF86AudioMute",
        function() awful.screen.focused().volume:toggle() end,
        {description = "(Un)mute volume", group="Fn"}),
awful.key({}, "XF86MonBrightnessDown",
        function() awful.screen.brightness:drain(5) end,
        {description = "Turn Down Brightness 5%", group="Fn"}),
awful.key({"Control"}, "XF86MonBrightnessDown",
        function() awful.screen.brightness:min() end,
        {description = "Minimize Brightness", group="Fn"}),
awful.key({}, "XF86MonBrightnessUp",
        function() awful.screen.brightness:raise(5) end,
        {description = "Turn Up Brightness 5%", group="Fn"}),
awful.key({"Control"}, "XF86MonBrightnessUp",
        function() awful.screen.brightness:max() end,
        {description = "Maximize Brightness", group="Fn"}),

awful.key({}, "Print",
        function()
            os.execute("maim /tmp/screenshot-`date +%Y%m%d%H%M%S`.png")
        end,
        {description = "Screenshot to /tmp", group="screenshot"}),
awful.key({"Control",}, "Print",
        function()
            os.execute("maim -m 10 -s | xclip -t image/png -i -selection clipboard")
        end,
        {description = "select screenshot to clipboard", group="screenshot"})

-- Menubar
--awful.key({ modkey }, "p", function() menubar.show() end,
--        {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
        awful.key({modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
{description = "toggle fullscreen", group = "client"}),
awful.key({ modkey, "Shift"   }, "c", function(c) c:kill() end,
{description = "close", group = "client"}),
awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
{description = "toggle floating", group = "client"}),
awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
{description = "move to master", group = "client"}),
awful.key({ modkey,           }, "o",      function(c) c:move_to_screen()               end,
{description = "move to screen", group = "client"}),
awful.key({ modkey,           }, "t",      function(c) c.ontop = not c.ontop            end,
{description = "toggle keep on top", group = "client"}),
awful.key({ modkey,           }, "n",
function(c)
  -- The client currently has the input focus, so it cannot be
  -- minimized, since minimized clients can't have the focus.
  c.minimized = true
end ,
{description = "minimize", group = "client"}),
awful.key({ modkey,           }, "m",
function(c)
  c.maximized = not c.maximized
  c:raise()
end ,
{description = "(un)maximize", group = "client"}),
awful.key({ modkey, "Control" }, "m",
function(c)
  c.maximized_vertical = not c.maximized_vertical
  c:raise()
end ,
{description = "(un)maximize vertically", group = "client"}),
awful.key({ modkey, "Shift"   }, "m",
function(c)
  c.maximized_horizontal = not c.maximized_horizontal
  c:raise()
end ,
{description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local tags_cnt = #awful.screen.focused().tags
for i = 1, tags_cnt do
  globalkeys = gears.table.join(globalkeys,
  -- View tag only.
  awful.key({ modkey }, "#"..i+5+9,
  function()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
      tag:view_only()
    end
  end,
  {description = "view tag "..tags_label[i], group = "tag"}),
  -- Toggle tag display.
  awful.key({ modkey, "Control" }, "#"..i+5+9,
  function()
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
      awful.tag.viewtoggle(tag)
    end
  end,
  {description = "toggle tag "..tags_label[i], group = "tag"}),
  -- Move client to tag.
  awful.key({ modkey, "Shift" }, "#" ..i+5+9,
  function()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:move_to_tag(tag)
      end
    end
  end,
  {description = "move focused client to tag "..tags_label[i], group = "tag"}),
  -- Toggle tag on focused client.
  awful.key({ modkey, "Control", "Shift" }, "#"..i+5+9,
  function()
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:toggle_tag(tag)
      end
    end
  end,
  {description = "toggle focused client on tag " ..tags_label[i], group = "tag"})
  )
end

clientbuttons = gears.table.join(
        awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    { -- All clients will match this rule.
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            --opacity = 0.8,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",      -- Firefox addon DownThemAll.
                "copyq",    -- Includes session name in class.
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "xtightvncviewer",
            },
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            },
            type = {
                "dialog",
            },
        },
        properties = {
            floating = true,
            --placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            placement = function(d)
                -- First, place drawable object under mouse, then fix it to no part of it out off screen
                --awful.placement.under_mouse(d)
                --return awful.placement.no_offscreen(d)
                return awful.placement.align(d, {position = "centered",})
            end,
        },
    },

    -- Put some apps to the tag, Amuse.
    {
        rule_any = {
            class = {
                "netease-cloud-music",
            },
            -- command name
            instance = {
                "netease-cloud-music",
                "telegram-desktop", "telegram",
            },
        },
        properties = {
            -- tag = "Amuse"
            tag = "柒",
        },
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {
            type = {
                "normal", "dialog",
            }
        },
        properties = {
            titlebars_enabled = true,
        },
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
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
--[[
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
            awful.button({ }, 1, function()
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end))

    awful.titlebar(c):setup({
        layout = wibox.layout.align.horizontal,

        { -- Left
            layout  = wibox.layout.fixed.horizontal,
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
        },
        { -- Middle
            layout  = wibox.layout.flex.horizontal,
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
        },
        { -- Right
            layout = wibox.layout.fixed.horizontal(),
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
        },
    })
end)
--]]

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Start some app
local function run_once(cmd)
    local prg = cmd:match("([^%s]+)%s*.*$")
    popen(("pgrep -u $USER -x %s"):format(prg),
            function(_, code)
                if 0 ~= code then
                    awful.spawn(cmd)
                end
            end)
end
local apps = {
    "fcitx", "compton -b -CG", "nm-applet"
}
for _, i in pairs(apps) do
    run_once(i)
end

-- TODO start app from ~/.config/autostart[-script]

