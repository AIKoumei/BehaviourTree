-----------------------------------------------
-- # 用于方便打印的工具类
-----------------------------------------------
PrintUtil = PrintUtil or BaseClass()

function PrintUtil.Print()
end

-- 打印待分隔符的标题
function PrintUtil.LogPrint(title)
    print("================================================")
    print(string.format("== # %s", title or ""))
    print("================================================")
end

--  打印类型和值
function PrintUtil.PrintTV1(value)
    print(type(value), tostring(value))
end

function PrintUtil.SimplePrint(obj, str_format, ...)
    local readed = {}
    local function _print(obj, str_format, ...)
        if readed[obj] then return end
        if type(obj) == "table" then
            for k,v in pairs(obj) do
                _print(v, "[%s][%s][%s]", tostring(obj), k, (type(v) == "string") and string.format("\"%s\"", v) or v)
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

function PrintUtil.SimplePrint2(obj, readed, print_func, parent, key, level)
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