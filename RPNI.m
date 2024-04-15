%S_plus = {'aaac','abbac','accba','bacc','baac','bcac','cabaac','caacab'};%输入正数据集
%S_minus = {'abba','cabcb','ccba','bbbca','ab','caabc'};%输入负数据集
S_plus = {'cac','bacb','aaca','cacc','abac'};%输入正数据集b v   
S_minus = {'a','ba','ca','aa','bab'};%输入负数据集
disp(S_plus);
disp(S_minus);
FF_A='';
FF_R = {};
A = Build_PTA(S_plus, S_minus);%根据S_plus和S_minus构建前缀生成树
RED={A.q0};%定义RED
BLUE={};%定义BLUE
AgoState={A.q0};%分析过的状态
       keys = A.delta.keys;
       for k = 1:length(keys)
        key = keys{k};
        value = A.delta(key);
        %fprintf('%s -> %s\n', key, value);
       end   
%定义一个中间量，用来合并尝试
TransitionAdelta = containers.Map('KeyType', 'char', 'ValueType', 'any');
TransitionF_A=A.F_A;
subTransitionq_u = containers.Map('KeyType', 'char', 'ValueType', 'any');
%q='q0';
%q_u='q2';
%A = RPNI_FOLD(A, q, q_u);   
%初始化RED与BLUE
currentq={'q0'};

[RED,BLUE,WHITE] = RPNI_PROMOTE(A,RED,BLUE,currentq);

while ~isempty(BLUE)
    stateq_u=BLUE(1);
    q_u=stateq_u{1};
    isFold=0;%判断是否合并的变量
    %A = RPNI_FOLD(A, q, q_u);%合并q和q_u
    %A = RPNI_MERGE(A, q, q_u);%合并的第一步，选择的q，q_u后，将σ（qf，a）→q_u变为σ（qf，a）→q
    %disp(A.delta('(q0,b)'));
    %isCompatible = RPNI_COMPATIBLE(A, S_minus);%返回此时的一个值表示，自动机是否满足S_minus集合

           %这个计数有问题


   %现在差最后一个问题，把q20放到循环中    
   %{
    Green=RED;

    for e=1:length(Green)
        stateGreenState=Green{e};
     for i=1:length(A.Sigma)
        %Number=length(RED);
        REDFinallystate=stateGreenState;
        TransitionREDFState=['(', REDFinallystate , A.Sigma(i), ')'];
        if isKey(A.delta,TransitionREDFState)

        isBLUEState=A.delta(TransitionREDFState);
        if ~ismember(isBLUEState, RED)


        if ~ismember(isBLUEState, BLUE)
            BLUE=union(BLUE,isBLUEState);
        end
        end
        end
     end
    end
   %}
    count=length(RED);



    for i=1:length(RED)



        %创建深拷贝而不是指向性的变量
        keys = A.delta.keys;
        values = A.delta.values;
        TransitionAdelta = containers.Map(keys, values);
        %TransitionAdelta=A.delta;%先将自动机A的数据存档一下
        TransitionF_A=A.F_A;
        q=RED{i};
        A = RPNI_MERGE(A, q, q_u);%合并的第一步，选择的q，q_u后，将σ（qf，a）→q_u变为σ（qf，a）→q
        %[A,subTransitionq_u] = RPNI_FOLD(A, q, q_u);%合并q和q_u
        %%%%%%%%%%%
        [A, subTransitionq_u] = RPNI_FOLD(A, q, q_u,subTransitionq_u);
        
        %不能完全删除
        [subTransitions,actionSequences] = findSubTransitionsFromStatS(A,q_u);%查询q_u的所有有关映射
        A.delta = remove(A.delta, subTransitions.keys);%删除q_u相关键值
        A=AaddsubTransitionq_u(A,subTransitionq_u);
        subTransitionq_u = containers.Map('KeyType', 'char', 'ValueType', 'any');
        %keys = A.delta.keys;    
        %for k = 1:length(keys)
        %    key = keys{k};
        %    value = A.delta(key);
        %    fprintf('111%s -> %s\n', key, value);
        %end   

        isCompatible = RPNI_COMPATIBLE(A, S_minus);%返回此时的一个值表示，自动机是否满足S_minus集合

        %BLUE中元素加入RED中的条件
        %条件1：成功合并
        
        if isCompatible
            AgoState=union(AgoState,q_u);
            %subTransitions = findSubTransitionsFromStatS(A,q_u);%查询q_u的所有有关映射
            %A.delta = remove(A.delta, subTransitions.keys);%删除q_u相关键值
    
            %移除BLUE中的q_u状态
           index = find(strcmp(BLUE, q_u));
            % 如果找到，从A.F_A中移除q2
            if ~isempty(index)
                isFold=1;%是否合并？
                %RED=union(RED,BLUE(index));
                    cq={q};
                %这里有问题------已解决
                [RED,BLUE,WHITE] = RPNI_PROMOTE(A,RED,BLUE,cq);

                BLUE(index)= [];
                break;
            end
        
        else
        A.delta=TransitionAdelta;%合并不成功，再将存档返回去
        A.F_A=TransitionF_A;
            count=count-1;
        end
        %条件2：尝试合并，合并失败
        if count==0
            %移除BLUE中的q_u状态
           index = find(strcmp(BLUE, q_u));
            % 如果找到，从A.F_A中移除q2
            if ~isempty(index)
                RED=union(RED,BLUE(index));
                [RED,BLUE,WHITE] = RPNI_PROMOTE(A,RED,BLUE,BLUE(index));
                %BLUE(index) = [];
                %disp(BLUE);
            end
        end
    end

    %条件3：只存在于值中，没有包含这个状态的键
    %检查BLUE中的每一个值是否只出现在value中，不出现在键值Key中
    OnlyInValue = isOnlyInValue(A,q_u);
    if OnlyInValue && isFold==0
       %移除BLUE中的q_u状态
       index = find(strcmp(BLUE, q_u));
        % 如果找到，从A.F_A中移除q2
        if ~isempty(index)
            RED=union(RED,BLUE(index));
            [RED,BLUE,WHITE] = RPNI_PROMOTE(A,RED,BLUE,BLUE(index));
            %BLUE(index) = [];
            %disp(BLUE);
        end
    end


