clear;clc;

len=800;
tolerance=[6,5,5,5];
A = -15;
x1 = -0.9;
y1 = -9.3;
x2 = 0;
y2 = 0;
x3 = 6.3;
y3 = 0;
n = 2;

disp('Reading data...');
Min = zeros(len,3);
Sec = zeros(len,3);
[Min(:,1), Sec(:,1), MAC1, SS1] = readcsvr('out_rasp1.csv',len);
[Min(:,2), Sec(:,2), MAC2, SS2] = readcsvr('out_rasp2.csv',len);
[Min(:,3), Sec(:,3), MAC3, SS3] = readcsvr('out_rasp3.csv',len);
MAC = [MAC1,MAC2,MAC3];
SS = [SS1,SS2,SS3];

Time=60*Min+Sec;

Table = {'30:84:54:99:b6:d9';'68:c4:4d:3a:98:79';'18:65:90:09:5d:d9';'2c:5b:b8:1a:2a:b6'};

Names = {'David';'Keerth';'Ken';'OPPO_R7+m'};

start = [0,0,0];
for k = 1:3 % k represents for raspberry pi
    for i = 1:len % i-th line of data
       if ismember(MAC(i,k),Table(:,1))
           start(k) = Time(i,k);
           break
       end
    end
    for i = 1:len
        Time(i,k) = Time(i,k)-start(k);
    end
end

%% Calculate time and SS for each MAC in each RasPi and store data in struct MAC_S

disp('Processing data...');
%  Input:MAC,Table,Time,SS  Output:MAC_S
%         MAC_S       rasp1       rasp2       rasp3
% MAC_1  MAC_S(1)   [time,ss]   [time,ss]   [time,ss]
% MAC_2  MAC_S(2)   [time,ss]   [time,ss]   [time,ss]
% MAC_3  MAC_S(3)   [time,ss]   [time,ss]   [time,ss]
% MAC_4  MAC_S(4)   [time,ss]   [time,ss]   [time,ss]

MAC_S=struct('rasp1',{},'rasp2',{},'rasp3',{});
for i=1:3
    MAC1_Raspi=[];
    MAC2_Raspi=[];
    MAC3_Raspi=[];
    MAC4_Raspi=[];
    for j=1:size(MAC(:,i),1)
        if size(cell2mat(MAC(j,i)))==0
            continue;
        elseif cell2mat(MAC(j,i))==Table{1,1}
            MAC1_Raspi=[MAC1_Raspi,j];  %#ok<*AGROW>
        elseif cell2mat(MAC(j,i))==Table{2,1}
            MAC2_Raspi=[MAC2_Raspi,j];
        elseif cell2mat(MAC(j,i))==Table{3,1}
            MAC3_Raspi=[MAC3_Raspi,j];
        elseif cell2mat(MAC(j,i))==Table{4,1}
            MAC4_Raspi=[MAC4_Raspi,j];
        end
    end
    r1=zeros(size(MAC1_Raspi,2),2);
    for k=1:size(MAC1_Raspi,2)
        r1(k,1)=Time(MAC1_Raspi(k),i);
        r1(k,2)=str2double(cell2mat(SS(MAC1_Raspi(k),i)));
    end
    
    r2=zeros(size(MAC2_Raspi,2),2);
    for k=1:size(MAC2_Raspi,2)
        r2(k,1)=Time(MAC2_Raspi(k),i);
        r2(k,2)=str2double(cell2mat(SS(MAC2_Raspi(k),i)));
    end
 
    r3=zeros(size(MAC3_Raspi,2),2);
    for k=1:size(MAC3_Raspi,2)
        r3(k,1)=Time(MAC3_Raspi(k),i);
        r3(k,2)=str2double(cell2mat(SS(MAC3_Raspi(k),i)));
    end
    
    r4=zeros(size(MAC4_Raspi,2),2);
    for k=1:size(MAC4_Raspi,2)
        r4(k,1)=Time(MAC4_Raspi(k),i);
        r4(k,2)=str2double(cell2mat(SS(MAC4_Raspi(k),i)));
    end
    
    if i==1
        MAC_S(1).rasp1=r1;
        MAC_S(2).rasp1=r2;
        MAC_S(3).rasp1=r3;
        MAC_S(4).rasp1=r4;
    end
    if i==2
        MAC_S(1).rasp2=r1;
        MAC_S(2).rasp2=r2;
        MAC_S(3).rasp2=r3;
        MAC_S(4).rasp2=r4;
    end
    if i==3
        MAC_S(1).rasp3=r1;
        MAC_S(2).rasp3=r2;
        MAC_S(3).rasp3=r3;
        MAC_S(4).rasp3=r4;
    end
end

%% For each MAC, average data that is stored in similar time period

