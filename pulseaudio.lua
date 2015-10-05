local tonumber = tonumber
local awful = require("awful")

module("pulseaudio")

function volumeUp()
	if tonumber(awful.util.pread("pacmd list-sinks | awk -F'[[:blank:]:%]+' 'NF == 16 && $2 == \"volume\" { print $6; exit }'")) < 100 then
		awful.util.spawn("pactl set-sink-volume 0 +5%", false)
	end
end

function volumeDown()
	awful.util.spawn("pactl set-sink-volume 0 -5%", false)
end

function volumeMute()
	awful.util.spawn("pactl set-sink-mute 0 toggle", false)
end

function volumeInfo()
	return awful.util.pread("pacmd list-sinks | awk '/muted: /{ print $2 }'") == "yes" and "00%" or awful.util.pread("pacmd list-sinks | awk -F'[[:blank:]:]+' 'NF == 16 && $2 == \"volume\" { print $6; exit }'")
end
