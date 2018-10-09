BehaviourTreeActionNode = BehaviourTreeActionNode or BaseClass(BehaviourTreeNode)

function BehaviourTreeActionNode:Run(entity)
    return BehaviourTree.RunTimeResultEnum.Succeed
end