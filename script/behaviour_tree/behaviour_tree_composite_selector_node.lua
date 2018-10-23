-- updated : 2018.10.10 实现了基础功能，运行节点的状态，返回节点的状态

-- 组合节点，选择节点
-- 该节点会从左到右的依次执行其子节点，只要子节点返回“失败”，就继续执行后面的节点，直到有一个节点返回“运行中”或“成功”时，会停止后续节点的运行，并且向父节点返回“运行中”或“成功”，如果所有子节点都返回“失败”则向父节点返回“失败”。
BehaviourTreeCompositeSelectorNode = BehaviourTreeCompositeSelectorNode or BaseClass(BehaviourTreeCompositeNode)


------------------------------------------------
-- # 方法
------------------------------------------------
-- 执行方法
-- function BehaviourTreeCompositeSelectorNode:Run(entity, callback)
--     if callback then callback() end
--     local data = BehaviourTree.GetBlackboardData(entity)
--     local childs = self:GetChilds()
--     -- 运行节点
--     self:OnEnter()
--     self:DebugPrint(string.format(" Node<%s> is running ", self.name))
--     -- 如果直接调用节点 run 的，就是执行当前节点
--     if not data.running_node then
--         data.running_node = self
--         self:OnExit()
--         return BehaviourTree.RunTimeResultEnum.Running, entity, self
--     else
--         -- 如果不是相邻节点，警告一下
--         local node = data.running_node
--         if node ~= self and (not self:GetParent() and true or node ~= self:GetParent()) and not self:ContainChild(node) then
--             self:DebugPrint(string.format("[Msg] Node<%s> is not nearby RunningNode<%s> ", self.name, node.name))
--         end
--     end
--     -- 判断当前节点
--     -- local running = (data.running_node == self) and childs[1] or (self:ContainChild(data.running_node)) and self:GetNextChild(data.running_node)
--     local running = data.running_node
--     if data.running_node == self then 
--         -- 如果是当前运行节点是自己，就拿第一个自己子节点运行
--         data.running_node = childs[1]
--     elseif self:ContainChild(running) then
--         -- 如果是子节点，直接运行
--     elseif running:ContainChild(self) then
--         -- 如果是父节点，下一步再执行自己
--         data.running_node = self
--     end
--     local running = data.running_node
--     self:DebugPrint(string.format(" next running node is %s<%s>", running.node_type, running.name))
--     return running:Run(entity, function() self:OnExit() end)
-- end

-- -- 接受运行结果
-- -- 当节点运行完毕，返回给父节点的时候，调用该方法，更新下次运行的节点
-- function BehaviourTreeCompositeSelectorNode:ReciveRunResult(result, entity, running_node)
--     self:OnEnter()
--     self:DebugPrint(string.format(" result : %s", result))
--     self:DebugPrint(string.format(" from %s<%s> to %s<%s>", running_node.node_type, running_node.name, self.node_type, self.name))
    
--     local data = BehaviourTree.GetBlackboardData(entity)
--     if result == BehaviourTree.RunTimeResultEnum.Running then
--         data.running_node = self
--     elseif result == BehaviourTree.RunTimeResultEnum.Failed then
--         local childs = self:GetChilds()
--         if running_node == childs[#childs] then
--             local parent = self:GetParent()
--             if parent then
--                 data.running_node = parent
--                 self:OnExit()
--                 return parent:ReciveRunResult(result, entity, self)
--             else
--                 data.running_node = nil
--             end
--         else
--             data.running_node = self:GetNextChild(running_node)
--         end
--     elseif result == BehaviourTree.RunTimeResultEnum.Succeed then
--         local parent = self:GetParent()
--         if parent then
--             data.running_node = parent
--             self:OnExit()
--             return parent:ReciveRunResult(result, entity, self)
--         else
--             data.running_node = nil
--         end
--     end
--     self:OnExit()
--     return result, entity, data.running_node
-- end

-- 执行方法
-- 每次执行都讲结果保存
function BehaviourTreeCompositeSelectorNode:Run(entity, callback)
    if callback then callback() end
    local data = BehaviourTree.GetBlackboardData(entity)
    local childs = self:GetChilds()
    -- 进入节点
    self:OnEnter()
    -- 运行节点
    -- 2、现在应该不会这样了
    -- -- 如果不是最近的节点，就运行黑板数据的节点
    -- local node = data.running_node
    -- if self:NearBy(node) then
    --     self:DebugPrint(string.format("[Msg] Node<%s> is not nearby RunningNode<%s> ", self.name, node.name))
    --     self:OnExit()
    --     return node:Run(entity)
    -- end
    -- 根据结果决定，是返回，还是继续运行
    local result = data.result
    if result == BehaviourTree.RunTimeResultEnum.Failed then
        -- 如果是失败
        -- 如果上一个节点不是
    end
    -- 退出节点
    self:OnExit()
end