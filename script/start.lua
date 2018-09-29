require "base.base_class"
require "base.class_to_file"
require "base.config"
require "base.override_function"
require "base.global_function"
require "util.print_util"
require "util.file_util"
require "test.test_one"

function start()
    FileUtil.Init()
    FileUtil.Test()
end

start()
