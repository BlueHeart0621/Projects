clc
clear

%% 01234 KNN
EDpath = "01234/";
EDfiles = dir(fullfile(EDpath,"*.txt"));
EDcnt = 0;
[n,~] = size(EDfiles);
for i = 1:n
    fin = fopen(EDpath+EDfiles(i).name,"r");
    while(1)
        readline = fgetl(fin);
        if ~ischar(readline)
            break;
        end
        EDcnt = EDcnt + 1;
        str = strsplit(readline,["：",", "]);
        EDdata(EDcnt,:) = str;
    end
    fclose(fin);
end
% 对数据进行排序
EDtmp = str2num(char(EDdata{:,2}))+str2num(char(EDdata{:,4}));
[~,EDindex] = sort(EDtmp);
EDxlsx = EDdata(EDindex,:);
xlswrite("01234.xlsx",EDxlsx);
% 数据可视化
figure
[m,~] = size(EDxlsx);
R = 0:1/n:1;
G = rand(1,n);
B = rand(1,n);
for i = 1:n
    EDX(i,:) = str2num(char(EDxlsx{i:n:m,4}));
    EDY(i,:) = str2num(char(EDxlsx{i:n:m,6}));
    plot(EDX(i,:),EDY(i,:),"color",[R(i),G(i),B(i)]);
    leg(i) = "K=" + num2str(i);
    hold on
end
title("KNN-(01234)Weighted Euler Distance");
xlabel("训练集大小");
ylabel("准确度%");
legend(leg,"location","NorthWest");
set(gca,'fontsize',20);

%% 56789 KNN
MDpath = "56789/";
MDfiles = dir(fullfile(MDpath,"*.txt"));
MDcnt = 0;
[n,~] = size(MDfiles);
for i = 1:n
    fin = fopen(MDpath+MDfiles(i).name,"r");
    while(1)
        readline = fgetl(fin);
        if ~ischar(readline)
            break;
        end
        MDcnt = MDcnt + 1;
        str = strsplit(readline,["：",", "]);
        MDdata(MDcnt,:) = str;
    end
    fclose(fin);
end
% 对数据进行排序
MDtmp = str2num(char(MDdata{:,2}))+str2num(char(MDdata{:,4}));
[~,MDindex] = sort(MDtmp);
MDxlsx = MDdata(MDindex,:);
xlswrite("56789.xlsx",MDxlsx);
% 数据可视化
figure
[m,~] = size(MDxlsx);
R = 0:1/n:1;
G = rand(1,n);
B = rand(1,n);
for i = 1:n
    MDX(i,:) = str2num(char(MDxlsx{i:n:m,4}));
    MDY(i,:) = str2num(char(MDxlsx{i:n:m,6}));
    plot(MDX(i,:),MDY(i,:),"color",[R(i),G(i),B(i)]);
    leg(i) = "K=" + num2str(i);
    hold on
end
title("KNN-(56789)Weighted Euler Distance");
xlabel("训练集大小");
ylabel("准确度%");
legend(leg,"location","NorthWest");
set(gca,'fontsize',20);
