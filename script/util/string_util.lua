-----------------------------------------------
-- # 用于方便操作字符串的工具类
-----------------------------------------------
StringUtil = StringUtil or BaseClass()


function StringUtil.GetLen(str)
    local len = 0
    local charLen = string.len(str)
    local i, j = 1, 1 
    while i <= charLen do
        local c = string.byte(str, i)
        if c > 0 and c <= 127 then  --英文数字字母
            j = 1
        elseif (c >= 192 and c <= 223) then
            j = 2
        elseif (c >= 224 and c <= 239) then
            j = 3
        elseif (c >= 240 and c <= 247) then
            j = 4
        end
        i = i + j
        len = len + 1
    end
    return len
end

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

-- 拆分成字符
function StringUtil.Split(str)
    local list = {}
    local char_list = {}
    local len = string.len(str)
    local i, j = 1, 1 
    while i <= len do
        local c = string.byte(str, i)
        if c > 0 and c <= 127 then  --英文数字字母
            j = 1
        elseif (c >= 192 and c <= 223) then
            j = 2
        elseif (c >= 224 and c <= 239) then
            j = 3
        elseif (c >= 240 and c <= 247) then
            j = 4
        end
        local char = string.sub(str, i, i+j-1)
        i = i + j
        table.insert(list, {char=char, type=j})
        table.insert(char_list, {char})
    end
    return char_list, len, list
end