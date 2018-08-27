OverrideFunction = OverrideFunction or {}

OverrideFunction.TostringType = {
    PrintTable = 1,     --  用于打印数据的输出类型，数字会带上 []
}

--  重写了 lua 的各种方法
local old = {}

-----------------------------------------------
-- # 简单替换
-----------------------------------------------
str_fmt = string.format

-----------------------------------------------
-- # 打印
-----------------------------------------------
old.tostring = tostring
function tostring(msg, st_type)
    if not st_type then return old.tostring(msg) end
    if st_type == OverrideFunction.TostringType.PrintTable then
        return old.tostring(string.format("[%s]", msg))
        -- if type(msg) == "number" then
        --     return old.tostring(string.format("[%s]", msg))
        -- elseif type(msg) == "string" then
        --     return old.tostring(string.format("[%s]", msg))
        -- elseif type(msg) == "function" then
        --     return old.tostring(string.format("[%s]", msg))
        -- elseif type(msg) == "userdata" then
        --     return old.tostring(string.format("[%s]", msg))
        -- elseif type(msg) == "table" then
        --     return old.tostring(string.format("[%s]", msg))
        -- end
    end
end