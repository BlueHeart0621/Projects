%% ���ݼ��Ͳ��Լ��ļ�·��
label = 10;
path = "C:\Users\faraw\OneDrive\����\ģʽʶ��\��д����ʶ�����ݼ�\";
train_data_file = "train-images-idx3-ubyte\train-images.idx3-ubyte";
train_label_file = "train-labels-idx1-ubyte\train-labels.idx1-ubyte";
test_data_file = "t10k-images-idx3-ubyte\t10k-images.idx3-ubyte";
test_label_file = "t10k-labels-idx1-ubyte\t10k-labels.idx1-ubyte";

% %% ��ȡ���ݼ���ǩ
% train_data_fin = fopen(path+train_data_file, "rb");
% train_label_fin = fopen(path+train_label_file, "rb");
% test_data_fin = fopen(path+test_data_file, "rb");
% test_label_fin = fopen(path+test_label_file, "rb");
% % ��ȡѵ�����ݼ�
% train_data_magic_number = fread(train_data_fin, 1, 'int32', 'b');
% train_data_size = fread(train_data_fin, 1, 'int32', 'b');
% train_data_image_row = fread(train_data_fin, 1, 'int32', 'b');
% train_data_image_col = fread(train_data_fin, 1, 'int32', 'b');
% train_data_image_size = train_data_image_row*train_data_image_col;
% train_data = zeros(train_data_size, train_data_image_size);
% for i = 1:train_data_size
%     for j = 1:train_data_image_size
%         train_data(i,j) = fread(train_data_fin, 1, 'uint8', 'b');
%     end
% end
% % ��ȡѵ����ǩ��
% train_label_magic_number = fread(train_label_fin, 1, 'int32', 'b');
% train_label_size = fread(train_label_fin, 1, 'int32', 'b');
% train_label = zeros(train_label_size, 1);
% for i = 1:train_label_size
%     train_label(i) = fread(train_label_fin, 1, 'uint8', 'b');
% end
% % ��ȡ�������ݼ�
% test_data_magic_number = fread(test_data_fin, 1, 'int32', 'b');
% test_data_size = fread(test_data_fin, 1, 'int32', 'b');
% test_data_image_row = fread(test_data_fin, 1, 'int32', 'b');
% test_data_image_col = fread(test_data_fin, 1, 'int32', 'b');
% test_data_image_size = test_data_image_row*test_data_image_col;
% test_data = zeros(test_data_size, test_data_image_size);
% for i = 1:test_data_size
%     for j = 1:test_data_image_size
%         test_data(i,j) = fread(test_data_fin, 1, 'uint8', 'b');
%     end
% end
% % ��ȡ���Ա�ǩ��
% test_label_magic_number = fread(test_label_fin, 1, 'int32', 'b');
% test_label_size = fread(test_label_fin, 1, 'int32', 'b');
% test_label = zeros(test_label_size, 1);
% for i = 1:test_label_size
%     test_label(i) = fread(test_label_fin, 1, 'uint8', 'b');
% end
% fprintf("Read End\n");

%% KNN�㷨
% д���ļ�
fp = fopen("KNN.txt", "w");
MAXK = 10;
PIECE = 10;
for k = 1:MAXK
    for i = 1:PIECE
        [accur, time] = KNN(k,label,train_data(1:train_data_size*i/PIECE,:), train_label(1:train_data_size*i/PIECE,:), test_data, test_label);
        fprintf(fp, "Kֵ��%d��ѵ������С��%d��׼ȷ�ȣ�%f����ʱ��%d\n", k, train_data_size*i/PIECE, accur, time);
        fprintf("Kֵ��%d��ѵ������С��%d��׼ȷ�ȣ�%f����ʱ��%d\n", k, train_data_size*i/PIECE, accur, time);
    end
end
fclose(fp);
