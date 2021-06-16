local wibox = require("wibox")
local watch = require("awful.widget.watch")
local theme = require("mytheme")

local vol_text = wibox.widget{
	font = theme.mono_font,
	widget = wibox.widget.textbox,
}

local vol_widget = wibox.widget {
  {
    {
      widget = vol_text
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
watch("pamixer --get-volume",1,function(widget, stdout, stderr, exitreason, exitcode)
  vol_percent = " "..stdout
	if(tonumber(vol_percent) < 100) then
		vol_percent = " "..vol_percent
	end
	if(tonumber(vol_percent) < 10) then
		vol_percent = " "..vol_percent
	end
	if(vol_percent == "100") then
		vol_percent = "🔊"..vol_percent
	elseif(vol_percent =="0") then
		vol_percent = "🔈"..vol_percent
	else
		vol_percent = "🔉"..vol_percent
	end
	vol_text:set_text(vol_percent)
end, vol_widget)

return vol_widget
