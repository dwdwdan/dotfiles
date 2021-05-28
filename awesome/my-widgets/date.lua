local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")

local date_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local date_widget = wibox.widget.background()
date_widget:set_widget(date_text)

date_widget:set_bg(theme.bg_widget)
date_widget:set_fg(theme.fg_widget)

watch("date +'%F %H:%M'",30,function(widget, stdout, stderr, exitreason, exitcode)
	date_text:set_text("📆 "..stdout)
end, date_widget)

return date_widget
