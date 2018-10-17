clear;clc;
len=17000;

Min = zeros(len,3);
Sec = zeros(len,3);
[Min(:,1), Sec(:,1), MAC1, SS1] = readcsvr('out1_rasp1.csv',len);
[Min(:,2), Sec(:,2), MAC2, SS2] = readcsvr('out1_rasp2.csv',len);
[Min(:,3), Sec(:,3), MAC3, SS3] = readcsvr('out1_rasp3.csv',len);
MAC = [MAC1,MAC2,MAC3];
SS = [SS1,SS2,SS3];

Time=60*Min+Sec;


Table = {'30:84:54:99:b6:d9';'68:c4:4d:3a:98:79';'18:65:90:09:5d:d9';'2c:5b:b8:1a:2a:b6'};

Names = {'David';'Keerth';'Ken';'Huawei'};

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
            MAC1_Raspi=[MAC1_Raspi,j];
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