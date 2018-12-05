local io = io
local math = math
local tonumber = tonumber
local tostring = tostring
local string = string

module("pulseaudio")

function getSink()
    local default_sink = io.popen("pacmd dump |grep set-default-sink")
    local default_sink_string = default_sink:read()
    local sink = string.sub(default_sink_string, string.find(default_sink_string, ' ') + 1)
    return sink
end

function volumeUp()
    local sink = getSink()
    local step = 655 * 5
    local f = io.popen("pacmd dump |grep set-sink-volume | grep " .. sink)
    local v = f:read()
    f:close()
    if v ~= nil then
        local volume = tonumber(string.sub(v, string.find(v, 'x') - 1))
        local newVolume = volume + step
        if newVolume > 65536 then
            newVolume = 65536
        end
        io.popen("pacmd set-sink-volume " .. sink .. " " .. newVolume)
    end
end

function volumeDown()
    local sink = getSink()
    local step = 655 * 5
    local f = io.popen("pacmd dump |grep set-sink-volume | grep " .. sink)
    local v = f:read()
    f:close()
    if v ~= nil then
        local volume = tonumber(string.sub(v, string.find(v, 'x') - 1))
        local newVolume = volume - step
        if newVolume < 0 then
            newVolume = 0
        end
        io.popen("pacmd set-sink-volume " .. sink .. " " .. newVolume)
    end
end

function volumeMute()
    local sink = getSink()
    local g = io.popen("pacmd dump |grep set-sink-mute | grep " .. sink)
    local mute = g:read()
    if string.find(mute, "no") then
        io.popen("pacmd set-sink-mute " .. sink .. " yes")
    else
        io.popen("pacmd set-sink-mute " .. sink .. " no")
    end
    g:close()
end

function volumeInfo()
    local sink = getSink()
    volmin = 0
    volmax = 65536
    local f = io.popen("pacmd dump |grep set-sink-volume | grep " .. sink)
    local g = io.popen("pacmd dump |grep set-sink-mute | grep " .. sink)
    local v = f:read()
    local mute = g:read()
    if mute ~= nil and string.find(mute, "no") then
        volume = math.floor(tonumber(string.sub(v, string.find(v, 'x')-1)) * 100 / volmax).." %"
    else
        volume = "✕"
    end
    f:close()
    g:close()
    return "𝅘𝅥𝅮 "..volume
end
