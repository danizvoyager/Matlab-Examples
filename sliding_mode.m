close all
clear all
delt=0.01;
tsim=20;
x_k0=2;
x_k1=0;  
for i=0:delt:tsim 
Q=0.3*abs(x_k1) + 0.4;
u_k0=-(x_k0 + Q*sign(x_k0));
x_k1=x_k0*(1 + delt + 0.2*delt*sin(2*i)) + delt*u_k0 + delt*0.3*sin(20*i);
j=round((1 + (i*(1/delt))));
data.x(j)=x_k1;
data.u(j)=u_k0;
x_k0=x_k1;
end
r=0:delt:tsim;
subplot(2,1,1)
plot(r,data.x)
subplot(2,1,2)
plot(r,data.u)

