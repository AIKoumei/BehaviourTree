require "behaviour_tree.behaviour_tree_node"
require "behaviour_tree.behaviour_tree_action_node"

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

BehaviourTree.NodeClassEnum = {
    [BehaviourTree.NodeTypeEnum.Decorator] = "",
    [BehaviourTree.NodeTypeEnum.Decorator.Invert] = "",
    [BehaviourTree.NodeTypeEnum.Decorator.UntilSuccess] = "",
    [BehaviourTree.NodeTypeEnum.Decorator.UntilFailure] = "",
    [BehaviourTree.NodeTypeEnum.Decorator.Limit] = "",
    [BehaviourTree.NodeTypeEnum.Decorator.TimeLimit] = "",
    -- [BehaviourTree.NodeTypeEnum.Decorator.Parallel] = "",
    [BehaviourTree.NodeTypeEnum.Composite] = "BehaviourTreeCompositeNode",
    [BehaviourTree.NodeTypeEnum.Composite.Selector] = "BehaviourTreeCompositeSelectorNode",
    [BehaviourTree.NodeTypeEnum.Composite.RandomSelector] = "",
    [BehaviourTree.NodeTypeEnum.Composite.Sequence] = "",
    -- [BehaviourTree.NodeTypeEnum.Parallel.AnySuccess] = "",
    -- [BehaviourTree.NodeTypeEnum.Parallel.AllSuccess] = "",
    -- [BehaviourTree.NodeTypeEnum.Parallel.AnyResult] = "",
    [BehaviourTree.NodeTypeEnum.Leaf] = "",
    [BehaviourTree.NodeTypeEnum.Leaf.Action] = "",
    [BehaviourTree.NodeTypeEnum.Leaf.Condition] = "",
}

-- 节点执行结果枚举
BehaviourTree.RunTimeResultEnum = {
    Running = "RunTimeResultEnum.Running",
    Failed = "RunTimeResultEnum.Failed",
    Succeed = "RunTimeResultEnum.Succeed",
}

BehaviourTree.FunctionEnum = {
    [BehaviourTree.NodeTypeEnum.Leaf.Action] = "Run"
}


------------------------------------------------
-- # 参数声明
------------------------------------------------
-- 数据黑板
BehaviourTree.__blackboard = BehaviourTree.__blackboard or {}
BehaviourTree.__blackboard_id_cache = BehaviourTree.__blackboard_id_cache or {}
BehaviourTree.Config = {
    -- 数据黑板
    Blackboard = {
        -- 黑板初始大小
        max_id = 1000,
        -- 当 hash 获取 id 失败的时候，扩张 max_id 的大小
        id_plus_step = 10,
        -- 预留，最大扩张 id
        max_extend_id = 100000,
    }
}


------------------------------------------------
-- # 初始化
------------------------------------------------
function BehaviourTree:__init()
    if BehaviourTree.Instance then
        return 
    end
    BehaviourTree.Instance = self
end

function BehaviourTree:__delete()
end

function BehaviourTree.Run(node, entity)
    -- local func = node[BehaviourTree.FunctionEnum[node:GetNodeType()]]
    -- if func then return func(node) 
    -- else return BehaviourTree.RunTimeResultEnum.Failed end
    return node:Run(entity)
end

------------------------------------------------
-- # 数据存取
------------------------------------------------
-- 数据黑板
function BehaviourTree.GetBlackboard()
    return BehaviourTree.__blackboard
end

-- 根据 id 获取黑板数据
function BehaviourTree.GetBlackboardData(data)
    return BehaviourTree.__blackboard[data.__blackboard_id]
end

-- 根据 id 获取黑板数据
function BehaviourTree.GetBlackboardDataById(id)
    return BehaviourTree.__blackboard[id]
end

-- 获取黑板数据 id
function BehaviourTree.GetBlackboardDataId(data)
    return data.__blackboard_id
end

function BehaviourTree.SetBlackboardData(data)
    local max_id = BehaviourTree.Config.Blackboard.max_id
    --
    local bbdata = BehaviourTreeBlackboardData.New()
    bbdata.data = data
    -- gen id
    local id = math.random(1, max_id)
    while (BehaviourTree.__blackboard_id_cache[id]) do
        max_id = max_id + BehaviourTree.Config.Blackboard.id_plus_step
        id = math.random(1, max_id)
    end
    data.__blackboard_id = id
    BehaviourTree.__blackboard[id] = data
    --
    BehaviourTree.Config.Blackboard.max_id = max_id
end

------------------------------------------------
-- # 创建节点
------------------------------------------------
-- args :   node_type, parent_node, childs
function BehaviourTree.CreateNode(args)
    local class = _G[BehaviourTree.NodeClassEnum[args.node_type]]
    if class and class.New then
        return class.New(args)
    end
end

------------------------------------------------
-- # 测试
------------------------------------------------
function BehaviourTree.Test()
    -- local root = BehaviourTree.CreateNode()
end