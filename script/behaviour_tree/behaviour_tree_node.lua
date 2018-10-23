BehaviourTreeNode = BehaviourTreeNode or BaseClass()

function BehaviourTreeNode:__init(args)
    args = args or {}
    self.name = self.name or args.name or string.format("<Unknow BTNode(%s)>", args.node_type)
    self.node_type = self.node_type or args.node_type
    self.parent = self.parent or args.parent
    self.childs = self.childs or args.childs

    -- function
    self.on_enter = self.on_enter or (type(args.OnEnter) == "function") and args.OnEnter or function() end
    self.on_exit = self.on_exit or (type(args.OnExit) == "function") and args.OnExit or function() end

    self.debug = args.debug or false                -- 调试开关，全开
    self.debug_print = args.debug_print or false    -- 调试打印开关
end

function BehaviourTreeNode:__delete()
end

------------------------------------------------
-- # 属性
------------------------------------------------
function BehaviourTreeNode:Clone()
    local node = BehaviourTreeNode.New(self.node_type)
    return node
end

function BehaviourTreeNode:Reset()
    self.node_type = nil
    self.parent = nil
end

function BehaviourTreeNode:GetNodeType()
    return self.node_type
end

function BehaviourTreeNode:SetParent(parent)
    self.parent = parent
    parent:AddChild(self)
end

function BehaviourTreeNode:GetParent()
    return self.parent
end

function BehaviourTreeNode:SetChilds(childs)
    self.childs = childs
end

function BehaviourTreeNode:AddChild(child)
    self.childs = self.childs or {}
    table.insert(self.childs, child)
end

function BehaviourTreeNode:AddChilds(childs)
    self.childs = self.childs or {}
    for _, child in ipairs(childs or {}) do
        table.insert(self.childs, child)
    end
end

function BehaviourTreeNode:GetChilds()
    return self.childs
end

function BehaviourTreeNode:GetNextChild(node)
    local pre_node
    for _, child in ipairs(self.childs) do
        if pre_node == node then
            return child
        end
        pre_node = child
    end
end

-- 子节点是否包含目标节点
function BehaviourTreeNode:ContainChild(node)
    for _, child in ipairs(self.childs) do
        if child == node then return true end
    end
    return false
end

-- 当前节点是否与目标节点相邻
function BehaviourTreeNode:NearBy(node)
    return node ~= self and (not node:GetParent() or self ~= node:GetParent()) and not node:ContainChild(self)
end

function BehaviourTreeNode:ToString()
    return ""
end

------------------------------------------------
-- # 方法
------------------------------------------------
-- 执行方法
function BehaviourTreeNode:Run(entity, callback)
    if callback then callback() end         --  一般是执行上一个节点的 OnExit 方法
    return self.result or BehaviourTree.RunTimeResultEnum.Succeed
end

-- 接受运行结果
-- 当节点运行完毕，返回给父节点的时候，调用该方法，更新下次运行的节点
function BehaviourTreeNode:ReciveRunResult(result, entity, running_node)
    self:OnEnter()
    local data = BehaviourTree.GetBlackboardData(entity)
    if result == BehaviourTree.RunTimeResultEnum.Running then
        data.running_node = running_node
    elseif result == BehaviourTree.RunTimeResultEnum.Failed then
        data.running_node = nil
    elseif result == BehaviourTree.RunTimeResultEnum.Succeed then
        data.running_node = nil
    end
    self:OnExit()
    return result, entity, data.running_node
end

-- 进入节点执行该方法
function BehaviourTreeNode:OnEnter(...)
    if self:CanDebugPrint() then
        BehaviourTree.DebugPrint(" enter " .. self.name)
    end
    self:on_enter()
end

-- 退出节点执行该方法
function BehaviourTreeNode:OnExit(...)
    if self:CanDebugPrint() then
        BehaviourTree.DebugPrint(" exit " .. self.name)
    end
    self:on_exit()
end

------------------------------------------------
-- # 调试
------------------------------------------------
function BehaviourTreeNode:CanDebugPrint()
    return BehaviourTree.DebugPrint or self.debug_print or self.debug
end

function BehaviourTreeNode:DebugPrint(doit)
    if self:CanDebugPrint() then
        if type(doit) == "string" then
            BehaviourTree.DebugPrint(doit)
        elseif type(doit) == "function" then
            doit()
        end
    end
end