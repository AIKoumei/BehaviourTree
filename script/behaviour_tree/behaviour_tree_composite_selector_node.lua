-- updated : 2018.10.10 实现了基础功能，运行节点的状态，返回节点的状态

-- 组合节点，选择节点
-- 该节点会从左到右的依次执行其子节点，只要子节点返回“失败”，就继续执行后面的节点，直到有一个节点返回“运行中”或“成功”时，会停止后续节点的运行，并且向父节点返回“运行中”或“成功”，如果所有子节点都返回“失败”则向父节点返回“失败”。
BehaviourTreeCompositeSelectorNode = BehaviourTreeCompositeSelectorNode or BaseClass(BehaviourTreeCompositeNode)


------------------------------------------------
-- # 方法
------------------------------------------------
-- 执行方法
function BehaviourTreeCompositeSelectorNode:Run(entity, callback)
    if callback then callback() end
    local data = BehaviourTree.GetBlackboardData(entity)
    local childs = self:GetChilds()
    local running = (data.running_node == self) and childs[1] or (self:IsChilds(data.running_node)) and self:GetNextChild(data.running_node) or childs[1]
    -- 运行节点
    self:OnEnter()
    return running:Run(entity, function() self:OnExit() end)
end

-- 接受运行结果
-- 当节点运行完毕，返回给父节点的时候，调用该方法，更新下次运行的节点
function BehaviourTreeCompositeSelectorNode:ReciveRunResult(result, entity, running_node)
    self:OnEnter()
    self:DebugPrint(string.format(" result : %s", result))
    local data = BehaviourTree.GetBlackboardData(entity)
    if result == BehaviourTree.RunTimeResultEnum.Running then
        data.running_node = running_node
    elseif result == BehaviourTree.RunTimeResultEnum.Failed then
        local childs = self:GetChilds()
        if running_node == childs[#childs] then
            local parent = self:GetParent()
            if parent then
                self:OnExit()
                return parent:ReciveRunResult(result, entity, self)
            else
                data.running_node = nil
            end
        else
            data.running_node = self:GetNextChild(running_node)
        end
    elseif result == BehaviourTree.RunTimeResultEnum.Succeed then
        local parent = self:GetParent()
        if parent then
            self:OnExit()
            return parent:ReciveRunResult(result, entity, self)
        else
            data.running_node = nil
        end
    end
    self:OnExit()
    return result, entity, data.running_node
end