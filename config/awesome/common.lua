local function popen(cmd, fun)
    local file = io.popen(cmd, "r")
    local out
    out = file:read("*a")
    local _, _, code = file:close()
    if type(fun) == "function" then
        return fun(out, code)
    end
end

local function with(obj, fun)
    local ret = fun(obj)
    obj:close()
    return ret
end

--[[
local function brightness(device)
    local awful = require("awful")

    local obj = {}

    obj.brightness = 1      -- default value
    obj.DEVICE = device or "eDP1"
    obj.MAX_VALUE = 1.15
    obj.MIN_VALUE = 0.2

    function obj.raise(this, v)
        this.brightness = math.min(this.brightness + v/100.0, this.MAX_VALUE)
        awful.spawn(("xrandr --output %s --brightness %.4f"):format(this.DEVICE, this.brightness))
    end

    function obj.drain(this, v)
        this.brightness = math.max(this.brightness - v/100.0, this.MIN_VALUE)
        awful.spawn(("xrandr --output %s --brightness %.4f"):format(this.DEVICE, this.brightness))
    end

    function obj.max(this)
        awful.spawn(("xrandr --output %s --brightness %f"):format(this.DEVICE, this.MAX_VALUE))
    end

    function obj.min(this)
        awful.spawn(("xrandr --output %s --brightness %f"):format(this.DEVICE, this.MIN_VALUE))
    end

    return obj
end
--]]


local function brightnessctl()
    local awful = require("awful")
    local obj = {}

    function obj.raise(_, v)
        if v < 0 then
            return
        end
        awful.spawn(("brightnessctl set +%.0f%%"):format(v))
    end

    function obj.drain(_, v)
        if v < 0 then
            return
        end
        awful.spawn(("brightnessctl set %.0f%%-"):format(v))
    end

    function obj.max(_)
        awful.spawn("brightnessctl set 100%")
    end

    function obj.min(_)
        awful.spawn("brightnessctl set 100%")
    end

    return obj
end

return {
    popen = popen,
    with = with,
    brightness = brightnessctl,
}
