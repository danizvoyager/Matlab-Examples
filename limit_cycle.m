clear all
close all
delt=0.01;
tsim=100;
% for x_1k0=-0.1:0.01:0.1
for x_2k0=-1:0.1:1
x_1k0=0.1;
x_2k0=0.05;
for i=0:delt:tsim
   x_1k1=x_1k0 + delt*(x_2k0 - (x_1k0^7)*(x_1k0^4 + 2*(x_2k0^2) - 10));
   x_2k1=x_2k0 + delt*(-x_1k0^3 - 3*x_2k0*(x_1k0^4 + 2*(x_2k0^2) - 10));
   j=round(1 + i*(1/delt));
   data.x_1k1(j)=x_1k1;
   data.x_1k0(j)=x_1k0;
   data.x_2k1(j)=x_2k1;
   data.x_2k0(j)=x_2k0;
   x_1k0=x_1k1;
   x_2k0=x_2k1;
end
hold on
plot(data.x_1k1,data.x_2k1)
end