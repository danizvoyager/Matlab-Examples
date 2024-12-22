clear all
clc
dt=0.01; tsim=10;
y_k0=0;
u_k0=0;
ym_k0=0;
ar_hat=0;ay_hat=0; af_hat=1/3;
for i=0:dt:10
% r=4;
r=4*sin(3*i);
y_k1=y_k0 + dt*(y_k0  + y_k0^2 + 3*u_k0);
ym_k1=ym_k0 + dt*(-4*ym_k0 + 4*r);
e=y_k1 - ym_k1
ar_hat=ar_hat - dt*2*e*r;
af_hat=af_hat - dt*2*e*(y_k1^2);
ay_hat=ay_hat - dt*2*e*y_k1;
u_k1=ar_hat*r + af_hat*(y_k1^2) + ay_hat*y_k1;
j=round((1 + (i*(1/dt))));
data.y_1(j)=y_k1;
data.y_2(j)=ym_k1;
data.ay(j)=ar_hat;
data.ar(j)=ay_hat;
y_k0=y_k1;
ym_k0=ym_k1;
u_k0=u_k1;
end
m=0:dt:tsim;
subplot(2,2,1)
plot(m,[data.y_1;data.y_2])
subplot(2,2,2)
plot(m,data.y_1)
subplot(2,2,3)
plot(m,data.ar)
subplot(2,2,4)
plot(m,data.ay)