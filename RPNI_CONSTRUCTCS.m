function [S_plus, S_minus] = RPNI_CONSTRUCTS(A)
    % 输入参数 A 是一个结构体，包含以下字段：
    % A.Sigma - 字母表
    % A.Q - 状态集
    % A.q_a - 初始状态
    % A.F_a - 接受状态集
    % A.F_r - 拒绝状态集
    % A.delta - 转移函数，可以用一个矩阵或者cell数组表示

    % 初始化正样本集和负样本集
    S_plus1 = {};
    S_minus1 = {};
    w1 ={'c'};
    w2 ={'a','b','c'};
    w3={'a','b'};

    %S_plus = {'cac','bacb','aaca','cacc','abac'};%输入正数据集b v   
   % S_minus = {'a','ba','ca','aa','bab'};%输入负数据集

    % 遍历每一个状态对 (q_u, q_v)
    q_u = 'q0';
    q_v= 'q3';
    SP_q0={};
    SP_q3='a';
    SP_q8='ac';

    for k = 1:length(A.Sigma)
                a = A.Sigma(k);
                transitionKey = '(q_u,a)';
                if A.delta(transitionKey)==q_v
                        continue;
                else
                    
                    if ismember(A.delta(transitionKey),A.F_A)
                        S_plus1{end+1}=SP_q0;
                        S_plus1{end+1}=a;
                        S_plus1{end+1}=w1;
                        S_minus1{end+1}=SP_q1;
                        S_minus1{end+1}=a;
                        S_minus1{end+1}=w1;
                   
                    elseif ismember(A.delta(transitionKey),A.F_R)
                        S_plus1{end+1}=SP_q3;
                        S_plus1{end+1}=a;
                        S_plus1{end+1}=w1;
                        S_minus1{end+1}=SP_q0;
                        S_minus1{end+1}=a;
                        S_minus1{end+1}=w1;
                    end
                end
    end
    disp()
disp(S_plus1);
disp(S_minus1);







    for i = 1:length(A.Q)
        q_u = A.Q(i);
        for j = 1:length(A.Q)
            q_v = A.Q(j);
            % 遍历每一个字母表符号
            for k = 1:length(A.Sigma)
                a = A.Sigma(k);
                % 检查 IL(Λ_a(q_v)) 和 aΣ* 是否有交集，以及 q_u ≠ δ(q_v, a)
                % 这里 IL 函数和 MD 函数需要您提供实现
                if ~isempty(IL(A, q_v, a)) && ~strcmp(q_u, delta(A, q_v, a))
                    if q_u=='q0'&&q_v=='q3'
                        w =w1;
                    end
                    if q_u=='q0'&&q_v=='q8'
                        w =w2;
                    end
                    if q_u=='q3'&&q_v=='q8'
                        w =w3;
                    end                    
                    w = MD(q_u, q_v); % MD 函数需要您提供实现
                    % 如果 δ(q_a, u · w) ∈ F_a，则更新 S_plus

                    if ismember(delta(A, A.q_a, strcat(u, w)), A.F_a)
                        S_plus{end+1} = strcat(SP(A, q_u), w); % SP 函数需要您提供实现
                    else
                        S_minus{end+1} = strcat(SP(A, q_v), w); % SP 函数需要您提供实现
                    end
                end
            end
        end
    end
end



function result = delta(A, state, input)
    % 这个函数根据转移函数返回新的状态
    % 您需要根据 A.delta 的具体实现来编写这个函数
    % 这里只是一个占位符
    result = []; % 伪代码
end

function result = IL(A, state, input)
    % 这个函数需要计算左商 IL
    % 您需要提供具体的实现
    result = []; % 伪代码
end
%{
function result = MD(q_u, q_v)
    while true
        for k = 1:length(A.Sigma)
            q_unext=A.delta(q_u,A.Sigma{k});
            q_vnext=A.delta(q_v,A.Sigma{k});

            if ismember(q_unext,A.F_A)&&ismember(q_vnext,A.F_R)
                counts=1;
            end
            if ismember(q_unext,A.F_A)&&ismember(q_vnext,A.F_R)
                counts=1;
            end
            if counts==1

            end
        end

    end



    % 这个函数需要返回最小区分后缀
    % 您需要提供具体的实现
    result = ''; % 伪代码
end
%}
function result = SP(A, state)
    % 这个函数需要返回最短前缀
    % 您需要提供具体的实现
    result = ''; % 伪代码
end
