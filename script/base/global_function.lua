-----------------------------------------------
-- # 系统调试
-----------------------------------------------
function debug_print(...)
    if debug then
        print(...)
    end
end

function getLuaMemory_M()
    return string.format("LuaMemory: %sM", tostring(math.ceil(collectgarbage("count"))/1024))
end

function SafeCallFun(func, msg)
    xpcall(func, function(errinfo)
        msg = string.format("%s %s", msg or "执行函数报错了", errinfo) 
        print(msg)
    end)
end

-- 其实就是 table.unpack ?
function unpack(args, i)
    if i == 1000 then return error("unpack args nums more then 1000!") end
    if args[i or 1] then
        return args[i or 1], unpack(args, i and (i + 1) or 2)
    end
end

-- 获取require目录
function GetPath()
    if debug and debug.getinfo then
        local data = debug.getinfo(1)
        local path = data.source
        return string.sub(path, 2, (string.find(path, "start.lua")) - 1)
    end
end

-----------------------------------------------
-- # 字符串
-----------------------------------------------
function TI18N(msg)
    return msg
end