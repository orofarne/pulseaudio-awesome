About
=====

Based on code from [awesome wiki](http://awesome.naquadah.org/wiki/Roultabie_volume_widget_for_PulseAudio)

On startup we now detect the default pulse audio sink, and use this for all other operations. (we may dream of making a selection one day).

All operations are now async, and uses ``awful.spawn`` famely as recommended, to minimize lagging.

We assume pango support (markup) in text widget, for simple markup.

Usage
=====

```lua
    require("pulseaudio")

    ...

    volumewidget = widget({
        type = "textbox",
        name = "volumewidget",
        align = "right"
    })
    
    -- common async functions, that also maintain widget
    local function paVolumeUp()
        pulseaudio.volumeUp(function()
            pulseaudio.volumeInfo( function( info )
                volumewidget.markup = info
            end)
        end)
    end

    local function paVolumeDown()
        pulseaudio.volumeDown(function()
            pulseaudio.volumeInfo( function( info )
                volumewidget.markup = info
            end)
        end)
    end

    local function paVolumeMute()
        pulseaudio.volumeMute(function()
            pulseaudio.volumeInfo(function( info )
                volumewidget.markup = info
            end)
        end)
    end

    -- Optionally enable mousewheel support
    volumewidget:buttons(awful.util.table.join(
      awful.button({ }, 4, paVolumeUp ),
      awful.button({ }, 5, paVolumeDown )
    ))
    -- Thanks to elementalvoid
    
    volumewidget.text = pulseaudio.volumeInfo()
    volumetimer = timer({ timeout = 30 })
    volumetimer:add_signal("timeout", function() 
         pulseaudio.volumeInfo(function( info )
            volumewidget.markup = info
         end) 
    end)
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

        awful.key({}, "XF86AudioMute", paVolumeMute),
        awful.key({}, "XF86AudioLowerVolume", paVolumeDown),
        awful.key({}, "XF86AudioRaiseVolume", paVolumeUp),

        ...
    )
```