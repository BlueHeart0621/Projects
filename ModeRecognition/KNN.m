function [accur, time] = KNN(k, label, train_data, train_label, test_data, test_label)
    % 开始计时
    tic
    correct = 0;
    [train_n, train_m] = size(train_data);
    [test_n, test_m] = size(test_data);
    if train_m ~= test_m
        error("训练集数据大小和测试集数据大小不匹配");
    end
    for i = 1:test_n
        % 求取k近邻
        cnt = 1;
        kpq = zeros(k,1);
        korder = zeros(k,1);
        for j = 1:train_n
            curdistance = norm(train_data(j,:)-test_data(i,:));
            if cnt <= k
                kpq(cnt) = curdistance;
                korder(cnt) = j;
                cnt = cnt + 1;
                if cnt > k
                    [kpq, E] = sort(kpq);
                    korder = korder(E);
                end
            else
                if curdistance < kpq(k)
                    kpq(k) = curdistance;
                    korder(k) = j;
                    [kpq, E] = sort(kpq);
                    korder = korder(E);
                end
            end
        end
        % 预测标签
        label_nearst = 0;
        label_nearst_cnt = 0;
        label_cnt = zeros(label, 1);
        for j = 1:k
            curlabel = train_label(korder(j))+1;
            label_cnt(curlabel) = label_cnt(curlabel)+1;
            if label_cnt(curlabel) > label_nearst_cnt
                label_nearst = curlabel-1;
                label_nearst_cnt = label_cnt(curlabel);
            end
        end
        % 判断正确性
        if label_nearst == test_label(i)
            correct = correct+1;
        end
        if mod(i,1000) == 0
            fprintf("已预测%d个测试点, 准确度：%f\n", i, correct*100/i);
        end
    end
    accur = correct*100/test_n;
    % 结束计时
    toc
    time = toc;
end