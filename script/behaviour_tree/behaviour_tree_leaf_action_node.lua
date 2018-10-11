-- updated :    2018.10.11  zhm  实现了子叶节点的逻辑

BehaviourTreeLeafActionNode = BehaviourTreeLeafActionNode or BaseClass(BehaviourTreeLeafNode)

function BehaviourTreeLeafActionNode:__init(args)
    args = args or {}
    self.run_func = self.run_func or (type(args.Run) == "function") and args.Run or function() return self.result end
    self.run_func = self.run_func or (type(args[1]) == "function") and args[1] or function() return self.result end

    self.on_enter = self.on_enter or (type(args.OnEnter) == "function") and args.OnEnter or function() end
    self.on_enter = self.on_enter or (type(args[2]) == "function") and args[2] or function() end

    self.on_exit = self.on_exit or (type(args.OnExit) == "function") and args.OnExit or function() end
    self.on_exit = self.on_exit or (type(args[3]) == "function") and args[3] or function() end

    self.result = self.result or args.result
    self.result = self.result or args[4]
    self.result = self.result or BehaviourTree.RunTimeResultEnum.Succeed    -- 简单返回值
end

function BehaviourTreeLeafActionNode:__delete()
    self.run_func = nil
    self.on_enter = nil
    self.on_exit = nil
end

------------------------------------------------
-- # 方法
------------------------------------------------
-- 执行方法
function BehaviourTreeLeafActionNode:Run(entity, callback)
    if callback then callback() end
    local data = BehaviourTree.GetBlackboardData(entity)
    -- 运行节点
    self:OnEnter()
    local result = self:run_func(entity, data)
    if self:CanDebugPrint() then
        BehaviourTree.DebugPrintInfo(string.format(" LeafNode<%s> run_func don't have result ", self.name))
    end
    result = result or self.result
    self:OnExit()
    return self:GetParent():ReciveRunResult(result, entity, self)
end