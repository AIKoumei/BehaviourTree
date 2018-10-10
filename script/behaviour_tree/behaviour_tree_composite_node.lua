-- 组合节点
BehaviourTreeCompositeNode = BehaviourTreeCompositeNode or BaseClass(BehaviourTreeNode)


------------------------------------------------
-- # 方法
------------------------------------------------
-- 接受运行结果
-- 当节点运行完毕，返回给父节点的时候，调用该方法，更新下次运行的节点
function BehaviourTreeCompositeNode:ReciveRunResult(entity, running_node, result)
end