require "base/override_function"
require "test/test_one"

-- if TestOne then
--     TestOne.Print()
-- end

unpack = function (args, i)
    if i == 1000 then return error("unpack args nums more then 1000!") end
    if args[i or 1] then
        return args[i or 1], unpack(args, i and (i + 1) or 2)
    end
end

GetPath = function ()
    if debug and debug.getinfo then
        local data = debug.getinfo(1)
        local path = data.source
        return string.sub(path, 2, (string.find(path, "start.lua")) - 1)
    end
end

print(GetPath())


local Base = {}

function Base.SimplePrint(obj, str_format, ...)
    local readed = {}
    local function _print(obj, str_format, ...)
        if readed[obj] then return end
        if type(obj) == "table" then
            for k,v in pairs(obj) do
                _print(v, "[table][%s][%s]", k, v)
            end
        else
            if str_format then
                print(string.format(str_format, ...))
            else
                print(obj)
            end
        end
    end
    return _print(obj, str_format, ...)
end

function Base.SimplePrint2(obj, readed, print_func, parent, key, level)
    readed = readed or {}
    level = level or 1
    if readed[obj] then return end
    if type(obj) == "table" then
        readed[obj] = true
        if print_func then
            print_func(parent, key, obj, level)
        else
            print(string.format("[table][%s][%s][%s]", tostring(parent), tostring(key), tostring(obj)))
        end
        for k,v in pairs(obj) do
            Base.SimplePrint2(v, readed, print_func, obj, k)
        end
    else
        if print_func then
            print_func(parent, key, obj, level)
        else
            print(string.format("[%s][%s][%s]", tostring(parent), tostring(key), tostring(obj)))
        end
    end
end


Base.SimplePrint2(package.path)

print(string.find("1111111", "1", -1))

Base.SimplePrint2(debug.getinfo(1))
