------------------------------------------------
-- # update list
------------------------------------------------
-- 2018/9/29 
--      [优化] 实现文件通道缓存（提高效率）
------------------------------------------------
--@TODO
-- 实现缓冲写入（提高效率）
-- 定时写入（防止崩溃）
-- 不常用的文件通道丢弃（提高内存利用率）
-- FileUtil.config.log 文件操作日志

FileUtil = {}

function FileUtil.Init()
    -- FileUtil 的设置
    FileUtil.config = {}
    FileUtil.config.log = true      -- 记录自身操作
    -- 文件通道缓存
    FileUtil.file_cache = FileUtil.file_cache or {}
    -- 文件key列表，可以通过key而不是文件路径获取文件，FileUtil.file_key_list[file_full_name] = key
    FileUtil.file_key_list = FileUtil.file_key_list or {}
    -- 文件key列表属性，保存了 FileUtil.file_key_list 的相关信息
    FileUtil.file_key_list_attribute = FileUtil.file_key_list_attribute or {}
    -- 保存了已有的key，FileUtil.file_key_list_attribute.key_cache[key] = file_full_name
    FileUtil.file_key_list_attribute.key_cache = FileUtil.file_key_list_attribute.key_cache or {}
end

------------------------------------------------
-- # 操作方法
------------------------------------------------
-- 获取该文件夹下所有文件
-- TODO 增加后缀名支持
-- args
--      is_windows
--      path
--      ext
FileUtil.GetAllFile = function(args)
    if not args then return end
    local output_buff = ""
    local is_windows = args.is_windows
    local path = args.path
    if is_windows then
        output_buff = io.popen("dir ")
    else
        output_buff = io.popen("ls "..path.."/")
    end
	local file_table = {}
	if output_buff == nil then
        print("[error] ls "..path.."/ do not have any files or folders.")
    else
        for l in output_buff:lines() do
            print(l)
            if ext then
                table.insert(file_table, l)
            else
                table.insert(file_table, l)
            end
		end
	end
	return file_table
end

------------------------------------------------
-- # 文件IO
------------------------------------------------
-- 写入字符串
function FileUtil.Write(file_full_path_or_key, str)
    local file = FileUtil.GetFileCacheByKey(file_full_path_or_key)
    if not file then file = FileUtil.GetFileCache(file_full_path_or_key) end
    file:write(str)
end

-- 写入字符串，自动换行
function FileUtil.WriteLn(file_full_path_or_key, str)
    FileUtil.Write(file_full_path_or_key, string.format("%s%s", str, "\n"))
end

-- file, path, ext
-- * file   : 文件名
-- path     : 路径，默认是当前路径
-- ext      : 后缀名，如果有，则会以 file.ext 来组成文件名
function FileUtil.CloseFile(file, path, ext)
    local file, file_full_name = FileUtil.GetFileCache(path, file, ext)
    if file then
        io.close(file)
        FileUtil.file_cache[file_name] = nil
    end
    return file_full_name
end

-- 没有的话会打开文件
function FileUtil.GetFileCache(file, path, ext)
    local key = FileUtil.GetFullFileName(file, path, ext)
    FileUtil.file_cache[key] = FileUtil.file_cache[key] or io.open(key, "a+")
    -- 如果没有赋予 key ，赋予一下
    if not FileUtil.GetFileKeyByFullFileName(file, path, ext) then
        FileUtil.SetFileKeyByFullFileName(file, path, ext)
    end
    return FileUtil.file_cache[key], key
end

-- 根据文件key来打开文件，如果没有文件，返回空
function FileUtil.GetFileCacheByKey(key)
    local file = FileUtil.file_key_list_attribute.key_cache[key]
    if file then 
        return FileUtil.GetFileCache(file)
    end
end

-- 返回 文件名.后缀
function FileUtil.GetFileName(file, ext)
    return ext and string.format("%s.%s", file, ext) or file
end

-- 根据 filekey 返回 文件名.后缀
function FileUtil.GetFileNameByFileKey(key)
    return FileUtil.file_key_list_attribute.key_cache[key]
end

-- 返回 路径/文件名.后缀
function FileUtil.GetFullFileName(file, path, ext)
    local file_name = ext and string.format("%s.%s", file, ext) or file
    return string.format("%s%s", path or "", file_name)
end

-- 设置文件路径的key
function FileUtil.SetFileKeyByFullFileName(file, path, ext)
    local file_name = FileUtil.GetFullFileName(file, path, ext)
    if FileUtil.file_key_list[file_name] then 
        return  FileUtil.file_key_list[file_name] 
    end
    local saved = false
    local len = TableUtil.Len(tab)
    while (not saved) do
        local key = math.random(1, 100 * (len + 1))
        len = len + 1
        -- 如果不存在这个key，则使用
        if not FileUtil.file_key_list_attribute.key_cache[key] then
            FileUtil.file_key_list_attribute.key_cache[key] = file_name
            FileUtil.file_key_list[file_name] = key
            saved = true
        end
    end
    return FileUtil.file_key_list[file_name]
end

-- 返回文件路径的key
function FileUtil.GetFileKeyByFullFileName(file, path, ext)
    return FileUtil.file_key_list[FileUtil.GetFullFileName(file, path, ext)]
