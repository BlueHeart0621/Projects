import numpy as np
import scipy.misc
import matplotlib.pyplot as plt
import cv2

# 数据集和测试集文件路径
path = "C:/Users/faraw/OneDrive/桌面/模式识别/手写数字识别数据集/"
train_data_file = "train-images-idx3-ubyte/train-images.idx3-ubyte"
train_label_file = "train-labels-idx1-ubyte/train-labels.idx1-ubyte"
test_data_file = "t10k-images-idx3-ubyte/t10k-images.idx3-ubyte"
test_label_file = "t10k-labels-idx1-ubyte/t10k-labels.idx1-ubyte"

# 读取训练数据及标签
train_data_fin = open(path+train_data_file, "rb")
train_label_fin = open(path+train_label_file, "rb")
# 训练数据集
train_data_magic_number = int.from_bytes(train_data_fin.read(4), byteorder='big', signed='false')
train_data_size = int.from_bytes(train_data_fin.read(4), byteorder='big', signed='false')
train_data_image_row = int.from_bytes(train_data_fin.read(4), byteorder='big', signed='false')
train_data_image_col = int.from_bytes(train_data_fin.read(4), byteorder='big', signed='false')
train_data_image_size = train_data_image_row*train_data_image_col
train_data = np.empty([train_data_size, train_data_image_size], dtype=np.int)
for i in range(train_data_size):
    for j in range(train_data_image_size):
        train_data[i, j] = int.from_bytes(train_data_fin.read(1), byteorder='big', signed='false')
# 训练标签集
train_label_magic_number = int.from_bytes(train_label_fin.read(4), byteorder='big', signed='false')
train_label_size = int.from_bytes(train_label_fin.read(4), byteorder='big', signed='false')
train_label = np.empty([train_data_size], dtype=np.int)
for i in range(train_label_size):
    train_label[i] = int.from_bytes(train_label_fin.read(1), byteorder='big', signed='false')

# 读取测试数据及标签
test_data_fin = open(path+test_data_file, "rb")
test_label_fin = open(path+test_label_file, "rb")
# 测试数据集
test_data_magic_number = int.from_bytes(test_data_fin.read(4), byteorder='big', signed='false')
test_data_size = int.from_bytes(test_data_fin.read(4), byteorder='big', signed='false')
test_data_image_row = int.from_bytes(test_data_fin.read(4), byteorder='big', signed='false')
test_data_image_col = int.from_bytes(test_data_fin.read(4), byteorder='big', signed='false')
test_data_image_size = test_data_image_row*test_data_image_col
test_data = np.empty([test_data_size, test_data_image_size], dtype=np.int)
for i in range(test_data_size):
    for j in range(test_data_image_size):
        test_data[i, j] = int.from_bytes(test_data_fin.read(1), byteorder='big', signed='false')
# 测试标签集
test_label_magic_number = int.from_bytes(test_label_fin.read(4), byteorder='big', signed='false')
test_label_size = int.from_bytes(test_label_fin.read(4), byteorder='big', signed='false')
test_label = np.empty([test_data_size], dtype=np.int)
for i in range(test_label_size):
    test_label[i] = int.from_bytes(test_label_fin.read(1), byteorder='big', signed='false')
print("Read End\n")


# 测试数据类
class KNN(object):
    order = 0
    distance = 0

    def __init__(self, order, distance):
        self.order = order
        self.distance = distance

    def __lt__(self, other):
        return self.distance < other.distance
    # 或者使用__cmp__函数


# KNN算法
k = 10                                  # K最近邻选取个数
label = 10                              # 0-9共十个类别
true = 0                                # 预测成功个数
false = 0                               # 预测失败个数
size = test_data_size
for i in range(size):
    KNN_pq_cnt = 0
    KNN_pq = np.empty([k], dtype=KNN)
    # 计算所有训练点到测试点的欧式距离
    for j in range(train_data_size):
        cur_distance = np.linalg.norm(test_data[i, :]-train_data[j, :])
        if KNN_pq_cnt < k:
            KNN_pq[KNN_pq_cnt] = KNN(j, cur_distance)
            KNN_pq_cnt += 1
        else:
            if cur_distance < KNN_pq[k-1].distance:
                KNN_pq[k-1].order = j
                KNN_pq[k-1].distance = cur_distance
        if KNN_pq_cnt >= k:
            KNN_pq.sort()

    label_nearst = 0
    label_nearst_cnt = 0
    label_cnt = np.empty([label], dtype=np.int)
    for j in range(k):
        cur_label = train_label[KNN_pq[j].order]
        label_cnt[cur_label] += 1
        if label_cnt[cur_label] > label_nearst_cnt:
            label_nearst = cur_label
            label_nearst_cnt = label_cnt[cur_label]
    print("第"+str(i)+"测试点的预测标签为："+str(label_nearst)+";"+"真实标签为："+str(test_label[i]))
    if label_nearst == test_label[i]:
        true += 1
    else:
        false += 1


# 显示结果
print("正确率：" + str(true/size))
print("错误率：" + str(false/size))

