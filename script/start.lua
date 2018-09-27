require "base.base_class"
require "base.class_to_file"
require "base.config"
require "base.override_function"
require "base.global_function"
require "util.print_util"
require "test.test_one"

function start()
end

start()

PrintUtil.LogPrint()
local func_tab = {}
func_tab.a = 1
function func_tab:run(a)
    print(self)
    print(self.a)
    print(a)
end
func_tab["run"](func_tab, 2)
func_tab:run(1)


PrintUtil.LogPrint()
myclass = {age = 10, name="aa"}

function myclass:fun(p)
    print(self)
    print(self.age)
    print(p)
end

myclass:fun("22")
myclass.fun("22")