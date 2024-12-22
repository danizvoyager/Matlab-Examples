a=1;
tsim=10;
eta=0.1;
x_1k0=0;
x_2k0=0;
dt=0.001;
u_k0=0;
lmda=20;
for i=0:dt:tsim
x_1k1=x_1k0 + dt*x_2k0;
x_2k1=x_2k0 - dt*a*(x_2k0^2)*cos(3*x_1k1) + dt*u_k0;
xd_k0=sin(pi*i/4);
xd_k1=(pi/4)*cos(pi*i/4);
xd_k2=-((pi/4)^2)*sin(pi*i/4);
f=-a*(x_2k1^2)*cos(x_1k1);
f_hat=-1.5*(x_2k1^2)*cos(3*x_1k1);
F=0.5*(x_2k1^2)*abs(cos(3*x_1k1));
k=eta + F;
xdelta_k0=x_1k1 - xd_k0;
xdelta_k1=x_2k1 - xd_k1;
s=xdelta_k1 + lmda*xdelta_k0;
u_hat=-f_hat + xd_k2 - lmda*xdelta_k1;
u_k1=u_hat - k*sign(s);
j=round((1 + (i*(1/dt))));
data.x_1(j)=x_1k1;
data.x_2(j)=x_2k1;
data.xd_k0(j)=xd_k0;
data.xd_k1(j)=xd_k1;
data.xd_k2(j)=xd_k2;
x_1k0=x_1k1;
x_2k0=x_2k1;
u_k0=u_k1;
end
r=0:dt:tsim;
subplot(2,2,1);
plot(r,[data.x_1;data.xd_k0])
subplot(2,2,2);
plot(r,[data.x_2;data.xd_k1])
subplot(2,2,3);
plot(r,data.xd_k0)
subplot(2,2,4);
plot(r,data.xd_k1)
