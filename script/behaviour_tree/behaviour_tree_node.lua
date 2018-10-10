BehaviourTreeNode = BehaviourTreeNode or BaseClass()

function BehaviourTreeNode:__init(args)
    args = args or {}
    self.node_type = args.node_type
    self.parent = args.parent
    self.childs = args.childs
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
end

function BehaviourTreeNode:GetParent()
    return self.parent
end

function BehaviourTreeNode:SetChilds(childs)
    self.childs = childs
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

function BehaviourTreeNode:IsChilds(node)
    for _, child in ipairs(self.childs) do
        if child == node then return true end
    end
    return false
end

function BehaviourTreeNode:ToString()
    return ""
end

------------------------------------------------
-- # 方法
------------------------------------------------
-- 执行方法
function BehaviourTreeNode:Run(entity)
    return BehaviourTree.RunTimeResultEnum.Succeed
end

-- 接受运行结果
-- 当节点运行完毕，返回给父节点的时候，调用该方法，更新下次运行的节点
function BehaviourTreeNode:ReciveRunResult(entity, running_node, result)
end