local NAME = "A"

local gears = require("gears")
local randomseed = math.randomseed
local random     = math.random
local THEMES     = gears.filesystem.get_dir("config").."themes/"
--local xresources = require("beautiful.xresources")
--local dpi        = xresources.apply_dpi
local LOCATION   = THEMES..NAME.."/"

local theme = {}

local function popen(cmd, fun)
    local file = io.popen(cmd, "r")
    local out
    out = file:read("*a")
    local _, _, code = file:close()
    return fun(out, code)
end

local wallpapers = {}
randomseed(math.floor(os.time()+os.clock()*1000))
popen("ls "..LOCATION.."wallpapers/", function(stdout)
    for file in stdout:gmatch("[^%s]+") do
        table.insert(wallpapers, LOCATION.."wallpapers/"..file)
    end
end)
local function set_wallpaper(s)
    gears.wallpaper.maximized(wallpapers[random(#wallpapers)], s, false)
    --gears.wallpaper.maximized(LOCATION.."wallpaper", s, false)
    gears.timer({
        timeout = 5*60,
        autostart = true,
        callback = function()
            gears.wallpaper.maximized(wallpapers[random(#wallpapers)], s, false)
        end,
    })
end
--theme.wallpaper = set_wallpaper
theme.wallpaper = LOCATION.."wallpaper"

-- {{{ Styles
theme.font = "sans 8"

-- {{{ Colors
theme.fg_normal  = "#DCDCCC"
theme.fg_focus   = "#FFD458"
theme.fg_urgent  = "#CC9393"
theme.bg_normal  = "#3F3F3F99"
theme.bg_focus   = "#1E232099"
theme.bg_urgent  = "#3F3F3F99"
theme.bg_systray = theme.bg_normal
theme.notification_bg = "#3F3F3FF0"
theme.hotkeys_bg = "#3F3F3FF0"
--theme.systray_icon_spacing = dpi(1)
-- }}}

-- {{{ Borders
theme.useless_gap   = 0
theme.border_width  = 0
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#6F6F6F"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 15
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = LOCATION.."taglist/squarefz.png"
theme.taglist_squares_unsel = LOCATION.."taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = LOCATION.."logo"
-- theme.menu_submenu_icon      = LOCATION.."default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = LOCATION.."layouts/tile.png"
theme.layout_tileleft   = LOCATION.."layouts/tileleft.png"
theme.layout_tilebottom = LOCATION.."layouts/tilebottom.png"
theme.layout_tiletop    = LOCATION.."layouts/tiletop.png"
theme.layout_fairv      = LOCATION.."layouts/fairv.png"
theme.layout_fairh      = LOCATION.."layouts/fairh.png"
theme.layout_spiral     = LOCATION.."layouts/spiral.png"
theme.layout_dwindle    = LOCATION.."layouts/dwindle.png"
theme.layout_max        = LOCATION.."layouts/max.png"
theme.layout_fullscreen = LOCATION.."layouts/fullscreen.png"
theme.layout_magnifier  = LOCATION.."layouts/magnifier.png"
theme.layout_floating   = LOCATION.."layouts/floating.png"
theme.layout_cornernw   = LOCATION.."layouts/cornernw.png"
theme.layout_cornerne   = LOCATION.."layouts/cornerne.png"
theme.layout_cornersw   = LOCATION.."layouts/cornersw.png"
theme.layout_cornerse   = LOCATION.."layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = LOCATION.."titlebar/close_focus.png"
theme.titlebar_close_button_normal = LOCATION.."titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = LOCATION.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = LOCATION.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = LOCATION.."titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = LOCATION.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = LOCATION.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = LOCATION.."titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = LOCATION.."titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = LOCATION.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = LOCATION.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = LOCATION.."titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = LOCATION.."titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = LOCATION.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = LOCATION.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = LOCATION.."titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = LOCATION.."titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = LOCATION.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = LOCATION.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = LOCATION.."titlebar/maximized_normal_inactive.png"
-- }}}

-- }}} Icons

--[[
local partially_rounded_rect = gears.shape.partially_rounded_rect
client.connect_signal("manage", function(c)
    c.shape = function(cr, w, h)
        partially_rounded_rect(cr, w, h, true, true, false, false, 5)
    end
end)
--]]
client.connect_signal("focus", function(c)
    c.border_color = theme.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = theme.border_normal
end)

return theme

