local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

local popen = require("common").popen
local with  = require("common").with
local tonumber = tonumber
local tointeger = math.tointeger
local JSON = require("json")
local HERE = gears.filesystem.get_dir("config")

local function cat(name, fun)
    return with(io.open(name, "r"),
            function(file)
                local ret = file:read("*a")
                return fun and fun(ret) or ret
            end)
end

-- TODO Remain time for power and mouse event
local function power(adapter)
    local obj = wibox.widget.textbox()
    local idx = 0

    obj.notify_warn = false
    obj.notify_urgent = false
    obj.hibernate_timeout = 10
    obj.update = function(this)
        local path = "/sys/class/power_supply/"..adapter.."/"
        local cur = cat(path.."energy_now")
        local cap = cat(path.."energy_full")
        local sts = cat(path.."status")
        if sts:match("Full") then
            this:set_markup("<span color='#0000ff' size='large'>🔌</span>")
            return
        end

        local precentage = cur*100/cap
        local ICONS = {
            -- empty, low, 1/2, full, charging
            [0] = "", "", "", "", "",
        }
        if sts:match("Charging") then
            if this.notify then
                naughty.destroy(this.notify)
            end
            this.notify_warn = false
            this.notify_urgent = false
            this.hibernate_timeout = 10
            local color = "#00ff00"
            local icon = ICONS[idx]
            idx = (idx+1)%(#ICONS+1)
            this:set_markup(("<span color='%s' font_family='Ionicons' size='large'>%s</span>"):format(color, icon))
            return
        end

        if precentage >= 15 and this.notify then
            naughty.destroy(this.notify)
        end

        local color = ""
        local i
        if     precentage >= 90 then i = 3
        elseif precentage >= 40 then i = 2
        elseif precentage >= 15 then i = 1
        else
            i = 0
            if precentage >= 10 then
                color = "orange"
                if not this.notify_warn then
                    this.notify_warn = true
                    this.notify = naughty.notify({
                      title = "Battery",
                      text = "The power of battery is lower than 15%!",
                      timeout = 30,
                      hover_timeout = 60,
                      position = "top_right",
                    })
                end
            elseif precentage >= 5 then
                color = "red"
                if not this.notify_urgent then
                    this.notify_urgent = true
                    this.notify = naughty.notify({
                        title = "Battery",
                        text = "The power of battery is lower than 10%!",
                        timeout = 30,
                        hover_timeout = 60,
                        position = "top_right",
                    })
                end
            elseif precentage < 5 then
                color = "red"
                if this.notify then
                    naughty.destroy(this.notify)
                end
                this.notify = naughty.notify({
                    title = "Battery",
                    text = "The power of battery is lower than 5%!\n"
                           .."The computer will hibernate after "
                           ..this.hibernate_timeout
                           .." second(s) to save your work.",
                    timeout = 1,
                    position = "top_middle",
                })
                if this.hibernate_timeout == 0 then
                    this.hibernate_timeout = 10
                    awful.spawn("systemctl hibernate")
                end
                this.hibernate_timeout = this.hibernate_timeout -1
            end
        end
        local icon = ICONS[i]
        color = (color ~= "") and "color='"..color.."'" or ""
        precentage = ("<span %s> %.1f%%</span>"):format(color, precentage)
        this:set_markup(("<span %s font_family='Ionicons' size='large'>%s</span>"):format(color, icon)..precentage)
    end

    obj.timer = gears.timer({
        timeout = 1,
        autostart = true,
        callback = function() obj:update() end,
    })

    obj:update()
    return obj
end

local function volume()
    local obj = wibox.widget.textbox()
    --local notify
    obj.muted = false
    obj.volume = nil

    obj.update_status = function(this)
        popen("amixer sget Master", function(out)
            this.muted = (nil ~= out:find("%[off%]"))
            this.volume = tonumber(out:match("(%d+)%%"))
        end)
    end
    obj.update = function(this)
        this:update_status()
        local color = ""
        local icon
        if this.muted then
            icon = ""
        elseif this.volume >= 70 then
            icon = ""
        elseif this.volume >= 40 then
            icon = ""
        else
            icon = ""
        end
        this:set_markup(("<span %s font_family='Ionicons' size='large'>%s</span> %d%%"):format(
                color, icon, this.volume))
    end
    obj.raise = function(this, delta)
        popen(("amixer sset Master %d%%+"):format(delta))
        this:update()
    end
    obj.drain = function(this, delta)
        popen(("amixer sset Master %d%%-"):format(delta))
        this:update()
    end
    obj.toggle = function(this)
        popen("amixer sset Master toggle")
        this:update()
    end
    obj.mute = function(this)
        popen("amixer sset Master mute")
        this:update()
    end
    obj.unmute = function(this)
        popen("amixer sset Master unmute")
        this:update()
    end

    obj:connect_signal("button::release", function(_, _, _, button)
        if button == 1 then
            obj:toggle()
        elseif button == 4 then
            obj:raise(1)
        elseif button == 5 then
            obj:drain(1)
        end
    end)

    obj.timer = gears.timer({
        timeout = 1,
        autostart = true,
        callback = function() obj:update() end,
    })

    obj:update()
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

local function weather(city)
    -- http://www.weather.com.cn/static/html/legend.shtml
    local icons = {
        ["晴"] = "☀",
        ["阴"] = "☁",
        ["多云"] = "⛅",
        [""] = "🌤",
        [""] = "🌥",
        ["小雨"] = "☂ ",
        [""] = "☔",
        ["阵雨"] = "🌦",
        [""] = "🌧",
        ["暴雨"] = "🌨",
        [""] = "🌩",
        [""] = "⚡",
        ["雷阵雨"] = "⛈",
        [""] = "🌪",
        [""] = "🌫",
        [""] = "🌁",
    }
    local fmtstr = "<span size='large'>%s</span> %s"

    local obj = wibox.widget.textbox()
    obj.city = city or "成都"
    obj.t_out = 60    -- 1 minute
    obj.update = function(this)
        --[[
        awful.spawn.easy_async({HERE.."/bin/weather", this.city},
                function(stdout, _, _, _)
            this.cache = JSON.decode(stdout)
            if this.cache.status == true then
                local icon = icons[this.cache.today.weather] or "?"
                this:set_markup(fmtstr:format(icon, this.cache.today.temp_now))
            end
        end)
        --]]
    end

    obj.timer = gears.timer({
        timeout = obj.t_out,
        autostart = true,
        callback = function() obj:update() end,
    })

    obj:connect_signal("button::press", function(_, _, _, button)
        if 1 ~= button or not obj.cache then
            return
        end

        if obj.notify then
            naughty.destroy(obj.notify)
        end
        local teamplate = "City: %s\n"..
                          "Current Temperature: %s\n"..
                          "Min/Max Temperature: %s/%s\n"..
                          "Weather: %s\n"..
                          "Air Level: %s\n\n"..
                          "Tomorrow: %s/%s\n"..
                          "After Tomorrow: %s/%s"
        local w = obj.cache
        obj.notify = naughty.notify({
            --title = city,
            text = teamplate:format(obj.city,
                       w.today.temp_now,
                       w.today.temp_min, w.today.temp_max,
                       w.today.weather,
                       w.today.air_level,
                       w.tomorrow.temp_min, w.tomorrow.temp_max,
                       w.after_tomorrow.temp_min, w.after_tomorrow.temp_max),
            timeout = 3,
            hover_timeout = 20,
            position = "top_right",
        })
    end)

    obj:set_markup(fmtstr:format("?", "-℃"))
    obj:update()
    return obj
end

local function sensor(hwmon)
    local obj = awful.widget.watch(("cat /sys/class/hwmon/%s"..
                    "/temp1_input"):format(hwmon),
            2,  -- 2s
            function(widget, stdout)
                local tp = tonumber(stdout)/1000
                local c = 'green'
                if tp < 40 then
                    c = '#0053b4'       -- blue
                elseif tp < 60 then
                    c = 'orange'
                elseif tp < 70 then
                    c = 'orange'
                else
                    c = 'red'
                end

                widget:set_markup(("<span color='%s'>"..
                        "<span font_family='Ionicons' size='large'></span>"..
                        "%.0f℃</span>"):format(c, tp))
            end)
    return obj
end

local function clock()
    local obj = wibox.widget.textclock("%I:%M:%S %p", 1)

    obj.show_notification = function(this)
        if this.notify then
            naughty.destroy(this.notify)
        end
        this.notify = naughty.notify({
            text = this.lunar_cache,
            timeout = 3,
            hover_timeout = 20,
            position = "top_right",
        })
    end

    obj:connect_signal("button::press", function(_, _, _, button)
        if 1 ~= button then
            return
        end

        if not obj.lunar_cache then
            awful.spawn.easy_async({HERE.."/bin/lunar", }, function(stdout, _, _, _)
                obj.lunar_cache = table.concat(JSON.decode(stdout), "\n")

                obj:show_notification()
            end)
        else
            obj:show_notification()
        end

    end)
    return obj
end

local function net(...)
    local obj = wibox.widget.textbox()
    local t_out = 1
    local last_t, last_r = 0, 0
    local function str(speed)
        local units = {"B/s", "K/s", "M/s", "G/s", "T/s", "P/s",}
        local i = 1
        while speed > 1024 do
            i = i+1
            speed = speed/1024
        end
        local fstr = "%.2f%s"
        if speed < 10 then
            fstr = "%.2f%s"
        elseif speed < 100 then
            fstr = "%.1f%s"
        else
            fstr = "%.0f%s"
        end
        return fstr:format(speed, units[i])
    end
    local args = {...}
    local ifaces = {"wlp8s0"}
    if "table" == type(args[1]) then
        ifaces = args[1]
    elseif "string" == type(args[1]) then
        ifaces = args
    else
        obj:set_markup("cant find interface")
        return obj
    end

    obj.timer = gears.timer({
        timeout = t_out,
        autostart = true,
        callback = function()
            local sum_t = 0
            local sum_r = 0
            for _, iface in pairs(ifaces) do
                local now_t = cat(("/sys/class/net/%s/statistics/tx_bytes"):format(iface))
                local now_r = cat(("/sys/class/net/%s/statistics/rx_bytes"):format(iface))
                sum_t = sum_t+tointeger(now_t)
                sum_r = sum_r+tointeger(now_r)
            end
            --local sum_t, sum_r = stdout:match("(%d+)%s+(%d+)")
            local speed_t, speed_r = str((sum_t-last_t)/t_out), str((sum_r-last_r)/t_out)
            last_t, last_r = sum_t, sum_r
            obj:set_markup(("↑%s ↓%s"):format(speed_t, speed_r))
        end,
    })

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
