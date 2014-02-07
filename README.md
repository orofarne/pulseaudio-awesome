About
=====

Based on code from [awesome wiki](http://awesome.naquadah.org/wiki/Roultabie_volume_widget_for_PulseAudio)

Usage
=====

    require("pulseaudio")

    ...

    volumewidget = widget({
        type = "textbox",
        name = "volumewidget",
        align = "right"
    })
    
    -- Optionally enable mousewheel support
    volumewidget:buttons(awful.util.table.join(
      awful.button({ }, 4, function() pulseaudio.volumeUp(); volumewidget.text = pulseaudio.volumeInfo() end),
      awful.button({ }, 5, function() pulseaudio.volumeDown(); volumewidget.text = pulseaudio.volumeInfo() end)
    ))
    -- Thanks to elementalvoid
    
    volumewidget.text = pulseaudio.volumeInfo()
    volumetimer = timer({ timeout = 30 })
    volumetimer:add_signal("timeout", function() volumewidget.text = pulseaudio.volumeInfo() end)
    volumetimer:start()

    ...

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {

        ...

        volumewidget,

        ...
    }

    ...

    globalkeys = awful.util.table.join(globalkeys,
        ...

        awful.key({}, "XF86AudioMute", function() pulseaudio.volumeMute(); volumewidget.text = pulseaudio.volumeInfo() end),
        awful.key({}, "XF86AudioLowerVolume", function() pulseaudio.volumeDown(); volumewidget.text = pulseaudio.volumeInfo() end),
        awful.key({}, "XF86AudioRaiseVolume", function() pulseaudio.volumeUp(); volumewidget.text = pulseaudio.volumeInfo() end),

        ...
    )

