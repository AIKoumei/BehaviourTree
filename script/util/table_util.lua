-----------------------------------------------
-- # 用于方便操作表的工具类
-----------------------------------------------
TableUtil = TableUtil or BaseClass()

-- 会将表完整地打印出来，不包括function和userdata
function TableUtil.Print(tab, no_tab)
    local ptype = OverrideFunction.TostringType.PrintTable
    local stack = {}    --  数据栈
    local level = 0    --  数据地深度
    local readed = {}   --  防止死循环
    local function _print_all(key, value, no_tab)
        level = level + 1
        if type(value) == "table" then
            if not readed[value] then
                if no_tab then
                    table.insert(stack, "{")
                else
                    local tab = StringUtil.Pow(StringUtil.GetStanderTab(), level)
                    table.insert(stack, string.format("%s{", tab))
                end
                for key, value in pairs(value) do
                    _print_all(key, value, no_tab)
                end
                if no_tab then
                    table.insert(stack, "}")
                else
                    local tab = StringUtil.Pow(StringUtil.GetStanderTab(), level)
                    table.insert(stack, string.format("%s}", tab))
                end
                readed[value] = true
            else
                -- 如果有环形引用的就不能当作数据使用了，不过一般不会用到的的才对
                if no_tab then
                    table.insert(stack, string.format("{%s%s = readed table %s}", tostring(key, ptype), tostring(value)))
                else
                    local tab = StringUtil.Pow(StringUtil.GetStanderTab(), level)
                    table.insert(stack, string.format("{%s = readed table %s}", tab, tostring(key, ptype), tostring(value)))
                end
            end
        else
            if no_tab then
                table.insert(stack, string.format("%s=%s", tostring(key, ptype), tostring(value)))
            else
                local tab = StringUtil.Pow(StringUtil.GetStanderTab(), level)
                table.insert(stack, string.format("%s%s = %s", tab, tostring(key, ptype), tostring(value)))
            end
        end
        level = level - 1
    end
    return table.concat(stack, no_tab and "" or "\n")
end