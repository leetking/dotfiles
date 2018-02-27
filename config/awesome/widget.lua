local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

local popen = require("common").popen
local with  = require("common").with
local lunar = require("common").lunar
local tonumber = tonumber

local function cat(name, fun)
    return with(io.open(name, "r"),
            function(file)
                local ret = file:read("*a")
                return fun and fun(ret) or ret
            end)
end

-- Add: Remain time for power and mouse event
local function power(adapter)
    local obj = wibox.widget.textbox()
    local i = 0
    obj.update = function(this)
        local path = "/sys/class/power_supply/"..adapter.."/"
        local cur = cat(path.."energy_now")
        local cap = cat(path.."energy_full")
        local sts = cat(path.."status")
        if sts:match("Full") then
            this:set_markup("<span color='#0000ff' size='large'>🔌</span>")
        else
            local color
            local icon
            local precentage = cur*100/cap
            local ICONS = {
                -- empty, low, 1/2, full, charging
                [0] = "", "", "", "", "",
            }
            if sts:match("Charging") then
                color = "color='#00ff00'"
                icon = ICONS[i]
                precentage = ""
                i = (i+1)%(#ICONS+1)
            else
                local idx
                if     precentage >= 90 then idx = 3
                elseif precentage >= 40 then idx = 2
                elseif precentage >= 15 then idx = 1
                else idx = 0
                end
                icon = ICONS[idx]
                color = (idx == 0) and "color='#ff0000'" or ""
                precentage = ("<span %s> %.1f%%</span>"):format(color, precentage)
            end
            this:set_markup(("<span %s font_family='Ionicons' size='large'>%s</span>"):format(color, icon)..precentage)
        end
    end
    obj:update()
    obj.timer = gears.timer({
        timeout = 1,
        autostart = true,
        callback = function() obj:update() end,
    })
    return obj
end

local function volume()
    local obj = wibox.widget.textbox()
    local notify
    obj.is_mute = function(this)
        local mute = false
        popen("amixer sget Master", function(out) mute = (nil ~= out:find("%[off%]")) end)
        return mute
    end
    obj.update = function(this)
        local color = ""
        local icon
        if this:is_mute() then
            icon = ""
        elseif this.vlu >= 70 then
            icon = ""
        elseif this.vlu >= 40 then
            icon = ""
        else
            icon = ""
        end
        this:set_markup(("<span %s font_family='Ionicons' size='large'>%s</span> %d%%"):format(
                color, icon, this.vlu))
    end
    popen("amixer sget Master", function(out) obj.vlu = tonumber(out:match("(%d+)%%")) end)
    obj.raise = function(this, vlu)
        popen(("amixer sset Master %d%%+"):format(vlu), function(out)
            this.vlu = tonumber(out:match("(%d+)%%"))
        end)
        this:update()
    end
    obj.drain = function(this, vlu)
        popen(("amixer sset Master %d%%-"):format(vlu), function(out)
            this.vlu = tonumber(out:match("(%d+)%%"))
        end)
        this:update()
    end
    obj.toggle = function(this)
        popen(("amixer sset Master toggle"):format(vlu), function(out)
            this.vlu = tonumber(out:match("(%d+)%%"))
        end)
        this:update()
    end
    obj.mute = function(this)
        popen(("amixer sset Master mute"):format(vlu), function(out)
            this.vlu = tonumber(out:match("(%d+)%%"))
        end)
        this:update()
    end
    obj.unmute = function(this)
        popen(("amixer sset Master unmute"):format(vlu), function(out)
            this.vlu = tonumber(out:match("(%d+)%%"))
        end)
        this:update()
    end
    obj:update()

    obj:connect_signal("button::release", function(_, _, _, button)
        if button == 1 then
            obj:toggle()
        elseif button == 4 then
            obj:raise(1)
        elseif button == 5 then
            obj:drain(1)
        end
    end)

    return obj
end

local function cpu()
    local color = "#00ff00"
    local graph = wibox.widget({
        width = 15,
        max_value = 100,
        color = color,
        --background_color = "#1e252c",
        background_color = beautiful.bg_normal,
        step_width = 1,
        --step_spacing = 0,
        widget = wibox.widget.graph
    })
    local last_idle, last_total = 0, 0
    local obj = awful.widget.watch("grep '^cpu ' /proc/stat", 1,
            function(widget, stdout)
                local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
                        stdout:match('(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s')

                local total = user + nice + system + idle + iowait + irq + softirq + steal

                local diff_idle = idle - last_idle
                local diff_total = total - last_total
                local diff_usage = (1000*(diff_total-diff_idle)/diff_total + 5)/10
                last_idle, last_total = idle, total

                if diff_usage > 80 then
                    widget:set_color('#ff4136')
                else
                    widget:set_color(color)
                end
                widget:add_value(diff_usage)
            end, graph)

    return obj
end

local function sysload()
    local cores = popen("grep 'processor' /proc/cpuinfo | wc -l",
            function(stdout) return tonumber(stdout) end)

    local graph = wibox.widget({
        width = 15,
        max_value = cores,
        --background_color = "#1e252c",
        background_color = beautiful.bg_normal,
        step_width = 1,
        widget = wibox.widget.graph
    })
    local last_idle, last_total = 0, 0
    local obj = awful.widget.watch("uptime", 1,
            function(widget, stdout)
                local avgload = tonumber(stdout:match("average:%s(%d+%.%d+),"))
                widget:add_value(avgload)
            end, graph)

    return obj
end
local function mem()
    local graph = wibox.widget({
        width = 15,
        max_value = 100,
        color = "#bf27bb",
        --background_color = "#1e252c",
        background_color = beautiful.bg_normal,
        step_width = 1,
        widget = wibox.widget.graph
    })
    local obj = awful.widget.watch("free", 1,
            function(widget, stdout)
                local t, u = stdout:match("Mem:%s+(%d+)%s+(%d+)")
                widget:add_value(u/t*100)
            end, graph)

    return obj
end

local function weather()
    local obj = wibox.widget.textbox("weather")
    return obj
end
local function sensor(hwmon)
    local obj = awful.widget.watch(("cat /sys/class/hwmon/%s/temp1_input"):format(hwmon),
            2,  -- 2s
            function(widget, stdout)
                widget:set_markup(("<span font_family='Ionicons' size='large'></span> %.0f℃"):format(tonumber(stdout)/1000))
            end)
    return obj
end

local function clock()
    local obj = wibox.widget.textclock("%I:%M:%S %p", 1)
    obj:connect_signal("button::press", function(_, _, _, button)
        if 1 ~= button then
            return
        end

        if obj.notify then
            naughty.destroy(obj.notify)
        end
        obj.notify = naughty.notify({
            text = table.concat(lunar(), "\n"),
            timeout = 3,
            position = "top_right",
        })
    end)
    return obj
end

local function net(iface)
    local t_out = 1
    local last_t, last_r = 0, 0
    local function str(speed)
        local units = {"B/s", "KB/s", "MB/s", "GB/s", "TB/s", "PB/s",}
        local i = 1
        while speed > 1024 do
            i = i+1
            speed = speed/1024
        end
        return ("%3.1f%s"):format(speed, units[i])
    end
    local obj = awful.widget.watch(("cat /sys/class/net/%s/statistics/tx_bytes "..
                                        "/sys/class/net/%s/statistics/rx_bytes "):format(iface, iface),
            t_out,
            function(widget, stdout)
                local now_t, now_r = stdout:match("(%d+)%s+(%d+)")
                local speed_t, speed_r = str((now_t-last_t)/t_out), str((now_r-last_r)/t_out)
                last_t, last_r = now_t, now_r
                widget:set_markup(("↑%s ↓%s"):format(speed_t, speed_r))
            end)

    return obj
end

return {
    power = power,
    volume = volume,
    sensor = sensor,
    clock = clock,
    cpu = cpu,
    mem = mem,
    sysload = sysload,
    weather = weather,
    net = net,
}
