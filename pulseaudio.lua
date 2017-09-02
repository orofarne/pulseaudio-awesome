-- handle all pulse audio calles async, and works only on the the default sink pulse reports
-- heavyly based on the work done at https://github.com/orofarne/pulseaudio-awesome

local awful = require( 'awful' )
local gears = require( 'gears' )
local string = require 'string'
local math = require 'math'
local tonumber = tonumber

local log = gears.debug.dump

module( 'pulseaudio' )

-- Get default sink
local default_sink = '0'
awful.spawn.easy_async_with_shell('pacmd dump |grep set-default-sink', function( def_sink )
  default_sink = string.match( def_sink, '^set%-default%-sink ([^$]+)' )
  log( 'found default sink named : ' .. default_sink )
end)

function volumeUp( cb )
    local step = 655 * 5
    awful.spawn.easy_async_with_shell('pacmd dump | grep set-sink-volume | grep ' .. default_sink, function(v)
      if v ~= nil then
        local volume = tonumber(string.sub(v, string.find(v, 'x') - 1))
        local newVolume = volume + step
        if newVolume > 65536 then
          newVolume = 65536
        end
        awful.spawn.easy_async('pacmd set-sink-volume ' .. default_sink .. ' '.. newVolume, function()
          if cb ~= nil then
            cb()
          end
        end)
      end
    end)
end

function volumeDown( cb )
    local step = 655 * 5
    awful.spawn.easy_async_with_shell('pacmd dump | grep set-sink-volume | grep ' .. default_sink, function(v)
      if v ~= nil then
        local volume = tonumber(string.sub(v, string.find(v, 'x') - 1))
        local newVolume = volume - step
        if newVolume < 0 then
            newVolume = 0
        end
        awful.spawn.easy_async('pacmd set-sink-volume ' .. default_sink .. ' ' .. newVolume, function()
          if cb ~= nil then
            cb()
          end
        end)
      end
    end)
end

function volumeMute( cb )
    awful.spawn.easy_async_with_shell('pacmd dump | grep set-sink-mute | grep ' .. default_sink, function( mute )
      local state = 'no'

      if string.find(mute, "no") then
          state = 'yes'
      end
      awful.spawn.easy_async('pacmd set-sink-mute ' .. default_sink .. ' ' .. state, function()
        if cb ~= nil then
            cb()
        end
      end)
    end)
end

function volumeInfo( cb )
    volmin = 0
    volmax = 65536

    local fmt = function( volume )
      return ' 𝅘𝅥𝅮  <span weight="bold">'..volume..'</span> '
    end

    awful.spawn.easy_async_with_shell('pacmd dump |grep set-sink-mute | grep ' .. default_sink, function( mute )
      if string.find(mute, "no") then
          awful.spawn.easy_async_with_shell('pacmd dump | grep set-sink-volume | grep ' .. default_sink, function( v )
            cb(fmt( math.floor(tonumber(string.sub(v, string.find(v, 'x')-1)) * 100 / volmax)..'%'))
          end)
      else
          cb(fmt( "✕" ))
      end
    end)
end
