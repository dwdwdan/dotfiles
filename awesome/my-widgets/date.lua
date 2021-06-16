local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")
local awful = require("awful")
shape =require("gears.shape")

local date_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}


local date_widget = wibox.widget {
  {
    {
      widget = date_text
    },
    left = 10,
    right = 10,
    widget = wibox.container.margin,
  },
  bg =theme.bg_widget,
  fg = theme.fg_widget,
  shape = theme.widget_shape,
  widget=wibox.container.background,
}

watch("date +'%a %F %H:%M'",30,function(widget, stdout, stderr, exitreason, exitcode)
	date_text:set_text("📆 "..stdout)
end, date_widget)

local open_cal = function(lx, ly, button, mods, find_widgets_result)
	awful.spawn.with_shell("thunderbird")
end

date_widget:connect_signal("button::press",open_cal)

return date_widget
