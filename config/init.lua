
--(map op lists)
function map(fun, ...)
    local list = (type(({...})[1]) == "table") and ... or {...}
    local ret = {}
    for _, v in pairs(list) do
        local t = fun(v)
        table.insert(ret, t)
    end
    return ret
end
function reduce(fun, ...)
    local list = (type(({...})[1]) == "table") and ... or {...}
    local ret = list[1]
    if #list < 2 then return ret end
    for i = 2, #list do
        ret = fun(ret, list[i])
    end
    return ret
end

function printtb(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end
