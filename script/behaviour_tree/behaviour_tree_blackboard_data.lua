-- 黑板数据结构
BehaviourTreeBlackboardData = BehaviourTreeBlackboardData or BaseClass()

function BehaviourTreeBlackboardData:__init()
    self.running_node = nil     -- 执行中的节点
end

function BehaviourTreeBlackboardData:__delete()
    self.running_node = nil     -- 执行中的节点
end

function BehaviourTreeBlackboardData:Reset()
    self.running_node = nil     -- 执行中的节点
end