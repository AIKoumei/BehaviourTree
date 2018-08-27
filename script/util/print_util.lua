-----------------------------------------------
-- # 用于方便打印的工具类
-----------------------------------------------
PrintUtil = PrintUtil or BaseClass()

function PrintUtil.Print()
end

--  打印类型和值
function PrintUtil.PrintTV1(value)
    print(type(value), tostring(value))
end