local io = io
local math = math
local tonumber = tonumber
local tostring = tostring
local string = string

module("pulseaudio")

function volumeUp()
    local step = 655 * 5
    local f = io.popen("pacmd dump |grep set-sink-volume")
    local v = f:read()
    local volume = tonumber(string.sub(v, string.find(v, 'x') - 1))
    local newVolume = volume + step
    if newVolume > 65536 then
        newVolume = 65536
    end
    io.popen("pacmd set-sink-volume 0 "..newVolume)
    f:close()
end

function volumeDown()
    local step = 655 * 5
    local f = io.popen("pacmd dump |grep set-sink-volume")
    local v = f:read()
    local volume = tonumber(string.sub(v, string.find(v, 'x') - 1))
    local newVolume = volume - step
    if newVolume < 0 then
        newVolume = 0
    end
    io.popen("pacmd set-sink-volume 0 "..newVolume)
    f:close()
end

function volumeMute()
    local g = io.popen("pacmd dump |grep set-sink-mute")
    local mute = g:read()
    if string.find(mute, "no") then
        io.popen("pacmd set-sink-mute 0 yes")
    else
        io.popen("pacmd set-sink-mute 0 no")
    end
    g:close()
end

function volumeInfo()
    volmin = 0
    volmax = 65536
    local f = io.popen("pacmd dump |grep set-sink-volume")
    local g = io.popen("pacmd dump |grep set-sink-mute")
    local v = f:read()
    local mute = g:read()
    if mute ~= nil and string.find(mute, "no") then
        volume = math.floor(tonumber(string.sub(v, string.find(v, 'x')-1)) * 100 / volmax).." %"
    else
        volume = "✕"
    end
    f:close()
    g:close()
    return "𝅘𝅥𝅮  "..volume
end
