function [] = track(Table)
x1 = -0.9;
y1 = -9.3;
x2 = 0;
y2 = 0;
x3 = 6.3;
y3 = 0;
plot(x1,y1,'k^');
hold on;
plot(x2,y2,'k^');
hold on;
plot(x3,y3,'k^');
hold on;
color = {'r.','y.','g.','b.';'r','y','g','b';'r*','y*','g*','b*'};
for num = 1:size(Table,1)
    Time = Table{num,3};
    x = Table{num,4};
    y = Table{num,5};
    n = length(x);
    x0 = x(1);
    y0 = y(1);
    for i = 1:n
        pause(0.01)
        hold on;
        plot(x(i),y(i),color{1,num});
%         hold on;
%         plot(x0,y0,'wo');
        hold on;
        plot([x0,x(i)],[y0,y(i)],color{2,num}); 
        x0 = x(i);
        y0 = y(i);
    end
    plot(x(i),y(i),color{3,num});
end
legend('Raspberry Pi','Location','SouthEast');  
title('Tracking');
