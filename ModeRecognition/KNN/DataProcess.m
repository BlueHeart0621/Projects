clc
clear
%% EulerDistance KNN
EDpath = "EulerDistance/";
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
xlswrite("EulerDistance.xlsx",EDxlsx);

%% ManhattanDistance KNN
MDpath = "ManhattanDistance/";
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
xlswrite("ManhattanDistance.xlsx",MDxlsx);