end
A.F_R={};     
    keys = A.delta.keys;
      for k = 1:length(keys)
       key = keys{k};
       ppp= strsplit(key, {',', '(', ')'});
       stateppp = strtrim(ppp{2}); 
        if ~ismember(stateppp, A.F_A)
            if ~ismember(stateppp, A.F_R)
                A.F_R=[A.F_R,stateppp];
            end
        end
      end  

      keys = A.delta.keys;
      
      for k = 1:length(keys)
       key = keys{k};
       value = A.delta(key);
       fprintf('%s -> %s\n', key, value);
      end   


      
      for p=1:length(keys)
            key=keys{p};
        pp= strsplit(key, {',', '(', ')'});
        statepp = strtrim(pp{2}); % 获取状态
        if ismember(statepp, A.F_A)
%            key{2}='警戒状态';
            break;
        end
      end

% 定义初始的状态转换映射

delta = A.delta;

% 定义状态和动作的新名称
stateNames = {'q0', 'q3', 'q8'; '飞行状态', '攻击支援状态', '监视状态'};
actionNames = {'a', 'b', 'c'; '开启雷达', '关闭雷达', '发送精确目标'};

% 创建新的容器映射来存储更新后的键值对
newDelta = containers.Map;

% 更新状态和动作名称
for i = 1:length(keys)
    oldKey = keys{i};
    oldValue = delta(oldKey);
    % 使用 strcmp 找到对应的新状态名称
    idx = strcmp(stateNames(1,:), oldValue);
    newValue = stateNames{2, idx};

    newKey = oldKey;
    for j = 1:3
        newKey = strrep(newKey, stateNames{1,j}, stateNames{2,j});
        newKey = strrep(newKey, actionNames{1,j}, actionNames{2,j});
    end
    % 在新映射中添加更新后的键值对
    newDelta(newKey) = newValue;
