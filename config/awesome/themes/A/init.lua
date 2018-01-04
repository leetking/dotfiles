local NAME = "A"

local gears = require("gears")
local THEMES   = gears.filesystem.get_dir("config").."themes/"
local LOCATION = THEMES..NAME.."/"

local Theme = {}

Theme.wallpaper = LOCATION.."wallpaper"
-- {{{ Styles
Theme.font = "sans 8"

-- {{{ Colors
Theme.fg_normal  = "#DCDCCC"
Theme.fg_focus   = "#F0DFAF"
Theme.fg_urgent  = "#CC9393"
Theme.bg_normal  = "#3F3F3F"
Theme.bg_focus   = "#1E2320"
Theme.bg_urgent  = "#3F3F3F"
Theme.bg_systray = Theme.bg_normal
-- }}}

-- {{{ Borders
Theme.useless_gap   = 0
Theme.border_width  = 0
Theme.border_normal = "#3F3F3F"
Theme.border_focus  = "#6F6F6F"
Theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
Theme.titlebar_bg_focus  = "#3F3F3F"
Theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--Theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--Theme.fg_widget        = "#AECF96"
--Theme.fg_center_widget = "#88A175"
--Theme.fg_end_widget    = "#FF5656"
--Theme.bg_widget        = "#494B4F"
--Theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
Theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
Theme.menu_height = 15
Theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
Theme.taglist_squares_sel   = LOCATION.."taglist/squarefz.png"
Theme.taglist_squares_unsel = LOCATION.."taglist/squarez.png"
--Theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
Theme.awesome_icon           = LOCATION.."logo"
Theme.menu_submenu_icon      = LOCATION.."default/submenu.png"
-- }}}

-- {{{ Layout
Theme.layout_tile       = LOCATION.."layouts/tile.png"
Theme.layout_tileleft   = LOCATION.."layouts/tileleft.png"
Theme.layout_tilebottom = LOCATION.."layouts/tilebottom.png"
Theme.layout_tiletop    = LOCATION.."layouts/tiletop.png"
Theme.layout_fairv      = LOCATION.."layouts/fairv.png"
Theme.layout_fairh      = LOCATION.."layouts/fairh.png"
Theme.layout_spiral     = LOCATION.."layouts/spiral.png"
Theme.layout_dwindle    = LOCATION.."layouts/dwindle.png"
Theme.layout_max        = LOCATION.."layouts/max.png"
Theme.layout_fullscreen = LOCATION.."layouts/fullscreen.png"
Theme.layout_magnifier  = LOCATION.."layouts/magnifier.png"
Theme.layout_floating   = LOCATION.."layouts/floating.png"
Theme.layout_cornernw   = LOCATION.."layouts/cornernw.png"
Theme.layout_cornerne   = LOCATION.."layouts/cornerne.png"
Theme.layout_cornersw   = LOCATION.."layouts/cornersw.png"
Theme.layout_cornerse   = LOCATION.."layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
Theme.titlebar_close_button_focus  = LOCATION.."titlebar/close_focus.png"
Theme.titlebar_close_button_normal = LOCATION.."titlebar/close_normal.png"

Theme.titlebar_minimize_button_normal = LOCATION.."default/titlebar/minimize_normal.png"
Theme.titlebar_minimize_button_focus  = LOCATION.."default/titlebar/minimize_focus.png"

Theme.titlebar_ontop_button_focus_active  = LOCATION.."titlebar/ontop_focus_active.png"
Theme.titlebar_ontop_button_normal_active = LOCATION.."titlebar/ontop_normal_active.png"
Theme.titlebar_ontop_button_focus_inactive  = LOCATION.."titlebar/ontop_focus_inactive.png"
Theme.titlebar_ontop_button_normal_inactive = LOCATION.."titlebar/ontop_normal_inactive.png"

Theme.titlebar_sticky_button_focus_active  = LOCATION.."titlebar/sticky_focus_active.png"
Theme.titlebar_sticky_button_normal_active = LOCATION.."titlebar/sticky_normal_active.png"
Theme.titlebar_sticky_button_focus_inactive  = LOCATION.."titlebar/sticky_focus_inactive.png"
Theme.titlebar_sticky_button_normal_inactive = LOCATION.."titlebar/sticky_normal_inactive.png"

Theme.titlebar_floating_button_focus_active  = LOCATION.."titlebar/floating_focus_active.png"
Theme.titlebar_floating_button_normal_active = LOCATION.."titlebar/floating_normal_active.png"
Theme.titlebar_floating_button_focus_inactive  = LOCATION.."titlebar/floating_focus_inactive.png"
Theme.titlebar_floating_button_normal_inactive = LOCATION.."titlebar/floating_normal_inactive.png"

Theme.titlebar_maximized_button_focus_active  = LOCATION.."titlebar/maximized_focus_active.png"
Theme.titlebar_maximized_button_normal_active = LOCATION.."titlebar/maximized_normal_active.png"
Theme.titlebar_maximized_button_focus_inactive  = LOCATION.."titlebar/maximized_focus_inactive.png"
Theme.titlebar_maximized_button_normal_inactive = LOCATION.."titlebar/maximized_normal_inactive.png"
-- }}}

-- }}} Icons

local partially_rounded_rect = gears.shape.partially_rounded_rect
client.connect_signal("manage", function(c)
    c.shape = function(cr, w, h)
        partially_rounded_rect(cr, w, h, true, true, false, false, 5)
    end
end)
client.connect_signal("focus", function(c)
    c.border_color = Theme.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = Theme.border_normal
end)

return Theme

