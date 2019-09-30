#include <bits/stdc++.h>
#include <iostream>
#include <string>
#include <atomic>
#define re register
#define il inline
#define ll long long
using namespace std;
const ll NUM_THREADS = 5;
const ll MAXN = 1e6+5;
const ll INF = 1e8;
//数据集和测试集文件路径
const string path = "D:/Projects/ModeRecognition/手写数字识别数据集/";
const string train_data_file = path + "train-images-idx3-ubyte/train-images.idx3-ubyte";
const string train_label_file = path + "train-labels-idx1-ubyte/train-labels.idx1-ubyte";
const string test_data_file = path + "t10k-images-idx3-ubyte/t10k-images.idx3-ubyte";
const string test_label_file = path + "t10k-labels-idx1-ubyte/t10k-labels.idx1-ubyte";
const ll label = 10;
mutex mtx;              //全局互斥锁

//K近邻点
struct NODE
{
    ll order = 0;
    ll distance = 0;
    bool operator < (const NODE node) const
    {
        return distance < node.distance;
    }
};


clock_t start, finish;
ll k = 10, correct = 0;
ll train_data_magic_number, train_label_magic_number, test_data_magic_number, test_label_magic_number;
ll train_data_size, train_label_size, train_image_row, train_image_col, train_image_size;
ll test_data_size, test_label_size, test_image_row, test_image_col, test_image_size;
ll *train_data, *train_label, *test_data, *test_label;


//读取n字节的数据
il void read(ll *data, ll n, FILE *fp)
{
    char *result = (char*)data;
    result += n-1;
    while(n--)
        *(result--) = fgetc(fp);
}

//读取数据
void readdata()
{
    //读取数据集图片
    FILE* train_data_fin = fopen(train_data_file.data(), "rb");
    read(&train_data_magic_number, 4, train_data_fin);
    read(&train_data_size, 4, train_data_fin);
    read(&train_image_row, 4, train_data_fin);
    read(&train_image_col, 4, train_data_fin);
    //printf("train_data_magic_number=%lld, train_data_size=%lld, train_image_row=%lld, train_image_col=%lld\n", train_data_magic_number, train_data_size, train_image_row, train_image_col);
    train_image_size = train_image_row*train_image_col;
    train_data = (ll*)calloc(train_data_size*train_image_size, sizeof(ll));
    for(re ll i = 0; i < train_data_size; ++i)
        for(re ll j = 0; j < train_image_size; ++j)
            fread(&train_data[i*train_image_size+j], 1, 1, train_data_fin);
    fclose(train_data_fin);

    //读取数据集标签
    FILE* train_label_fin = fopen(train_label_file.data(), "rb");
    read(&train_label_magic_number, 4, train_label_fin);
    read(&train_label_size, 4, train_label_fin);
    train_label = (ll*)calloc(train_label_size, sizeof(ll));
    for(re ll i = 0; i < train_label_size; ++i)
        fread(&train_label[i], 1, 1, train_label_fin);
    fclose(train_label_fin);

    //读取测试集图片
    FILE* test_data_fin = fopen(test_data_file.data(), "rb");
    read(&test_data_magic_number, 4, test_data_fin);
    read(&test_data_size, 4, test_data_fin);
    read(&test_image_row, 4, test_data_fin);
    read(&test_image_col, 4, test_data_fin);
    test_image_size = test_image_row*test_image_col;
    test_data = (ll*)calloc(test_data_size*test_image_size, sizeof(ll));
    for(re ll i = 0; i < test_data_size; ++i)
        for(re ll j = 0; j < test_image_size; ++j)
            fread(&test_data[i*test_image_size+j], 1, 1, test_data_fin);
    fclose(test_data_fin);

    //读取测试集标签
    FILE* test_label_fin = fopen(test_label_file.data(), "rb");
    read(&test_label_magic_number, 4, test_label_fin);
    read(&test_label_size, 4, test_label_fin);
    test_label = (ll*)calloc(test_label_size, sizeof(ll));
    for(re ll i = 0; i < test_label_size; ++i)
        fread(&test_label[i], 1, 1, test_label_fin);
    fclose(test_label_fin);

    //显示读入结束
    printf("Read End\n");
}

//根据KNN算法预测当前点的标签
il void knn(ll l, ll r)
{
    ll result = 0;
    for(re ll i = l; i < r; ++i)
    {
        priority_queue <NODE> pq;
        for(re ll j = 0; j < train_data_size; ++j)
        {
            NODE node;
            node.order = j;
            for(re ll k = 0; k < train_image_size; ++k)
            {
                ll gap = test_data[i*test_image_size+k]-train_data[j*train_image_size+k];
                //node.distance += gap*gap;     //欧拉距离
                node.distance += abs(gap);      //曼哈顿距离
            }
            if(pq.size() < k)
            {
                pq.push(node);
            }
            else
            {
                if(pq.top().distance > node.distance)
                {
                    pq.pop();
                    pq.push(node);
                }
            }
        }
        ll label_nearst = 0;
        ll label_nearst_cnt = 0;
        ll label_cnt[label] = {0};
        while(!pq.empty())
        {
            ll curlabel = train_label[pq.top().order];
            pq.pop();
            ++label_cnt[curlabel];
            if(label_cnt[curlabel] > label_nearst_cnt)
            {
                label_nearst = curlabel;
                label_nearst_cnt = label_cnt[curlabel];
            }
        }
        if(label_nearst == test_label[i])
        {
            ++result;
        }
        //if(!(i%5000))  printf("已预测%lld个测试点\n", i);
        //printf("第%lld个测试点：预测标签%lld，真实标签%lld\n", i, label_nearst, test_label[i]);
    }
    printf("result = %lld\n", result);
    mtx.lock();
    correct += result;
    mtx.unlock();
    return;
}

//打印信息
void print(FILE *fp)
{
    fprintf(fp, "K值：%lld, 训练集大小：%lld, 准确率：%f, 运行时间：%f seconds\n", k, train_data_size, ((double)correct*100)/(double)test_data_size, (double)(finish-start)/CLOCKS_PER_SEC);
    printf("K值：%lld, 训练集大小：%lld, 准确率：%f, 运行时间：%f seconds\n", k, train_data_size, ((double)correct*100)/(double)test_data_size, (double)(finish-start)/CLOCKS_PER_SEC);
}

int main()
{
    //读取数据
    readdata();
    //开启多线程
    thread tids[NUM_THREADS];
    ll MAXK = 20, PIECE = 10;
    ll MIN_train_data_size = train_data_size/PIECE;
    ll MIN_test_data_size = test_data_size/NUM_THREADS;
    for(re ll i = 1; i <= MAXK; ++i)
    {
        k = i;
        //存入数据
        char file[20] = "KNNx.txt";
        /*
        char file[20] = "KNN1x.txt";
        file[4] = i%10 + '0';
        if(!(i%10)) file[3] = '2';
        */
        file[3] = i%10 + '0';
        FILE *fp = fopen(file, "w");
        for(re ll j = 1; j <= PIECE; ++j)
        {
            //开始计时
            start = clock();
            correct = 0;        //准确个数
            train_data_size = MIN_train_data_size*j;
            for(re ll l = 0; l < NUM_THREADS; ++l)
            {
                tids[l] = thread(knn, MIN_test_data_size*l, MIN_test_data_size*(l+1));
            }
            for(re ll l = 0; l < NUM_THREADS; ++l)
            {
                tids[l].join();
            }
            //结束计时
            finish = clock();
            print(fp);
        }
        fclose(fp);
    }
    free(train_data);
    free(train_label);
    free(test_data);
    free(test_label);
    return 0;
}
