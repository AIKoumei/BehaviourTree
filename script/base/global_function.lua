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

-----------------------------------------------
-- # 字符串
-----------------------------------------------
function TI18N(msg)
    return msg
end