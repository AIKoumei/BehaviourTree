require "base/override_function"

function debug_print(...)
    if debug then
        print(...)
    end
end

function getLuaMemory_M()
    return string.format("LuaMemory: %sM", tostring(math.ceil(collectgarbage("count"))/1024))
end