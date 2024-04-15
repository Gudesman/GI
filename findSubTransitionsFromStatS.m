
function [subTransitions,actionSequences] = findSubTransitionsFromStatS(A,q_u)
    % 初始化子转换关系和动作序列的容器
    subTransitions = containers.Map('KeyType', 'char', 'ValueType', 'any');
    actionSequences = {}; % 动作序列存储为cell数组

    % 初始化遍历的队列（使用cell数组模拟队列）
    queue = {{q_u, ''}}; % 初始状态和初始动作序列

    % 遍历直到队列为空
    while ~isempty(queue)
        % 出队当前元素
        currentStateAction = queue{1};
        queue(1) = []; % 移除已处理的元素

        currentState = currentStateAction{1};
        currentSequence = currentStateAction{2};

        % 遍历A.delta找到当前状态的所有可能转换
        keys = A.delta.keys;
        for i = 1:length(keys)
            key = keys{i}; % 获取当前的键
            % 解析状态和输入
            parts = strsplit(key, {',', '(', ')'});
            state = strtrim(parts{2}); % 获取状态
            input = strtrim(parts{3}); % 获取输入
            
            % 如果当前状态匹配
            if strcmp(state, currentState)
                % 获取转换后的状态
                nextState = A.delta(key);
                % 构建新的动作序列
                newSequence = [currentSequence, input];
                
                % 保存转换
                if ~isKey(subTransitions, key)
                    subTransitions(key) = nextState;
                end
                
                % 无论nextState是否为接收状态，都继续探索
                queue{end+1} = {nextState, newSequence};
                
                % 如果nextState是接收状态，则保存动作序列
                if ismember(nextState, A.F_A)
                    if ~any(cellfun(@(x) isequal(x, newSequence), actionSequences))
                        actionSequences{end+1} = newSequence;
                    end
                end
            end
        end
    end
end

%{
function actionSequences = findSubTransitionsFromStatS(A,q_u)
    % 初始化子转换关系和动作序列的容器
    subTransitions = containers.Map('KeyType', 'char', 'ValueType', 'any');
    actionSequences = {}; % 动作序列存储为cell数组

    % 初始化遍历的队列（使用cell数组模拟队列）
    queue = {{q_u, ''}}; % 初始状态和初始动作序列
  
    % 遍历直到队列为空
    while ~isempty(queue)
        % 出队当前元素
        currentStateAction = queue{1};
        queue(1) = []; % 移除已处理的元素

        currentState = currentStateAction{1};
        currentSequence = currentStateAction{2};

        % 遍历A.delta找到当前状态的所有可能转换
        keys = A.delta.keys;
        for i = 1:length(keys)
            key = keys{i}; % 获取当前的键
            % 解析状态和输入
            parts = strsplit(key, {',', '(', ')'});
            state = strtrim(parts{2}); % 获取状态
            input = strtrim(parts{3}); % 获取输入
            
            % 如果当前状态匹配
            if strcmp(state, currentState)
                % 获取转换后的状态
                nextState = A.delta(key);
                % 构建新的动作序列
                newSequence = strcat(currentSequence, input);
                
                % 保存转换
                subTransitions(key) = nextState;
                
                % 如果nextState是接收状态，则保存动作序列
                if ismember(nextState, A.F_A)
                    actionSequences{end+1} = newSequence;
                end
                
                % 继续搜索，无论nextState是否为接收状态
                queue{end+1} = {nextState, newSequence};
            end
        end
    end
end
%}