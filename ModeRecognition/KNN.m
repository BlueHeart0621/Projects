function [accur, time] = KNN(k, label, train_data, train_label, test_data, test_label)
    % ��ʼ��ʱ
    tic
    correct = 0;
    [train_n, train_m] = size(train_data);
    [test_n, test_m] = size(test_data);
    if train_m ~= test_m
        error("ѵ�������ݴ�С�Ͳ��Լ����ݴ�С��ƥ��");
    end
    for i = 1:test_n
        % ��ȡk����
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
        % Ԥ���ǩ
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
        % �ж���ȷ��
        if label_nearst == test_label(i)
            correct = correct+1;
        end
        if mod(i,1000) == 0
            fprintf("��Ԥ��%d�����Ե�, ׼ȷ�ȣ�%f\n", i, correct*100/i);
        end
    end
    accur = correct*100/test_n;
    % ������ʱ
    toc
    time = toc;
end