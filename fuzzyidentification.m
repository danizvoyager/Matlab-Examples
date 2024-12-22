clear;
clc;
% load data; 
load input; 
load output;
y=output;
u=input;
data=iddata(y,u,1);
data.inputname={'Water Flow';'Fuel Flow';'Air Flow1';'Air Flow2'};
data.outputname={'Pressure';'Temperature';'Drum Level'}
% generate a fuzzy model for biomass boiler
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = [2 2 4];		% n umber of clusters 
m = 2.2;	% fuzziness parameter
tol = 0.0001;		% termination criterion 
Ts = 1;	% sample time [s]
FMtype = [1 1 1];
Ny =[2 0 0;0 2 0;1 1 2];	% denominator order
Nu = [2 2 2 2;2 2 2 2;2 2 2 2]; % numerator orders
Nd = [1 1 1 1;1 1 1 1;1 1 1 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identification data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Input=u; output=y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ue=[input(:,1) input(:,2) input(:,3) input(:,4)];
ye=[output(:,1) output(:,2) output(:,3)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% make fuzzy model by means of fuzzy clustering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dat.U = u; Dat.Y = y; Dat.Ts = Ts;
FM.c = c; FM.m = m; FM.ante = FMtype; FM.tol = tol; FM.Ny = Ny; FM.Nu = Nu; FM.Nd = Nd;
[FM,Part] = fcm(Dat,FM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate the fuzzy model for validation data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ym,VAF,dof,yl,ylm] = fmsim(ue,ye,FM,[],[],1); 
VAF
[FM,dof]=fmest(FM,Dat) 
fm2tex(FM,'fuzzymeskerem27') 
[DOF,X] = fmdof(u,y,FM)