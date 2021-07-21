package.loaded["awful.hotkeys_popup.keys.tmux"]={}
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
--local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load Debian menu entries
-- local debian = require("debian.menu")
--local has_fdo, freedesktop = pcall(require, "freedesktop")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err) })
		in_error = false
	end)
end

-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/mytheme.lua")
-- Multiple monitor helper
local theme = require("mytheme")
local xrandr=require("xrandr")
local charitable = require("charitable")
local default_layout=2
--awful.spawn.with_shell("~/.screenlayout/primary.sh")

-- This is used later as the default terminal and editor to run.
TERMINAL = "kitty"
GUIFILEMANAGER = "pcmanfm"
BROWSER = "brave"
EDITOR = os.getenv("EDITOR") or "editor"
EDITOR_CMD = TERMINAL .. " -e " .. EDITOR

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
MODKEY = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}

-- Keyboard map indicator and switcher
MYKEYBOARDLAYOUT = awful.widget.keyboardlayout()

-- Set up monitors

-- Create a wibox for each screen and add it
local logout_popup = require('awesome-wm-widgets.logout-popup-widget.logout-popup')
local my_volume = require('my-widgets.volume')
local my_battery = require('my-widgets.battery')
local my_date = require('my-widgets.date')
--local my_pack = require('my-widgets.pack')
local my_weather = require('my-widgets.weather')
local my_music_info = require('my-widgets.music')
--local sep = require('my-widgets.sep')
local pad = require('my-widgets.pad')

local tags = charitable.create_tags(
	{"[term]","[www]","[work]","[chat]","[music]","[email]"},
	{
		awful.layout.layouts[default_layout],
		awful.layout.layouts[default_layout],
		awful.layout.layouts[default_layout],
		awful.layout.layouts[default_layout],
		awful.layout.layouts[default_layout],
		awful.layout.layouts[default_layout],
	}
)

local function makeMainScreenWiBar()
	local thisscreen=screen[1]


	local bar=awful.wibar({
		position="top",
		screen=thisscreen,
		width=thisscreen.geometry.width,
		})

	thisscreen.scratch = awful.tag.add('scratch-' .. thisscreen.index, {})
	local tray = wibox.widget.systray()
	tray:set_screen(thisscreen)
	local mytaglist = awful.widget.taglist {
		screen  = thisscreen,
		filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
    style = {
      shape = theme.tag_shape,
      spacing = 5,
    },
		source = function(screen, args) return tags end,
	}

bar:setup{
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			tray,
			mytaglist,
			mypromptbox,
		},
		nil,
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			my_music_info, pad,
			my_weather, pad,
			-- my_pack, sep,
			my_date, pad,
			my_volume, pad,
			my_battery, pad,
		},
	}
end

local function makeSecondScreenWibar()
	local thisscreen=screen[screen.count()]
	local bar=awful.wibar({
		position="top",
		screen=thisscreen,
		width=thisscreen.geometry.width,
		})

	thisscreen.scratch = awful.tag.add('scratch-' .. thisscreen.index, {})
	local mytaglist = awful.widget.taglist {
		screen  = thisscreen,
		filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
    style = {
      shape = theme.tag_shape,
      spacing = 7,
    },
		source = function(screen, args) return tags end,
	}
	bar:setup{
		layout=wibox.layout.stack,
		{
			layout=wibox.layout.fixed.horizontal,
			mytaglist
		},
		{
			mytextclock,
			valign="center",
			halign="center",
			layout=wibox.container.place
		}
	}
end

makeMainScreenWiBar()
makeSecondScreenWibar()

