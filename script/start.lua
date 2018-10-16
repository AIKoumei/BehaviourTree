-- TODO
-- <1>  理解、实现行为树
-- <2>  自动 require 文件

require "base.base_class"
require "base.class_to_file"
require "base.config"
require "base.override_function"
require "base.global_function"
require "util.string_util"
require "util.print_util"
require "util.table_util"
require "util.file_util"
require "test.test_one"

require "behaviour_tree.behaviour_tree"

function start()
    -- 改进种子
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    
    FileUtil.Init()

    -- local path = GetPath()
    -- PrintUtil.SimplePrint(debug.getinfo(1))
    -- local aaa = function()
    --     return {{1}, {2}}
    -- end

    -- BehaviourTree.New()
    -- PrintUtil.SimplePrint(BehaviourTree.NodeClassEnum)
    -- BehaviourTree.Test()

    -- FileUtil.TestGlobalParam()
    -- print(string.find("sadf4asf.lua.lua", ".lua", -string.len(".lua")))
    -- print(string.match("   a = 1", "^%s*([%w_]*)%s*"))

    FileUtil.TestParseLuaFile()
    -- print(string.match("--[==[]==]sadfsadfadsf", "^--%[(=*)%[%]%1%]"))
    -- print(string.match("salkdfjlaskjfd\"", "\\\"$"))
    if string.match("require \"base.base_class\"", "^--") then
        print(string.match("require \"base.base_class\"", "^--"))
    end
    local str = "--r"
    local mat = "^%-%-"
    if string.match(str, mat) then
        print("succeed", str, mat)
    end
    local str = ""
    local mat = "^%-%-"
    if string.match(str, mat) then
        print("succeed", str, mat)
    end
    local str = ""
    local mat = "^--"
    if string.match(str, mat) then
        print ("succeed", str, mat)
    end
    local str = "asdf"
    local mat = "%s+"
    if string.match(str, mat) then
        print ("succeed", str, mat)
    end
    
    a = 1
    local c

end

start()
