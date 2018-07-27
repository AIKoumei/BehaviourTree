-- 保存类类型的虚表
local _class = {}
 
function BaseClass(super)
    -- 生成一个类类型
    local class_type = {}
    -- 在创建对象的时候自动调用
    class_type.__init = false
    class_type.__delete = false
    class_type.super = super
    class_type.New = function(...)
        -- 生成一个类对象
        local obj = {}
        obj._class_type = class_type

        -- 在初始化之前注册基类方法
        setmetatable(obj, { __index = _class[class_type] })

        -- 调用初始化方法
        do
            local create 
            create = function(c, ...)
                if c.super then
                    create(c.super, ...)
                end
                if c.__init then
                    c.__init(obj, ...)
                end
            end

            create(class_type, ...)
        end

        -- 注册一个delete方法
        obj.DeleteMe = function(self)
            -- 如果这行报错（attempt to index local 'self' (a nil value)），看一下object:DeleteMe()是不是写成object.DeleteMe()
            local now_super = self._class_type 
            while now_super ~= nil do   
                if now_super.__delete then
                    now_super.__delete(self)
                end
                now_super = now_super.super
            end
            for k,v in pairs(self) do
                if type(v) == "userdata" then
                    self[k] = nil
                end
            end
        end

        return obj
    end

    local vtbl = {}
    _class[class_type] = vtbl
 
    setmetatable(class_type, {__newindex =
        function(t,k,v)
            vtbl[k] = v
        end
        , 
        __index = vtbl, --For call parent method
    })
 
    if super then
        setmetatable(vtbl, {__index =
            function(t,k)
                local ret = _class[super][k]
                --do not do accept, make hot update work right!
                --vtbl[k] = ret
                return ret
            end
        })
    end
 
    return class_type
end

-- 动态加载
-- local parentG = {}
-- local requireList = NewModelFile or {}
-- local loading_module_list = {}
-- setmetatable(_G, parentG)
-- parentG.__index = function(t, k)
--     local require_name = requireList[k]
--     -- print("加载", require_name, k)
--     if require_name and not loading_module_list[require_name] then
--        requireList[k] = nil
--        loading_module_list[require_name] = true
--        local load_state = require (require_name)
--        if type(load_state) == "boolean" then
--            return _G[k]
--        else
--            return load_state
--        end
--     end
-- end

requireList = requireList or {}
ClassToFile = ClassToFile or {}
local loading_module_list = {}
local parentG = {}
setmetatable(_G, parentG)
parentG.__index = function(t, k)
    local require_name = requireList[k] or ClassToFile[k]
    if require_name and not loading_module_list[require_name] then
        requireList[k] = nil
        ClassToFile[k] = nil
        loading_module_list[require_name] = true
        if _require (require_name) then
            -- print("配置啊", UtilsBase.TableLen(requireList), UtilsBase.TableLen(ClassToFile), require_name, k)
            return _G[k]
        else
            return false
        end
    end
end


-- 这个虚表重启的时候要清掉，不然越来越大
function clearSuperClass()
    if not IS_WINDOW then return end
    print("clearSuperClass")
    _class = {}
    parentG = {}
    requireList = {}
    loading_module_list = {}
    collectgarbage("collect")
end
