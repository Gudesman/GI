function A = Build_PTA(S_plus, S_minus)
    A.Sigma = unique([S_plus{:} S_minus{:}]); % Assuming Sigma is the set of unique symbols in samples
    A.States={};%状态集合
    A.q0 = 'q0';  % Initial state
    A.F_A = {};  % Accept states
    A.F_R = {};  % Reject states
    A.delta = containers.Map;  % Transition function as a map
    
    B.Sigma = {}; % Assuming Sigma is the set of unique symbols in samples
    B.States={};%状态集合
    B.q0 = 'q0';  % Initial state
    B.F_A = {};  % Accept states
    B.F_R = {};  % Reject states
    B.delta = containers.Map;  % Transition function as a map
    %A.delta = delta;
    B=A;
    A.delta = createStateTransitionMapSet(S_plus);

    %
    for i = 1:length(S_plus)
        sequence = S_plus{i};
        S = 'q0'  ; % 假设'q0'是初始状态
        
        % 遍历序列中的每个动作
        for j = 1:length(sequence)
            action = sequence(j);
            transitionKey = ['(' S, ',', action ')'];
            % 检查转换是否存在
            if isKey(A.delta, transitionKey)
                S = A.delta(transitionKey); % 进行状态转换
            else
                % 如果转换不存在，假设是确定性有限自动机(DFA)的非法转换
                break; % 跳出循环
            end
        end
 
        % 序列结束，将当前状态添加到接受状态集F_A中
        A.F_A = union(A.F_A, {S});
            % Convert the state names to numbers by removing the 'q' prefix and sorting
        [~, idx] = sort(str2double(strrep(A.F_A, 'q', '')), 'ascend');
        % Use the index to sort the states
        A.F_A = A.F_A(idx);
    end

    for i = 1:length(S_minus)
        sequence = S_minus{i};
        S = 'q0'  ; % 假设'q0'是初始状态
        
        % 遍历序列中的每个动作
        for j = 1:length(sequence)
            
            action = sequence(j);
            transitionKey = ['(' S, ',', action ')'];
            % 检查转换是否存在
            if isKey(A.delta, transitionKey)
                S = A.delta(transitionKey); % 进行状态转换
            else
                % 如果转换不存在，假设是确定性有限自动机(DFA)的非法转换
                break; % 跳出循环
            end
        end
        
        % 序列结束，将当前状态添加到接受状态集F_A中
        A.F_R= union(A.F_R, {S});
    end
    %
    values = A.delta.values; % 获取A.delta中所有的值
    A.States{1} = A.q0;
    for i = 1:length(values)
        nextState = values{i}; % 获取当前值，即下一个状态
        if ~ismember(nextState, A.States) % 如果状态不在A.States中
            A.States{end+1} = nextState; % 添加到A.States集合中
        end
    end
    % Convert the state names to numbers by removing the 'q' prefix and sorting
    [~, idx] = sort(str2double(strrep(A.States, 'q', '')), 'ascend');
    % Use the index to sort the states
    A.States = A.States(idx);
    % Convert the state names to numbers by removing the 'q' prefix and sorting
    [~, idx] = sort(str2double(strrep(A.F_R, 'q', '')), 'ascend');
    % Use the index to sort the states
    A.F_R = A.F_R(idx);
end

function prefixes = get_prefixes(s)
    % Helper function to get all prefixes of a given string
    prefixes = arrayfun(@(n) s(1:n), 0:length(s), 'UniformOutput', false);
end