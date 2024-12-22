clear all
close all
delt=0.01;
tsim=63;
for x_1k0=0.1:0.2:4
x_2k0=0;
for i=0:delt:tsim
    u_k0=-0.01*(x_1k0)  ;
    x_1k1=x_1k0 + delt*x_2k0;
    x_2k1=x_2k0 + delt*u_k0;
   j=round(1 + i*(1/delt));
   data.x_1k1(j)=x_1k1;
   data.x_2k1(j)=x_2k1;
   x_1k0=x_1k1;
   x_2k0=x_2k1;
end
hold on
plot(data.x_1k1,data.x_2k1)
end