end

------------------------------------------------
-- # 测试
------------------------------------------------
function FileUtil.Test()
    PrintUtil.LogPrint("FileUtil.Test()")
    
    -- local file_path = "./"
    -- local file_name = "FileUtil.Test"
    -- local file = io.open(string.format("%s%s.%s", file_path, file_name, "log"), "a+")
    -- print("os.time()", os.time())
    -- file:write(tostring(os.time()))

    for i = 1, 10 do
        local file_name = math.random(1, 10)
        print("file_name", file_name)
        FileUtil.WriteLn(string.format("./.log/%s.log", file_name), string.format("%s  %s", file_name, os.time()))
    end
    
    PrintUtil.LogPrint("FileUtil.file_cache")
    PrintUtil.SimplePrint(FileUtil.file_cache)
    PrintUtil.LogPrint("FileUtil.file_key_list")
    PrintUtil.SimplePrint(FileUtil.file_key_list)
    PrintUtil.LogPrint("FileUtil.file_key_list_attribute")
    PrintUtil.SimplePrint(FileUtil.file_key_list_attribute)
    
    PrintUtil.LogPrint("FileUtil.Test() end")
end


function FileUtil.TestGlobalParam()
    -- 获得文件列表
    local root = "."
    local unread_file = {}
    local lua_file = {}

    local update_unread_files = function(unread, files, root_path)
        for _,filename in ipairs(files) do
            table.insert(unread, string.format("%s/%s", root_path, filename))
        end
    end
    local update_lua_file = function(lua_file, filename)
        local ext = ".lua"
        if string.find(filename, ext, -string.len(ext)) then
            table.insert(lua_file, filename)
            return true
        end
    end
    
    local files = FileUtil.GetAllFile{
        path = root
    }
    update_unread_files(unread_file, files, root)
    local limited = 3000
    local limit = 1
    while (#unread_file > 0) and (limit < limited) do
        local folder = table.remove(unread_file, #unread_file)
        if not update_lua_file(lua_file, folder) then
            update_unread_files(unread_file, FileUtil.GetAllFile({path = folder}), folder)
        end
        limit = limit + 1
    end
    PrintUtil.SimplePrint(lua_file)

    -- 解析文件内容
    local lua_key_param = {
        ["and"] = true, ["break"] = true, ["do"] = true,
        ["else"] = true, ["elseif"] = true, ["end"] = true,
        ["false"] = true, ["for"] = true, ["function"] = true,
        ["if"] = true, ["in"] = true, ["local"] = true,
        ["nil"] = true, ["not"] = true, ["or"] = true,
        ["repeat"] = true, ["return"] = true, ["then"] = true,
        ["true"] = true, ["until"] = true, ["while"] = true,
    }
    local read_global_param = function(line)
        local black_list_match = {
            "^%s*.*%s*=%s*.*or%s*BaseClass"
        }
        -- 匹配黑名单
        for _, match in ipairs(black_list_match) do
            if string.match(line, match) then
                return
            end
        end
        local param = string.match(line, "^%s*([%w_]*)%s*")
        if lua_key_param[param] then return end
        if param == "" then return end
        if string.match(param or "", "%.") then return end
        return param
    end
    local read_local_param = function(line)
        local param = string.match(line, "^%s*local%s*([%w_]*)%s*")
        if lua_key_param[param] then return end
        if param == "" then return end
        if string.match(param or "", "%.") then return end
        return param
    end
    local read_a_file = function(file, filename)
        local function_info = {}
        function_info.filename = filename
        function_info.param = {}
        function_info.local_param = {}
        function_info.result = {}

        local function_clip = {}
        local line_num = 0
        -- 分析每一行
        for line in file:lines() do
            line_num = line_num + 1
            local param = read_local_param(line)
            if param then
                -- table.insert(function_info.local_param, param)
                function_info.local_param[param] = param
            end
            local param = read_global_param(line)
            if string.match(function_info.filename, ".*file_util.*") and line_num > 285 then
                print("line:", line_num, "param:", param, "line", line)
                
                local black_list_match = {
                    "^%s*.*%s*=%s*.*or%s*BaseClass"
                }
                -- 匹配黑名单
                for _, match in ipairs(black_list_match) do
                    if string.match(line, match) then
                        return
                    end
                end
                local param = string.match(line, "^%s*([%w_]*)%s*$")
                if lua_key_param[param] then print(2) end
                if param == "" then print(1) end
            end
            if param and not function_info.local_param[param] then
                table.insert(function_info.result, string.format("line:%s    param:%s", line_num, param))
            end
        end
        return function_info
    end
    a = 1

    local function_infos = {}
    for _, filename in ipairs(lua_file) do
        local file = io.open(filename, "r")
        function_infos[filename] = read_a_file(file, filename)
    end
    PrintUtil.LogPrint("function_infos result")
    for _,info in pairs(function_infos) do
        if #info.result > 0 or string.match(info.filename, ".*file_util.*") then
            PrintUtil.LogPrint(info.filename)
            -- PrintUtil.SimplePrint(info.local_param)
            PrintUtil.SimplePrint(info.result)
        end
    end
end