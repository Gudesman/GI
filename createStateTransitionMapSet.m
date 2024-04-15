function delta = createStateTransitionMapSet(S_plus)
    delta = containers.Map('KeyType', 'char', 'ValueType', 'char');
    stateCounter = 0; % 状态计数器
    queue = {}; % 初始化队列

    % 将初始状态和每个动作序列入队
    for i = 1:length(S_plus)
        queue{end+1} = {'q0', S_plus{i}, 1}; % 存储状态、动作序列及当前动作序列的索引
    end
    
    % 广度优先遍历
    while ~isempty(queue)
        % 出队
        currentData = queue{1};
        queue(1) = [];
        currentState = currentData{1};
        actionSequence = currentData{2};
        seqIndex = currentData{3};
        
        % 如果动作序列已经结束，继续下一轮循环
        if seqIndex > length(actionSequence)
            continue
        end
        
        % 获取动作并生成键
        action = actionSequence(seqIndex);
        key = ['(' currentState ',' action ')'];
        
        % 如果键不存在，则创建新状态并入队新状态和剩余动作序列
        if ~isKey(delta, key)
            stateCounter = stateCounter + 1; % 更新状态计数器
            nextState = ['q' num2str(stateCounter)]; % 生成新状态
            delta(key) = nextState;
            queue{end+1} = {nextState, actionSequence, seqIndex + 1}; % 入队
        else
            nextState = delta(key); % 使用已有状态
            queue{end+1} = {nextState, actionSequence, seqIndex + 1}; % 入队
        end
    end
end