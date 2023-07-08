local dpi = require"beautiful.xresources".apply_dpi
local theme_assets = require("beautiful.theme_assets")

local theme = {}

theme.border_width      = dpi(3)
theme.border_normal     = "#333333"
theme.border_focus      = "#1dd6ff"
theme.fg_normal         = "#caccfa"
theme.bg_normal         = "#1A1B26"
theme.bg_widget         = "#282e49"
theme.taglist_bg_focus  = "#caccfa"
theme.taglist_fg_focus  = "#282e49"
theme.taglist_fg_empty  = "#caccfa"


theme.foreground_green  = "#41ff77"
theme.foreground_pink   = "#ffaaff"
theme.foreground_blue   = "#1dd6ff"

theme.useless_gap = dpi(10)
theme.font = "JetBrainsMono Nerd Font Regular 15"

local taglist_square_size = dpi(10)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.bg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

return theme
