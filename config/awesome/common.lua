local awful = require("awful")

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

-- 农历
-- depend on `luaspec` and `luasocket`
-- {
--  "2018-6-1 Friday",
--  "戊戌狗年四月十八",
--  {"儿童节",},
-- }
local function lunar()
    local FESTIVAL = {
        [101] = "元旦",
        [214] = "情人节",
        [308] = "妇女节",
        [312] = "植树节",
        [322] = "世界睡眠日",
        [401] = "愚人节",
        [501] = "劳动节",
        [601] = "儿童节",
        [801] = "建军节",
        [910] = "教师节",
        [1001] = "国庆节",
        [1224] = "平安夜",
        [1225] = "圣诞节",
    }
    local FESTIVAL_LUNAR = {
        [101] = "春节",
        [115] = "元宵",
        [202] = "龙抬头",
        -- 寒食节在清明前一两天
        [404] = "清明",
        [405] = "清明", [406] = "清明",
        [505] = "端午",
        [606] = "天贶",   -- kuang4
        [707] = "七夕",
        [715] = "孟兰",   -- 中元
        [730] = "地藏",
        [815] = "中秋",
        [909] = "重阳",
        [1208] = "腊八",
        [1223] = "祭灶神", [1224] = "祭灶神",
        -- 29 或 30 "除夕",
    }
    local cache = nil
    local https = require("ssl.https")
    local ltn12 = require("ltn12")
    local http = require("socket.http")
    return function ()
        if cache then
            return cache
        end

        local URL = "https://www.sojson.com/open/api/lunar/json.shtml"
        local pat = "\"%s\":%%s*\"?([^,\"]+)\"?"
        local json = {}
        -- TODO Add timeout
        local res, code, reshd, s = https.request({
            url = URL,
            method = "GET",

            sink = ltn12.sink.table(json),
            protocol = "tlsv1",
        })

        json = table.concat(json)
        if "200" ~= json:match(pat:format("status")) then
            return {"error!",}
        end

        local date = table.concat({
            json:match(pat:format("year")),  "-",
            json:match(pat:format("month")), "-",
            json:match(pat:format("day")),   " ",
            json:match(pat:format("week")),
        })
        local ldate = table.concat({
            json:match(pat:format("hyear")),
            json:match(pat:format("animal")),    "年",
            json:match(pat:format("cnmonth")),   "月",
            json:match(pat:format("cnday")),
        })
        cache = {
            date, ldate,
        }
        table.insert(cache, FESTIVAL[100*json:match(pat:format("month"))+json:match(pat:format("day"))])
        table.insert(cache, FESTIVAL_LUNAR[100*json:match(pat:format("lunarMonth"))+json:match(pat:format("lunarDay"))])
        return cache
    end
end

function brightness(device)
    local obj = {}

    obj.brightness = 1      -- default value
    obj.DEVICE = "eDP-1"
    obj.MAX_VALUE = 1.15
    obj.MIN_VALUE = 0.2

    if "string" == type(device) then
        obj.DEVICE = device
    end

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
    lunar = lunar(),
    brightness = brightness,
}
