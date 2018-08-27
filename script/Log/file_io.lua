FileIO = FileIO or BaseClass()

function FileIO:__init()
    -- 默认日志访问路径
    self.file_path = "./log/"
end


-- 在访问文件的时候，会自行打开文件
function FileIO:GetFile(file_name)
    if not self.file[file_name] then
        self.file[file_name] = io.open(string.format("%s.%s", file_name, "log"), "a+")
    end
    if io.type(self.file[file_name]) ~= "file" then 
        self.file[file_name] = io.open(string.format("%s.%s", file_name, "log"), "a+")
    end
    return self.file[file_name]
end

function FileIO:Write(file_name, obj)
    -- self.file[file_name]:Write(tostring(obj))
    local file
    self:GetFile("main")
end



-- 在访问文件的时候，会自行打开文件
-- 在清除文件引用的时候，会自行关闭文件通道


-- test
FileIO.Write("fileio", "msg")
FileIO.Write("fileio", "msg")
