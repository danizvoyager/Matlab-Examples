clear all
clc
r=0;
%r_2=sin(4*i);
m=2; m_hat=0; gm=0.5; lmda_1=10;lmda_2=25;lmda=6;
x_1k0=0.5; xm_1k0=0.5;
x_2k0=0;xm_2k0=0;
dt=0.01;
tsim=10;
u_k0=0;
for i=0:dt:tsim
% r=0;
r=sin(4*i);
x_1k1=x_1k0 + dt*x_2k0;
x_2k1=x_2k0 + dt*u_k0/m;
xm_1k1=xm_1k0 + dt*xm_2k0;
xm_2k1=xm_2k0 - dt*(lmda_1*xm_2k0 + lmda_2*(xm_1k1 -r));
s=(x_2k1 - xm_2k1) + lmda*(x_1k1 - xm_1k1);
v=(xm_2k1- xm_2k0)/dt - 2*lmda*(x_2k1 - xm_2k1) - (lmda^2)*(x_1k1 - xm_1k1);
m_c=-gm*s*v;
m_hat=m_hat + m_c;
u_k1=m_hat*((xm_2k1- xm_2k0)/dt - 2*lmda*(x_2k1 - xm_2k1) - (lmda^2)*(x_1k1 - xm_1k1));
j=round((1 + (i*(1/dt))));
data.x_1(j)=x_1k1;
data.x_2(j)=x_2k1;
data.xm_k1(j)=xm_1k1;
data.xm_k2(j)=xm_2k1;
data.mhat(j)=m_hat;
x_1k0=x_1k1;
x_2k0=x_2k1;
xm_1k0=xm_1k1;
xm_2k0=xm_2k1;
u_k0=u_k1;
end
r=0:dt:tsim;
subplot(2,2,1);
plot(r,[data.x_1;data.xm_k1])
subplot(2,2,2);
plot(r,[data.x_2;data.xm_k2])
subplot(2,2,3);
plot(r,data.mhat)
subplot(2,2,4);
plot(m)