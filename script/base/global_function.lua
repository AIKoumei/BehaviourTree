require "base/override_function"

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

-----------------------------------------------
-- # 字符串
-----------------------------------------------
function TI18N(msg)
    return msg
end