end

% 显示更新后的映射

      keys = newDelta.keys;
      
      for k = 1:length(keys)
       key = keys{k};
       value = newDelta(key);
       fprintf('%s -> %s\n', key, value);
      end 









      
      %     
      %      
    S_plus1 = {};
    S_minus1 = {};
    w1 ={'c'};
    w2 ={'a','b','c'};
    w3={'a','b'};

    %S_plus = {'cac','bacb','aaca','cacc','abac'};%输入正数据集b v   
   % S_minus = {'a','ba','ca','aa','bab'};%输入负数据集

    % 遍历每一个状态对 (q_u, q_v)
    SP_q0={};
    SP_q3='a';
    SP_q8='ac'; 
    q_u = 'q0';
    q_v= 'q3';
 

    for k = 1:length(A.Sigma)
                a = A.Sigma(k);
                transitionKeyu = ['(' q_u, ',', a, ')'];
                transitionKeyv = ['(' q_v, ',', a, ')'];
                if A.delta(transitionKeyu)==q_v
                        continue;
                else
                    
                    if ismember(A.delta(transitionKeyu),A.F_A)
                        %S_plus1{end+1}=SP_q0;
                        S_plus1=[S_plus1,a];
                        S_plus1=[S_plus1,w1];
                        S_minus1=[S_minus1,SP_q0];
                        S_minus1=[S_minus1,a];
                        S_minus1=[S_minus1,w1];
                   
                    elseif ismember(A.delta(transitionKeyv),A.F_A)
                       S_plus1= [S_plus1,SP_q3];
                       %S_plus1= strcat(S_plus1,SP_q3);
                       S_plus1= strcat(S_plus1,a);
                       S_plus1= strcat(S_plus1,w1);
                       %S_plus1=[S_plus1,a];
                       % S_plus1=[S_plus1,w1];
                       % S_minus1=[S_minus1,SP_q0];
                       S_minus1=[S_minus1,a];
                       S_minus1=strcat(S_minus1,w1);
                    end
                end
    end

q_u = 'q3';
q_v= 'q8';
    for k = 1:length(A.Sigma)
                a = A.Sigma(k);
                transitionKeyu = ['(' q_u, ',', a, ')'];
                transitionKeyv = ['(' q_v, ',', a, ')'];
                if A.delta(transitionKeyu)==q_v
                        continue;
                else
                    
                    if ismember(A.delta(transitionKeyu),A.F_A)
                        %S_plus1{end+1}=SP_q0;
                        S_plus1=[S_plus1,a];
                        S_plus1=[S_plus1,w1];
                        S_minus1=[S_minus1,SP_q0];
                        S_minus1=[S_minus1,a];
                        S_minus1=[S_minus1,w1];
                   
                    elseif ismember(A.delta(transitionKeyv),A.F_A)
                       
                       S_plus1= [S_plus1,SP_q3];
                       %S_plus1= strcat(S_plus1,SP_q3);
                       S_plus1= strcat(S_plus1,a);
                       S_plus1= strcat(S_plus1,w1);
                       %S_plus1=[S_plus1,a];
                       % S_plus1=[S_plus1,w1];
                       % S_minus1=[S_minus1,SP_q0];
                       S_minus1=[S_minus1,a];
                       S_minus1=strcat(S_minus1,w1);
                    end
                end
    end

disp(S_plus1);
disp(S_minus1);
               
%A.delta
%q=RED{1};
%q_u=BLUE{1};
%A = RPNI_MERGE(A, q, q_u);%合并的第一步，选择的q，q_u后，将σ（qf，a）→q_u变为σ（qf，a）→q
%isCompatible = RPNI_COMPATIBLE(A, S_minus);%返回此时的一个值表示，自动机是否满足S_minus集合
%A = RPNI_FOLD(A, q, q_u);%合并q和q_u
%subTransitions = findSubTransitionsFromStatS(A,q_u);%查询q_u的所有有关映射
%A.delta = remove(A.delta, subTransitions.keys);%删除q_u相关键值

%输出A中的A.delta映射