%  Input:MAC_S  Output:E
%         E       rasp1       rasp2       rasp3
% MAC_1  E(1)   [time,ss]   [time,ss]   [time,ss]
% MAC_2  E(2)   [time,ss]   [time,ss]   [time,ss]
% MAC_3  E(3)   [time,ss]   [time,ss]   [time,ss]
% MAC_4  E(4)   [time,ss]   [time,ss]   [time,ss]

E=struct('rasp1',{},'rasp2',{},'rasp3',{});
for i=1:4
    MACi_rasp1=MAC_S(i).rasp1;
    MACi_rasp2=MAC_S(i).rasp2;
    MACi_rasp3=MAC_S(i).rasp3;
    if size(MACi_rasp1,1)==0 || size(MACi_rasp2,1)==0 || size(MACi_rasp3,1)==0
        E(i).rasp1=[];
        E(i).rasp2=[];
        E(i).rasp3=[];
        continue;
    end
 
    % For Rasp1
    mir1x=MACi_rasp1(:,1);
    mir1y=MACi_rasp1(:,2);
    diff_mir1x=diff(mir1x);

    r1=find(diff_mir1x>tolerance(i));

    D1=struct('time',{},'ss',{});
    if size(r1,1)==0
        D1(1).time=mir1x;
        D1(1).ss=mir1y;
    else
        for j=1:size(r1,1)+1
            if j==1
                D1(j).time=mir1x(1:r1(1));
                D1(j).ss=mir1y(1:r1(1));
            elseif j==size(r1,1)+1
                D1(j).time=mir1x((r1(j-1)+1):end);
                D1(j).ss=mir1y((r1(j-1)+1):end);
            else
                D1(j).time=mir1x((r1(j-1)+1):r1(j));
                D1(j).ss=mir1y((r1(j-1)+1):r1(j));
            end
        end
    end
    E1=zeros(size(D1,2),2);
    for j=1:size(D1,2)
        E1(j,1)=mean(D1(j).time);
        E1(j,2)=mean(D1(j).ss);
    end
    E(i).rasp1=E1;
    
    % For Rasp2
    mir2x=MACi_rasp2(:,1);
    mir2y=MACi_rasp2(:,2);
    diff_mir2x=diff(mir2x);

    r2=find(diff_mir2x>tolerance(i));

    D2=struct('time',{},'ss',{});
    if size(r2,1)==0
        D2(1).time=mir2x;
        D2(1).ss=mir2y;
    else
        for j=1:size(r2,1)+1
            if j==1
                D2(j).time=mir2x(1:r2(1));
                D2(j).ss=mir2y(1:r2(1));
            elseif j==size(r2,1)+1
                D2(j).time=mir2x((r2(j-1)+1):end);
                D2(j).ss=mir2y((r2(j-1)+1):end);
            else
                D2(j).time=mir2x((r2(j-1)+1):r2(j));
                D2(j).ss=mir2y((r2(j-1)+1):r2(j));
            end
        end
    end
    E2=zeros(size(D2,2),2);
    for j=1:size(D2,2)
        E2(j,1)=mean(D2(j).time);
        E2(j,2)=mean(D2(j).ss);
    end
    E(i).rasp2=E2;
    
    % For Rasp3
    mir3x=MACi_rasp3(:,1);
    mir3y=MACi_rasp3(:,2);
    diff_mir3x=diff(mir3x);

    r3=find(diff_mir3x>tolerance(i));

    D3=struct('time',{},'ss',{});
    if size(r3,1)==0
        D3(1).time=mir3x;
        D3(1).ss=mir3y;
    else
        for j=1:size(r3,1)+1
            if j==1
                D3(j).time=mir3x(1:r3(1));
                D3(j).ss=mir3y(1:r3(1));
            elseif j==size(r3,1)+1
                D3(j).time=mir3x((r3(j-1)+1):end);
                D3(j).ss=mir3y((r3(j-1)+1):end);
            else
                D3(j).time=mir3x((r3(j-1)+1):r3(j));
                D3(j).ss=mir3y((r3(j-1)+1):r3(j));
            end
        end
    end
    E3=zeros(size(D3,2),2);
    for j=1:size(D3,2)
        E3(j,1)=mean(D3(j).time);
        E3(j,2)=mean(D3(j).ss);
    end
    E(i).rasp3=E3;
end

%% Calculate result and store data within time tolerance together for each MAC and RasPi

%  Input:E£¬tolerance  Output:Res
%  For:Res(1).val    Corr. MAC_1  x rows 6 cols, for a MAC, there are x time points within all 3 Pis
%        rasp1_time | rasp1_ss | rasp2_time | rasp2_ss | rasp3_time | rasp3_ss
%    1  
%    2
%   ...
%    x
disp('Synchronizing...');

Res=struct('val',{});

