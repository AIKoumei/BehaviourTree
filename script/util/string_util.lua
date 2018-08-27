-----------------------------------------------
-- # 用于方便操作字符串的工具类
-----------------------------------------------
StringUtil = StringUtil or BaseClass()

function StringUtil.Pow(str, times, splite_char)
    local st = {}
    for i = 1, times do
        table.insert(st, str)
    end
    return table.concat(st, splite_char or "")
end

function StringUtil.GetStanderTab()
    return "    "
end

-- 字符串分割函数
-- 传入字符串和分隔符，返回分割后的table
function StringUtil.SpliteByFormat(str, delimiter)
	local t = {}
	for match in (str..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(t, match)
	end
	return t
end
