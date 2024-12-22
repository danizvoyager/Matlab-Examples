clear all
clc
m=2; m_hat=0; gm=0.5; lmda_1=10;lmda_2=25;lmda=6;
x_1k0=0.5;
x_2k0=0.5;
dt=0.01;
tsim=10;
u_k0=0;
mc_0=0;
for i=0:dt:tsim
x_1k1=x_1k0 + dt*x_2k0;
x_2k1=x_2k0 + dt*u_k0/m;
x_d0=sin(4*i);
x_d1=4*cos(4*i);
x_d2=-16*sin(4*i);
e_g=1/x_2k1;
e_k=m_hat*((x_2k1 - x_2k0)/dt) - u_k0;
mc_1=-e_g*e_k*(x_2k1- x_2k0)/dt
m_hat=sum(mc_1);
u_k1=m_hat*(x_d2 - 2*lmda*(x_2k1 - x_d1) - (lmda^2)*(x_1k1 - x_d0));
j=round((1 + (i*(1/dt))));
data.x_1(j)=x_1k1;
data.x_2(j)=x_2k1;
data.xd_0(j)=x_d0;
data.xd_1(j)=x_d1;
data.mhat(j)=m_hat;
x_1k0=x_1k1;
x_2k0=x_2k1;
u_k0=u_k1;
mc_0=mc_1;
end
r=0:dt:tsim;
subplot(2,2,1);
plot(r,[data.x_1;data.xd_0])
subplot(2,2,2);
plot(r,[data.x_2;data.xd_1])
subplot(2,2,3);
plot(r,data.mhat)
subplot(2,2,4);
plot(m)