local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")

local sep_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local sep_widget = wibox.widget.background()
sep_widget:set_widget(sep_text)

sep_widget:set_bg(theme.bg_widget)
sep_widget:set_fg(theme.fg_widget)

sep_text:set_text(" | ")

return sep_widget
