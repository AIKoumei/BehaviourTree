-- TODO
-- <1> 设置打印等级
-- <2> 单次运行只执行一个节点

require "behaviour_tree.behaviour_tree_blackboard_data"
require "behaviour_tree.behaviour_tree_node"
require "behaviour_tree.behaviour_tree_composite_node"
require "behaviour_tree.behaviour_tree_composite_selector_node"
require "behaviour_tree.behaviour_tree_leaf_node"
require "behaviour_tree.behaviour_tree_leaf_action_node"

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
    [BehaviourTree.NodeTypeEnum.Leaf] = "BehaviourTreeLeafNode",
    [BehaviourTree.NodeTypeEnum.Leaf.Action] = "BehaviourTreeLeafActionNode",
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
    -- 调试打印
    DebugPrint = true,
    -- 数据黑板
    Blackboard = {
        -- 黑板初始大小
        MaxId = 1000,
        -- 当 hash 获取 id 失败的时候，扩张 MaxId 的大小
        IdPlusStep = 10,
        -- 预留，最大扩张 id
        MaxExtendId = 100000,
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
    local data = BehaviourTree.GetBlackboardData(entity)
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
function BehaviourTree.GetBlackboardData(entity)
    return BehaviourTree.__blackboard[entity.__blackboard_id]
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
    local MaxId = BehaviourTree.Config.Blackboard.MaxId
    --
    local bbdata = BehaviourTreeBlackboardData.New()
    bbdata.data = data
    -- gen id
    local id = math.random(1, MaxId)
    while (BehaviourTree.__blackboard_id_cache[id]) do
        MaxId = MaxId + BehaviourTree.Config.Blackboard.IdPlusStep
        id = math.random(1, MaxId)
    end
    data.__blackboard_id = id
    bbdata.id = id
    BehaviourTree.__blackboard[id] = bbdata
    --
    BehaviourTree.Config.Blackboard.MaxId = MaxId
end

------------------------------------------------
-- # 创建节点
------------------------------------------------
-- args :   name, node_type, parent_node, childs
function BehaviourTree.CreateNode(args)
    local class = _G[BehaviourTree.NodeClassEnum[args.node_type]]
    if class and class.New then
        return class.New(args)
    else
        BehaviourTree.DebugPrint(string.format(" NodeType[%s] 创建失败", args.node_type))
        BehaviourTree.DebugPrint(string.format("     BehaviourTree.NodeClassEnum -> %s", BehaviourTree.NodeClassEnum[args.node_type]))
        BehaviourTree.DebugPrint(string.format("     _G[type] -> %s", _G[BehaviourTree.NodeClassEnum[args.node_type]]))
    end
end

-- args :   
--      [1] or Run      : 运行方法，当运行该节点的时候调用
--      [2] or Enter    : 进入方法，当进入该节点的时候调用
--      [3] or Exit     : 离开方法，当离开该节点的时候调用
--      [4] or result   : 默认返回值，不填为运行成功
function BehaviourTree.CreateActionNode(args)
    args.node_type = BehaviourTree.NodeTypeEnum.Leaf.Action
    return BehaviourTree.CreateNode(args)
end

------------------------------------------------
-- # 调试
------------------------------------------------
function BehaviourTree.DebugPrint(msg)
    print("[BehaviourTree Debug]", msg)
end

function BehaviourTree.DebugPrintInfo(msg)
    print("[BehaviourTree Debug][Info]", msg)
end

------------------------------------------------
-- # 测试
------------------------------------------------
function BehaviourTree.Test()
    local root = BehaviourTree.CreateNode({
        name = "root", 
        node_type = BehaviourTree.NodeTypeEnum.Composite.Selector,
    })

    local enter_door = BehaviourTree.CreateNode({
        name = "enter_door",
        node_type = BehaviourTree.NodeTypeEnum.Composite.Selector,
        OnEnter = function() 
            print("我要进门")
        end,
    })
    enter_door:SetParent(root)

    local is_door_locked = BehaviourTree.CreateActionNode({
        name = "is_door_locked",
        OnEnter = function() 
            print("我看下门锁了没有")
        end,
        Run = function() 
            print("门锁上了")
        end,
        result = BehaviourTree.RunTimeResultEnum.Failed
    })
    is_door_locked:SetParent(enter_door)

    local find_key = BehaviourTree.CreateNode({
        name = "find_key",
        node_type = BehaviourTree.NodeTypeEnum.Composite.Selector,
        OnEnter = function() 
            print("找钥匙")
        end,
        OnExit = function() 
            print("不找钥匙了")
        end,
    })
    local find_key_near_plant = BehaviourTree.CreateActionNode({
        name = "find_key_near_plant",
        OnEnter = function()
            print("我记得我好像把备用钥匙放到花盆附近了")
        end,
        Run = function() 
            print("花盆底下找不到钥匙")
        end,
        OnExit = function() 
            print("不在花盆这里找钥匙了")
        end,
        result = BehaviourTree.RunTimeResultEnum.Failed
    })
    find_key_near_plant:SetParent(find_key)
    local find_key_near_stage = BehaviourTree.CreateActionNode({
        name = "find_key_near_stage",
        OnEnter = function()
            print("我记得我好像把备用钥匙放到台阶附近了")
        end,
        Run = function() 
            print("台阶底下找不到钥匙")
        end,
        OnExit = function() 
            print("不在台阶这里找钥匙了")
        end,
        result = BehaviourTree.RunTimeResultEnum.Failed
    })
    find_key_near_stage:SetParent(find_key)
    find_key:SetParent(enter_door)

    local through_the_wall = BehaviourTree.CreateActionNode({
        name = "through_the_wall",
        OnEnter = function()
            print("还是翻墙进去吧...")
        end,
        Run = function() 
            print("翻墙中...")
        end,
        result = BehaviourTree.RunTimeResultEnum.Failed
    })
    through_the_wall:SetParent(enter_door)

    local break_the_wall = BehaviourTree.CreateActionNode({
        name = "break_the_wall",
        OnEnter = function()
            print("还是爆破进去吧...")
        end,
        Run = function() 
            print("爆破中...")
        end,
        result = BehaviourTree.RunTimeResultEnum.Succeed
    })
    break_the_wall:SetParent(enter_door)

    PrintUtil.LogPrint("BehaviourTree Test")
    local entity = {}
    BehaviourTree.SetBlackboardData(entity)
    local result, entity, node = root:Run(entity)
    local limit_times = 1000
    local times = 1
    while(node and times <= limit_times) do
        BehaviourTree.DebugPrint(string.format(" %s<%s> is running in one step, result : %s", node.node_type, node.name, result))
        result, entity, node = root:Run(entity)
        times = times + 1
    end
    print("times", times)
    PrintUtil.LogPrint("BehaviourTree End")
end