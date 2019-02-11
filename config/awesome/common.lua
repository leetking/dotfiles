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

-- {
--  "2018-6-1 Fri",
--  "戊戌狗年四月十八",
--  "儿童节",
--  "宜: balabala",
--  "忌: balabala",
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

    -- http://www.zdic.net/nongli/inc/ll2.asp
    local cache = nil
    local https = require("ssl.https")
    local ltn12 = require("ltn12")
    local http = require("socket.http")
    local JSON = require("json")

    return (function()
        if cache then
            return cache
        end

        local URL = "https://www.sojson.com/open/api/lunar/json.shtml"
        local pat = "\"%s\":%%s*\"?([^,\"]+)\"?"
        local json = {}
        -- It effects the global
        -- the thraed at https://github.com/brunoos/luasec/issues/112
        http.TIMEOUT = 10
        local res, code, reshd, s = https.request({
            url = URL,
            method = "GET",

            sink = ltn12.sink.table(json),
            protocol = "tlsv1",
        })
        json = JSON.decode(table.concat(json))

        if nil == res or "success" ~= json.message then
            return {os.date("%F %a"), }
        end

        local date = os.date("%F %a")
        cache = {
            os.date("%F %a"),
            table.concat({
                json.data.cnyear,
                json.data.hyear,
                json.data.animal, "年",
                json.data.cnmonth, "月",
                json.data.cnday,
            }),
        }
        --[[
        table.insert(cache, FESTIVAL[100*get("month")+get("day")])
        table.insert(cache, FESTIVAL_LUNAR[100*get("lunarMonth")+get("lunarDay")])
        --]]
        if #json.data.festivalList > 0 then
            table.insert(cache, table.concat(json.data.festivalList, ","))
        end
        table.insert(cache, "宜: "..json.data.suit)
        table.insert(cache, "忌: "..json.data.taboo)

        return cache
    end)()
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

local function weather(city)
    local city = city or "成都"

    local https = require("ssl.https")
    local ltn12 = require("ltn12")
    local http = require("socket.http")
    local JSON = require("json")

    return (function()
        local url = "https://www.tianqiapi.com/api/"
        local json = {}
        http.TIMEOUT = 3
        local res, code, reshd, s = https.request({
            url = url,
            method = "GET",
            query = "version=v1&city="..city,

            sink = ltn12.sink.table(json),
            protocol = "tlsv1",
        })
        json = JSON.decode(table.concat(json))

        if nil == res then
            return {
                status = false,
                reason = "error",
            }
        end

        -- build result
        return {
            status = true,
            today = {
                temp_now = json.data[1].tem,
                temp_min = json.data[1].tem2,
                temp_max = json.data[1].tem1,
                weather = json.data[1].wea,
                air_level = json.data[1].air_level,
            },
            tomorrow = {
                temp_min = json.data[2].tem2,
                temp_max = json.data[2].tem1,
            },
            after_tomorrow = {
                temp_min = json.data[3].tem2,
                temp_max = json.data[3].tem1,
            },
        }
    end)()
end

return {
    popen = popen,
    D = D,
    with = with,
    lunar = lunar,
    weather = weather,
    brightness = brightness,
}
