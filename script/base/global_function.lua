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
        -- return string.sub(path, 2, (string.find(path, "start.lua")) - 1)
        return path
    end
end

-----------------------------------------------
-- # 字符串
-----------------------------------------------
function table2str(lua_table, parent, indent, no_key)
    if type(lua_table) ~= "table" then return string.format("%q", lua_table) end
    local key = tostring(lua_table)
    indent = indent or 0
    if indent > 10 then return "..." end
    parent = parent or {}
    if parent[key] then return "..." end
    local list = {}
    for k, v in pairs(lua_table) do
        local szSuffix = ""
        local formatting
        local TypeV = type(v)
        if TypeV == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep(" ", indent)
        if type(k) == "string" or type(k) == "number" then
            if type(k) == "string" and tonumber(k) then 
                formatting = no_key and szSuffix or string.format("%s%q=%s", szPrefix, k, szSuffix)
            else
                formatting = no_key and szSuffix or string.format("%s%s=%s", szPrefix, k, szSuffix)
            end
        end
        if TypeV == "table" then
            if k ~= "_class_type" then
                table.insert(list, formatting)
                table.insert(list, table2str(v, parent, indent + 1, no_key))
                table.insert(list, szPrefix.."},")
            end
        else
            local szValue = ""
            if TypeV == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            table.insert(list, formatting..szValue..",")
        end
    end
    return table.concat(list, "\n")
end

-----------------------------------------------
-- # 字符串
-----------------------------------------------
function TI18N(msg)
    return msg
end