globalkeys = gears.table.join(
  awful.key({ MODKEY, }, "s",      hotkeys_popup.show_help,
    {description="show help", group="awesome"}),

  awful.key({ MODKEY, }, "Left",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),

  awful.key({ MODKEY, }, "Right",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),

  awful.key({ MODKEY, }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

  awful.key({ MODKEY, }, "j",
    function ()
      awful.client.focus.byidx( 1)
    end,
    {description = "focus next by index", group = "client"}
  ),

  awful.key({ MODKEY, }, "k",
    function ()
      awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
  ),

  -- Layout manipulation
  awful.key({ MODKEY, "Shift" }, "j", function () awful.client.swap.byidx(  1)    end,
    {description = "swap with next client by index", group = "client"}),

  awful.key({ MODKEY, "Shift" }, "k", function () awful.client.swap.byidx( -1)    end,
    {description = "swap with previous client by index", group = "client"}),

  awful.key({ MODKEY, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
    {description = "focus the next screen", group = "screen"}),

  awful.key({ MODKEY, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
    {description = "focus the previous screen", group = "screen"}),

  awful.key({ MODKEY, }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),

  awful.key({ MODKEY, }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "go back", group = "client"}),

  -- Standard program

  awful.key({ MODKEY, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),

  awful.key({ MODKEY, "Shift" }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),

  awful.key({ MODKEY, }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),

  awful.key({ MODKEY, }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),

  awful.key({ MODKEY, "Shift" }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),

  awful.key({ MODKEY, "Shift" }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),

  awful.key({ MODKEY, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    {description = "increase the number of columns", group = "layout"}),

  awful.key({ MODKEY, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    {description = "decrease the number of columns", group = "layout"}),

  awful.key({ MODKEY, }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),

  awful.key({ MODKEY, "Shift" }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),

  awful.key({ MODKEY, "Control" }, "n",
    function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", {raise = true}
        )
      end
    end,
    {description = "restore minimized", group = "client"}),

-- Dmenu
awful.key({ MODKEY }, "r",     function ()
  awful.util.spawn("rofi -show run") end,
  {description = "run rofi", group = "launcher"}),

awful.key({ MODKEY, "Control", "Shift" }, "m", function() xrandr.xrandr() end,
  {description = "cycle through multimonitor", group = "utility"}),

awful.key({ MODKEY, }, "Return", function () awful.spawn(TERMINAL) end,
  {description = "open a terminal", group = "software"}),

awful.key({ MODKEY }, "b",     function ()
  awful.util.spawn(BROWSER)
  end,
  {description = "Browser", group = "software"}),

awful.key({ MODKEY }, "t",     function ()
  awful.util.spawn("thunderbird")
  end,
  {description = "Thunderbird", group = "software"}),

awful.key({ MODKEY }, "e",     function ()
  awful.util.spawn("emacs")
  end,
  {description = "Emacs", group = "software"}),

awful.key({ MODKEY, "Shift" }, "m",     function ()
  awful.util.spawn(BROWSER.."https://accounts.spotify.com/en/login?continue=https:%2F%2Fopen.spotify.com%2F")
  end,
  {description = "Spotify Web Client", group = "software"}),

awful.key({ MODKEY }, "d",     function ()
  awful.util.spawn("ferdi")
  end,
  {description = "Ferdi - Messaging", group = "software"}),

awful.key({ MODKEY, "Control" }, "f",     function ()
  awful.spawn("kitty -e ranger") end,
  {description = "Ranger", group = "software"}),

awful.key({ MODKEY, }, "f",     function ()
  awful.spawn(GUIFILEMANAGER) end,
  {description = "File Manager", group = "software"}),

awful.key({ MODKEY }, "a",     function ()
  awful.spawn("pavucontrol") end,
  {description = "Audio Controls", group = "software"}),

awful.key({ MODKEY , "Control" }, "b",     function ()
  awful.spawn.with_shell("feh --recursive --randomize --bg-fill ~/wallpapers") end,
  {description = "Change Background", group = "utility"}),

awful.key({ MODKEY }, "p",     function ()
  logout_popup.launch{bg_color='#44475a',text_color='#f8f8f2',accent_color='#ffffff'} end,
  {description = "Show Shutdown Menu", group = "awesome"}),

awful.key({ MODKEY }, "x",
  function ()
    awful.prompt.run {
      prompt       = "Run Lua code: ",
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
  end,
  {description = "lua execute prompt", group = "awesome"}),

awful.key({ }, "XF86AudioStop" ,     function ()
    awful.util.spawn("firefox https://accounts.spotify.com/en/login?continue=https:%2F%2Fopen.spotify.com%2F") end,
    {description = "Open Spotify", group = "Audio"}),

  awful.key({ }, "XF86AudioPrev" ,     function ()
  awful.spawn.with_shell("playerctl previous", false) end,
    {description = "Previous Track", group = "Audio"}),

  awful.key({ }, "XF86AudioNext" ,     function ()
  awful.spawn.with_shell("playerctl next", false) end,
    {description = "Next Track", group = "Audio"}),

  awful.key({ }, "XF86AudioPlay" ,     function ()
  awful.spawn.with_shell("playerctl play-pause", false) end,
    {description = "Play/Pause", group = "Audio"}),

  awful.key({ }, "XF86AudioRaiseVolume" ,     function ()
  awful.spawn.with_shell("pamixer -i 2", false) end,
    {description = "Increase Volume", group = "Audio"}),

  awful.key({ }, "XF86AudioLowerVolume" ,     function ()
      awful.spawn.with_shell("pamixer -d 2") end,
    {description = "Decrease Volume", group = "Audio"}),

  awful.key({ }, "XF86AudioMute" ,     function ()
  awful.spawn.with_shell("pamixer -t", false) end,
    {description = "Mute Volume", group = "Audio"})
)

clientkeys = gears.table.join(

	awful.key({ MODKEY, "Shift" }, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}),

	awful.key({ MODKEY }, "q",      function (c) c:kill()                         end,
		{description = "close", group = "client"}),

	awful.key({ MODKEY, "Control" }, "space",  awful.client.floating.toggle                     ,
		{description = "toggle floating", group = "client"}),

	awful.key({ MODKEY, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
		{description = "move to master", group = "client"}),

	awful.key({ MODKEY,           }, "o",      function (c) c:move_to_screen()               end,
		{description = "move to screen", group = "client"}),

	awful.key({ MODKEY,           }, "t",      function (c) c.ontop = not c.ontop            end,
		{description = "toggle keep on top", group = "client"}),

	awful.key({ MODKEY,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end ,
		{description = "minimize", group = "client"}),

	awful.key({ MODKEY,           }, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end ,
		{description = "(un)maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		-- View tag only.
		awful.key({ MODKEY }, "#" .. i + 9,
			function () charitable.select_tag(tags[i], awful.screen.focused()) end,
			{description = "view tag #"..i, group = "tag"}),
		-- Toggle tag display.
		awful.key({ MODKEY, "Control" }, "#" .. i + 9,
			function ()
				charitable.toggle_tag(tags[i], awful.screen.focused())
			end,
			{description = "toggle tag #" .. i, group = "tag"}),
		-- Move client to tag.
		awful.key({ MODKEY, "Shift" }, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			{description = "move focused client to tag #"..i, group = "tag"}),
		-- Toggle tag on focused client.
		awful.key({ MODKEY, "Control", "Shift" }, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			{description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end

clientbuttons = gears.table.join(
	awful.button({ }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
	end),
	awful.button({ MODKEY }, 1, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.move(c)
	end),
	awful.button({ MODKEY }, 3, function (c)
		c:emit_signal("request::activate", "mouse_click", {raise = true})
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
		properties = { border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen
		}
	},

	{ rule = { class = "Thunderbird" },
		properties = { tag = "[email]" } },

	{ rule = { class = "Brave-browser" },
		properties = { tag = "[www]" } },

	{ rule = { class = "Spotify" },
		properties = { tag = "[music]" } },

	{ rule_any = {
		class = {
			"discord"
		} },
		properties = { tag = "[chat]" } },

	-- Floating clients.
	{ rule_any = {
		instance = {
			"DTA",  -- Firefox addon DownThemAll.
			"copyq",  -- Includes session name in class.
			"pinentry",
		},
		class = {
			"Arandr",
			"Blueman-manager",
			"Gpick",
			"Kruler",
			"MessageWin",  -- kalarm.
			"Sxiv",
			"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			"Wpa_gui",
			"veromix",
			"xtightvncviewer"},

		-- Note that the name property shown in xprop might be set slightly after creation of the client
		-- and the name shown there might not match defined rules here.
		name = {
			"Event Tester",  -- xev.
		},
		role = {
			"AlarmWindow",  -- Thunderbird's calendar.
			"ConfigManager",  -- Thunderbird's about:config.
			"pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
		}
	}, properties = { floating = true }},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = {type = { "normal", "dialog" }
	}, properties = { titlebars_enabled = false }
	},

	-- Set Firefox to always map on the tag named "2" on screen 1.
	-- { rule = { class = "Firefox" },
	--   properties = { screen = 1, tag = "2" } },
}
-- }}}


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
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

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

tag.connect_signal("request::screen", function(t)
	t.selected = false
	for s in capi.screen do
		if s ~= t.screen then
			t.screen = s
			return
		end
	end
end)


beautiful.notification_font = theme.font
beautiful.notification_bg = theme.bg_focus
beautiful.notification_max_width = 300
beautiful.notification_max_height = 100
beautiful.notification_icon_size = 0.9*beautiful.notification_max_height


-- Autostart Applications
awful.spawn.with_shell("feh  --bg-fill ~/wallpapers/custom/gimp.png")

awful.tag.history.restore = function() end
