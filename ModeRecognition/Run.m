%% 数据集和测试集文件路径
label = 10;
path = "C:\Users\faraw\OneDrive\桌面\模式识别\手写数字识别数据集\";
train_data_file = "train-images-idx3-ubyte\train-images.idx3-ubyte";
train_label_file = "train-labels-idx1-ubyte\train-labels.idx1-ubyte";
test_data_file = "t10k-images-idx3-ubyte\t10k-images.idx3-ubyte";
test_label_file = "t10k-labels-idx1-ubyte\t10k-labels.idx1-ubyte";

% %% 读取数据及标签
% train_data_fin = fopen(path+train_data_file, "rb");
% train_label_fin = fopen(path+train_label_file, "rb");
% test_data_fin = fopen(path+test_data_file, "rb");
% test_label_fin = fopen(path+test_label_file, "rb");
% % 读取训练数据集
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
% % 读取训练标签集
% train_label_magic_number = fread(train_label_fin, 1, 'int32', 'b');
% train_label_size = fread(train_label_fin, 1, 'int32', 'b');
% train_label = zeros(train_label_size, 1);
% for i = 1:train_label_size
%     train_label(i) = fread(train_label_fin, 1, 'uint8', 'b');
% end
% % 读取测试数据集
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
% % 读取测试标签集
% test_label_magic_number = fread(test_label_fin, 1, 'int32', 'b');
% test_label_size = fread(test_label_fin, 1, 'int32', 'b');
% test_label = zeros(test_label_size, 1);
% for i = 1:test_label_size
%     test_label(i) = fread(test_label_fin, 1, 'uint8', 'b');
% end
% fprintf("Read End\n");

%% KNN算法
% 写入文件
fp = fopen("KNN.txt", "w");
MAXK = 10;
PIECE = 10;
for k = 1:MAXK
    for i = 1:PIECE
        [accur, time] = KNN(k,label,train_data(1:train_data_size*i/PIECE,:), train_label(1:train_data_size*i/PIECE,:), test_data, test_label);
        fprintf(fp, "K值：%d，训练集大小：%d，准确度：%f，耗时：%d\n", k, train_data_size*i/PIECE, accur, time);
        fprintf("K值：%d，训练集大小：%d，准确度：%f，耗时：%d\n", k, train_data_size*i/PIECE, accur, time);
    end
end
fclose(fp);
