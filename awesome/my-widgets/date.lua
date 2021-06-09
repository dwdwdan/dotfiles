local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")
local awful = require("awful")

local date_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local date_widget = wibox.widget.background()
date_widget:set_widget(date_text)

date_widget:set_bg(theme.bg_widget)
date_widget:set_fg(theme.fg_widget)

watch("date +'%a %F %H:%M'",30,function(widget, stdout, stderr, exitreason, exitcode)
	date_text:set_text("📆 "..stdout)
end, date_widget)

local open_cal = function(lx, ly, button, mods, find_widgets_result)
	awful.spawn.with_shell("thunderbird")
end

date_widget:connect_signal("button::press",open_cal)

return date_widget
