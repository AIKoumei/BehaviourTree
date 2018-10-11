-- TODO
-- <1>  理解、实现行为树
-- <2>  自动 require 文件

require "base.base_class"
require "base.class_to_file"
require "base.config"
require "base.override_function"
require "base.global_function"
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

    BehaviourTree.New()
    PrintUtil.SimplePrint(BehaviourTree.NodeClassEnum)
    BehaviourTree.Test()
end

start()
