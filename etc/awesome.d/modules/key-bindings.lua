local gears = require("gears")
local awful = require("awful")

-- global keys --
globalkeys = gears.table.join(

    -- help
    --awful.key({ modkey }, "s", hotkeys_popup.show_help,
    --{description="show help", group="awesome"}),

    -- focus
    awful.key({ modkey, }, "j", function ()
      awful.client.focus.global_bydirection("down")
      if client.focus then client.focus:raise() end
    end, { description = "focus down", group = "client" }),

    awful.key({ modkey, }, "k", function ()
      awful.client.focus.global_bydirection("up")
      if client.focus then client.focus:raise() end
    end, { description = "focus up", group = "client" }),

    awful.key({ modkey, }, "h", function ()
      awful.client.focus.global_bydirection("left")
      if client.focus then client.focus:raise() end
    end, { description = "focus left", group = "client" }),

    awful.key({ modkey, }, "l", function ()
      awful.client.focus.global_bydirection("right")
      if client.focus then client.focus:raise() end
    end, { description = "focus right", group = "client" }),

    -- move
    awful.key({ modkey, "Shift" }, "j", function ()
      awful.client.swap.global_bydirection("down")
    end, { description = "swap down", group = "client" }),

    awful.key({ modkey, "Shift" }, "k", function ()
      awful.client.swap.global_bydirection("up")
    end, { description = "swap up", group = "client" }),

    awful.key({ modkey, "Shift" }, "h", function ()
      awful.client.swap.global_bydirection("left")
    end, { description = "swap left", group = "client" }),

    awful.key({ modkey, "Shift" }, "l", function ()
      awful.client.swap.global_bydirection("right")
    end, { description = "swap right", group = "client" }),

    -- red-control
    awful.key({ altkey }, "j", function ()
      awful.spawn("red-control -500 0")
    end, {description = "temperature down", group = "red-control"}),

    awful.key({ altkey }, "k", function ()
      awful.spawn("red-control 500 0")
    end, {description = "temperature up", group = "red-control"}),

    awful.key({ altkey, shiftkey }, "j", function ()
      awful.spawn("red-control 0 -1")
    end, {description = "brightness down", group = "red-control"}),

    awful.key({ altkey, shiftkey }, "k", function ()
      awful.spawn("red-control 0 1")
    end, {description = "brightness up", group = "red-control"}),

    -- Layout manipulation
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    awful.key({ modkey }, "Tab", function ()
      awful.client.focus.history.previous()
      if client.focus then
          client.focus:raise()
      end
    end, {description = "go back", group = "client"}),

    -- launch
    -- TODO
    awful.key({ modkey }, "Return", function ()
      awful.spawn(terminal)
    end, {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),


    awful.key({ modkey }, "space", function ()
      awful.spawn("keyboardswitch")
    end, {description = "switch language", group = ""})
)

-- client keys --

clientkeys = gears.table.join(
    awful.key({ modkey }, "m", function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end, {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey }, "w", function (c)
      c:kill()
    end, {description = "close", group = "client"}),

    awful.key({ modkey }, "f", awful.client.floating.toggle,
    {description = "toggle floating", group = "client"})
)

-- tag keys --

clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
  end),

  awful.button({ modkey }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.move(c)
  end),

  awful.button({ modkey }, 3, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.resize(c)
  end)
)

root.keys(globalkeys)
