local wibox = require("wibox")
local watch = require("awful.widget.watch")
local awful = require("awful")
local theme = require("mytheme")
require("weather_conf")

local weather_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local weather_widget = wibox.widget {
  {
    {
      widget = weather_text
    },
    left = 10,
    right = 10,
    widget = wibox.container.margin,
  },
  bg = theme.bg_widget,
  fg = theme.fg_widget,
  shape = theme.widget_shape,
  widget = wibox.container.background,
}

watch("curl 'https://api.openweathermap.org/data/2.5/weather?id="..city.."&APPID="..api_key.."&units=metric'",600,function(widget, stdout, stderr, exitreason, exitcode)
	local temp = string.match(stdout,"\"temp\":%d+")
	temp = temp:sub(8)
	weather_text:set_text("🌥 "..temp.."℃")
end, weather_widget)

local open_weather = function(lx, ly, button, mods, find_widgets_result)
	awful.spawn("firefox https://openweathermap.org/city/"..city)
end

weather_widget:connect_signal("button::press",open_weather)

return weather_widget
