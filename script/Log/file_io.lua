FileIO = FileIO or BaseClass()

function FileIO:__init()
    if FileIO.Instance then
        FileIO:Write("running.stack", string.format("%s\n%s", TI18N("FileIO 已经被初始化了"), debug.traceback()))
        return 
    end
    FileIO.Instance = self
    FileIO:InitConfig()
end

-- 初始化设置
function FileIO:InitConfig()
    -- 默认日志访问路径
    self.file_path = "./logs/"
    self.file_path = ""

    -- 存储变量
    self.file = {}      --  存放文件句柄
end


-----------------------------------------------
-- # 基础方法
-----------------------------------------------
-- 在访问文件的时候，会自行打开文件
function FileIO:GetFile(file_name)
    -- self:CheckFloderExistAndMake(file_name) 
    if not self.file[file_name] then
        local file = string.format("%s%s.%s", self.file_path, file_name, "log")
        self.file[file_name] = io.open(file, "a+")
    end
    if not self.file[file_name] then
        local file = string.format("%s%s.%s", self.file_path, file_name, "log")
        print(str_fmt("文件路径不存在 %s", file))
    end
    if io.type(self.file[file_name]) ~= "file" then 
        self.file[file_name] = io.open(string.format("%s%s.%s", self.file_path, file_name, "log"), "a+")
    end
    return self.file[file_name]
end

-- 在清除文件引用的时候，会自行关闭文件通道

-- 检查路径是否存在
-- TODO 暂时不能用，os.execute 结果信息会乱码
-- TODO 可能需要兼容
function FileIO:CheckFloderExistAndMake(file_name)
    local file_path = str_fmt("%s%s.log", self.file_path, file_name)
    local ts = string.reverse(file_path)
    local i = string.find(ts, "/")
    local m = string.len(ts) - i
    local file_catalog = string.sub(file_path, 3, m)
    local file_catalog_tab = StringUtil.SpliteByFormat(file_catalog, "/")
    local detection = "."
    if file_catalog_tab then
        for _,v in pairs(file_catalog_tab) do
            detection = detection .. "/" .. v
            local cmd = str_fmt("cd %s", detection)
            local bool = not os.execute(cmd)
            if bool then
                os.execute(str_fmt("mkdir %s", detection))
            end
        end
    end
end


-----------------------------------------------
-- # 外部调用接口
-----------------------------------------------
function FileIO:Write(file_name, obj)
    -- self:GetFile("main"):Write(tostring(obj))
    local file = self:GetFile("main")
    SafeCallFun(function ()
        file:write(tostring(obj))
        print(str_fmt("write %s", tostring(obj)))
    end)
    if file_name ~= "main" then
        -- self.file[file_name]:Write(tostring(obj))
    end
end





-- test
FileIO.New()
FileIO.Instance.file_path = "logs/"
FileIO.Instance:Write("main", "msg")
FileIO.Instance.file_path = ""
FileIO.Instance:Write("main", "msg")
