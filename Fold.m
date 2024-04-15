S_plus = {'aaac','abbac','accba','bacc','baac','bcac','cabaac','caacab'};%输入正数据集
S_minus = {'abba','cabcb','ccba','bbbca','ab','caabc'};%输入负数据集
A = Build_PTA(S_plus, S_minus);%根据S_plus和S_minus构建前缀生成树
q0='q0';
q1='q1';
subTransitionq_u = findUniqueTransitions(A, q0, q1);
       keys =subTransitionq_u.keys;
       for k = 1:length(keys)
           key = keys{k};
           value = A.delta(key);
           fprintf('%s -> %s\n', key, value);
        end 
%disp(subTransitionq_u);

function subTransitionq_u = findUniqueTransitions(A, q0, q1)
    % 初始化subTransitionq_u为一个空的Map对象
    subTransitionq_u = containers.Map('KeyType', 'char', 'ValueType', 'any');
    
    % 调试信息：输出起始状态
    disp(['Starting comparisons from q0: ' q0 ' and q1: ' q1]);
    
    % 初始化两个状态的转换关系
    transitions_q0 = getNextStates(A.delta, q0);
    transitions_q1 = getNextStates(A.delta, q1);
    
    % 调试信息：输出转换状态数量
    disp(['Number of transitions from q0: ' num2str(numel(fields(transitions_q0)))]);
    disp(['Number of transitions from q1: ' num2str(numel(fields(transitions_q1)))]);

    % 比较q1的转换是否在q0中也存在
    for actionField = fields(transitions_q1)'
        action = actionField{1};
        if ~isfield(transitions_q0, action)
            % 如果在q0的转换中找不到，添加到结果中
            subTransitionq_u(action) = transitions_q1.(action);
            % 调试信息：输出添加的转换
            disp(['Adding unique transition for action: ' action ', leads to: ' transitions_q1.(action)]);
        end
    end
end

function transitions = getNextStates(delta, state)
    transitions = struct(); % 初始化返回值
    for key = keys(delta)'
        keyStr = key{1}; % 转换为字符串
        tokens = strsplit(keyStr, {'(', ',', ')'}, 'CollapseDelimiters', true);
        if numel(tokens) < 3
            continue; % 如果分割后的元素数量不足，跳过此次循环
        end
        if strcmp(tokens{2}, state)
            action = tokens{3}; % 动作
            nextState = delta(keyStr); % 下一个状态
            transitions.(action) = nextState;
            % 调试信息：输出找到的转换
            disp(['Found transition for state: ' state ', action: ' action ', leads to: ' nextState]);
        end
    end
end

