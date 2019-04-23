local DEBUG = false

local function D(...)
end

local function popen(cmd, fun)
    local file = io.popen(cmd, "r")
    local out
    out = file:read("*a")
    local _, _, code = file:close()
    return fun(out, code)
end

local function with(obj, fun)
    local ret = fun(obj)
    obj:close()
    return ret
end

function brightness(device)
    local awful = require("awful")

    local obj = {}

    obj.brightness = 1      -- default value
    obj.DEVICE = device or "eDP-1"
    obj.MAX_VALUE = 1.15
    obj.MIN_VALUE = 0.2

    function obj.raise(this, v)
        if this.brightness >= this.MAX_VALUE then
            return
        end
        this.brightness = this.brightness + v/100.0
        awful.spawn(("xrandr --output %s --brightness %f"):format(this.DEVICE, this.brightness))
    end

    function obj.drain(this, v)
        if this.brightness <= this.MIN_VALUE then
            return
        end
        this.brightness = this.brightness - v/100.0
        awful.spawn(("xrandr --output %s --brightness %f"):format(this.DEVICE, this.brightness))
    end

    function obj.max(this)
        awful.spawn(("xrandr --output %s --brightness %f"):format(this.DEVICE, this.MAX_VALUE))
    end

    function obj.min(this)
        awful.spawn(("xrandr --output %s --brightness %f"):format(this.DEVICE, this.MIN_VALUE))
    end

    return obj
end

return {
    popen = popen,
    D = D,
    with = with,
    brightness = brightness,
}
