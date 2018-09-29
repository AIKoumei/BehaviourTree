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

-- 写入字符串
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