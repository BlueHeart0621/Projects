clc
clear
%% EulerDistance KNN
EDpath = "EulerDistance";
EDfiles = dir(fullfile(EDpath,"*.txt"));
cnt = 0;
[n,~] = size(EDfiles);
for i = 1:n
    fin = fopen(EDpath+EDfiles(i).name,"r");
    while(1)
        readline = fgetl(fin);
        if ~ischar(readline)
            break;
        end
        cnt = cnt + 1;
        str = strsplit(readline,{"��",", "});
        EDdata(cnt) = str;
    end
    fclose(fin);
end
% xlswrite("EulerDistance.xlsx",EDdata);