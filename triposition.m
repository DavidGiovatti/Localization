function [locx,locy] = triposition(xa,ya,da,xb,yb,db,xc,yc,dc)

% Input:
% 1. Reference points A(xa, ya), B(xb, yb), C(xc, yc)
% 2. da, db, dc as distances between testing point and reference points

% Return:
% (locx, locy) as location of the testing point

syms x y

% Solve equations
f1 = '2*x*(xa-xc)+xc^2-xa^2+2*y*(ya-yc)+yc^2-ya^2=dc^2-da^2';
f2 = '2*x*(xb-xc)+xc^2-xb^2+2*y*(yb-yc)+yc^2-yb^2=dc^2-db^2';
[xx,yy] = solve(f1,f2,x,y); 
px = eval(xx);  
py = eval(yy);  
locx = px;
locy = py;