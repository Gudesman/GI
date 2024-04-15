function [RED,BLUE,WHITE] = RPNI_PROMOTE(A,RED,BLUE,currentq)
    %对于RED中最后一个状态q_u，分析q_u通过转换函数执行不同动作的下一个状态是否存在，存在的放到BLUE候选状态中
    %q_u=RED{lenth(RED)};
    for j=1:length(A.Sigma)
        cq=currentq{1};
        transitionKey = ['(' cq, ',', A.Sigma(j) ')'];
        if isKey(A.delta, transitionKey)
            NextState=A.delta(transitionKey);
            BLUE=union(BLUE,NextState);
        end
    end
    %对于未分析状态WHITE，是A.States-RED-BLUE
    tempResult = setdiff(A.States, RED);
    WHITE=setdiff(tempResult, BLUE);
    %将分析过的候选元素放入到RED中
    BLACK = intersect(RED, BLUE);
    BLUE=setdiff(BLUE, BLACK );
    %对于RED的集合的增加还未完成

end
