BehaviourTree = BehaviourTree or BaseClass()

-- 节点类型枚举
BehaviourTree.NodeTypeEnum = {
    Decorator = {
        -- 对结果取非，成功返回失败，失败返回成功，运行中返回运行中
        Invert = "Decorator.Invert"
        -- 运行中和失败状态 都会返回 运行中状态，直到成功的时候返回成功
        , UntilSuccess = "Decorator.UntilSuccess"
        -- 运行中和成功状态 都会返回 运行中状态，直到失败的时候返回成功
        , UntilFailure = "Decorator.UntilFailure"
        , Limit = "Decorator.Limit"
        , TimeLimit = "Decorator.TimeLimit"
        -- 平行运行所有第一层子节点，当所有第一层子节点结束后，根据子节点的结果返回相应的结果
        , Parallel = "Composite.Parallel"
    }
    , Composite = {
        -- 从左向右执行子节点，子节点返回失败，继续执行下一个子节点，子节点返回成功，终止执行并返回成功
        Selector = "Composite.Selector"
        -- 随机不重复执行子节点，子节点返回失败，继续执行下一个子节点，子节点返回成功，终止执行并返回成功
        , RandomSelector = "Composite.RandomSelector"
        -- 从左向右执行子节点，子节点返回失败，终止执行并返回失败，子节点返回成功，继续执行下一个子节点，直到所有子节点返回成功时，返回成功
        , Sequence = "Composite.Sequence"
    }, Parallel = {
        -- 任意个子节点成功，返回成功
        AnySuccess = "Parallel.AnySuccess"
        -- 所有子节点成功，返回成功
        , AllSuccess = "Parallel.AllSuccess"
        -- 有任意成功或失败，返回成功或失败
        , AnyResult = "Parallel.AnyResult"
    }, Leaf = {
        -- 执行节点，执行一个动作
        Action = "Leaf.Action"
        -- 条件节点，跟执行节点没有什么不同，应该
        , Condition = "Leaf.Condition"
    }
}

-- 节点执行结果枚举
BehaviourTree.RunTimeResultEnum = {
    Running = "RunTimeResultEnum.Running"
    , Failed = "RunTimeResultEnum.Failed"
    , Succeed = "RunTimeResultEnum.Succeed"
}

BehaviourTree.FunctionEnum = {
    BehaviourTree.NodeTypeEnum.Action = "Run"
}

function BehaviourTree:__init()
    if BehaviourTree.Instance then
        return 
    end
    BehaviourTree.Instance = self

end

function BehaviourTree:__delete()
end

function BehaviourTree.Run(node)
    local func = node[BehaviourTree.FunctionEnum[node:GetNodeType()]]
    if func then return func(node) 
    else return BehaviourTree.RunTimeResultEnum.Failed end
end