for i=1:4
    if size(E(i).rasp1,1)==0 || size(E(i).rasp2,1)==0 || size(E(i).rasp3,1)==0
       Res(i).val=[];
       continue;
    end
    
     R1=andtimess(E(i).rasp1,E(i).rasp2,tolerance(i));
     R2=andtimess(R1,E(i).rasp3,tolerance(i));
     Res(i).val=R2;
end

%% Calculate position

% Table:
% MAC    Time    x    y

disp('Calculating positions...');
for i = 2:4
	Table{1,i} = []; 
end
leng = [0,0,0,0];
for i = 1:4
    leng(i) = min([length(MAC_S(i).rasp1),length(MAC_S(i).rasp2),length(MAC_S(i).rasp3)]);
end

for i = 1:4
    Dist1 = 10.^(abs(A-MAC_S(i).rasp1(1,2))/(10*n))/50;
    Dist2 = 10.^(abs(A-MAC_S(i).rasp2(1,2))/(10*n))/50;
    Dist3 = 10.^(abs(A-MAC_S(i).rasp3(1,2))/(10*n))/50;
    %         Dist1 = 2.^((abs(A-MAC_S(i).rasp1(j,2)-1.552)/12.92-1));
    %         Dist2 = 2.^((abs(A-MAC_S(i).rasp2(j,2)-1.552)/12.92-1));
    %         Dist3 = 2.^((abs(A-MAC_S(i).rasp3(j,2)-1.552)/12.92-1));
    [x, y] = triposition(x1,y1,Dist1,x2,y2,Dist2,x3,y3,Dist3);
    for j = 1:leng(i)
        if j>1 && MAC_S(i).rasp1(j,1) == MAC_S(i).rasp1(j-1,1)
            continue
        else
            Dist1 = 10.^(abs(A-MAC_S(i).rasp1(j,2))/(10*n))/50;
            Dist2 = 10.^(abs(A-MAC_S(i).rasp2(j,2))/(10*n))/50;
            Dist3 = 10.^(abs(A-MAC_S(i).rasp3(j,2))/(10*n))/50;
    %         Dist1 = 2.^((abs(A-MAC_S(i).rasp1(j,2)-1.552)/12.92-1));
    %         Dist2 = 2.^((abs(A-MAC_S(i).rasp2(j,2)-1.552)/12.92-1));
    %         Dist3 = 2.^((abs(A-MAC_S(i).rasp3(j,2)-1.552)/12.92-1));
            [x, y] = triposition(x1,y1,Dist1,x2,y2,Dist2,x3,y3,Dist3);
            if x < -0.9 || x > 6.3 || y < -9.3 || y > 0
                continue
            else
                Table{i,2} = [Table{i,2},mean([MAC_S(i).rasp1(j,1),MAC_S(i).rasp2(j,1),MAC_S(i).rasp3(j,1)])];
                Table{i,3} = [Table{i,3},x];
                Table{i,4} = [Table{i,4},y];
            end
        end
    end
end

%% Fill positions

disp('Generating output...');
for i = 1:4
    len0 = length(Table{i,2});
    t_cur = Table{i,2}(1);
    x_cur = Table{i,3}(1);
    y_cur = Table{i,4}(1);
    for j = 2:len0
        if abs(Table{i,2}(j) - t_cur) >= tolerance(i)
            n_step = ceil(abs(Table{i,2}(j) - t_cur)/tolerance(i));
            for k = 1:n_step
                Table{i,2} = [Table{i,2},t_cur+k*n_step];
                Table{i,3} = [Table{i,3},x_cur+(Table{i,3}(j)-x_cur)*k/n_step];
                Table{i,4} = [Table{i,4},y_cur+(Table{i,4}(j)-y_cur)*k/n_step];
            end
        elseif (x_cur - Table{i,3}(j))^2 + (y_cur - Table{i,4}(j))^2 > 10
            Table{i,2}(j) = 0;
        end
        t_cur = Table{i,2}(j);
        x_cur = Table{i,3}(j);
        y_cur = Table{i,4}(j);
%         Sort by time
    end
    Sort = sortrows([Table{i,2};Table{i,3};Table{i,4}]',1)';
    Table{i,2} = Sort(1,:);
    Table{i,3} = Sort(2,:);
    Table{i,4} = Sort(3,:);
end

for i = 1:4
    len0 = length(Table{i,2});
    for j = len0:-1:1
        if Table{i,2}(j) ==0
            Table{i,2}(j) = [];
            Table{i,3}(j) = [];
            Table{i,4}(j) = [];
        end
    end
end


%% Write data
Table = [Names,Table];
Tab = cell2table(Table,'VariableNames',{'Name','MAC', 'Time', 'x', 'y'});
delete('Localization.csv')
writetable(Tab, 'Localization.csv');
open('Localization.csv')

%% Draw tracking plot
% Red    Yellow   Green   Blue
% David  Keerth   Ken     OPPO_R7+m
track (Table);