function isCompatible = RPNI_COMPATIBLE(A, S_minus)
    % RPNI_COMPATIBLE 检查DFA A是否与负样本集S_minus一致
    % 输入:
    % A 是确定有限自动机（DFA）
    % S_minus 是负样本集合
    % 输出:
    % isCompatible 是一个布尔值，表示A是否与S_minus一致

    % 获取DFA的初始状态
    q0 = A.q0;
    % 获取DFA的接受状态集
    F_A = A.F_A;
    % 初始化兼容性标志
    isCompatible =1; % 假设初始时是兼容的
    
    % 对于S_minus中的每个字符串w
    for i = 1:length(S_minus)
        currentState = q0; % 从初始状态开始
        currentActions = S_minus{i}; % 获取当前字符串

        for j = 1:length(currentActions)
            currentAction = currentActions(j); % 获取当前动作
            
            key = ['(' currentState, ',', currentAction ')']; % 创建转换键
            if isKey(A.delta, key)
                currentState = A.delta(key); % 进行状态转换
            else
                % 如果在某个状态对某个动作没有定义转换，则认为是不兼容的
                %isCompatible = 2;
                break; % 退出内部循环
            end
        end
        
        if ismember(currentState, F_A)
            % 如果结束于接受状态，则不兼容
            isCompatible = 0;
            break; % 退出外部循环
        end
    end
end
