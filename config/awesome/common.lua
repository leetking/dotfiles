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

return {
    popen = popen,
    D = D,
    with = with,
}
