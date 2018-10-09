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
    FileUtil.Init()

    local path = GetPath()
    PrintUtil.SimplePrint(debug.getinfo(1))
end

start()
