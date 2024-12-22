clear all
close all
clc;
%Simulation parameters
tsim=100; dt=0.001;
%design parameters
k_1z=1;kv_z=2/k_1z; k_2z=1;
k_1x=1;kv_x=2/k_1x; k_2x=1;
k_1y=1;kv_y=2/k_1y; k_2y=1;
k_1phi=1;kv_phi=2/k_1phi; k_2phi=1;
k_1theta=1;kv_theta=2/k_1theta; k_2theta=1;
k_1si=1; kv_si=2/k_1si; k_2si=1;
%State variables 
phi_1k0=0;phi_2k0=0;
si_1k0=0;si_2k0=0;
theta_1k0=0;theta_2k0=0;
z_1k0=0;z_2k0=0;
x_1k0=0;x_2k0=0;
y_1k0=0;y_2k0=0;
u_1k0=0;u_2k0=0;u_3k0=0;u_4k0=0;
%vitrual control initial condistion
xv_1k0=0; xv_2k0=0; 
yv_1k0=0; yv_2k0=0;
zv_1k0=0; zv_2k0=0;
phiv_1k0=0;phiv_2k0=0;
thetav_1k0=0; thetav_2k0=0;
siv_1k0=0;siv_2k0=0;
%System parameter
I_xx=0.01;
I_yy=0.01;
I_zz=0.01;
g=-9.81;
m=0.5;
d=0.25;
for i=0:dt:tsim
%desired trajectories
z_d=5;
x_d=0;
y_d=0.5;
phi_d=0;
theta_d=0;
si_d=pi/2;
%system dynamics
% z position dynamics
% z_1k0=z_d + z_1k0;
z_1k1=z_1k0 + dt*z_2k0;
z_2k1=z_2k0 + dt*(g - u_1k0*cos(phi_1k0)*cos(theta_1k0)/m);
%altitude control signals
z_1k1=z_d - z_1k1;
zv_1k1=zv_1k0 + dt*zv_2k0;
zv_2k1=(1+dt*(k_1z-kv_z)*zv_2k0 + dt*(kv_z*k_1z - 1)*z_1k1);
u_1k1=m*(g + (1 +k_1z^2)*z_1k1 + k_2z*z_2k1 - (k_1z + k_2z)*zv_1k1 - (zv_2k1 - zv_2k0)/dt);
% x position dynamics
% x_1k0=x_d - x_1k0;
x_1k1=x_1k0 + dt*x_2k0;
x_2k1=x_2k0 - dt*u_1k1*(cos(phi_1k0)*sin(theta_1k0)*cos(si_1k0) + sin(phi_1k0)*sin(si_1k0))/m;
%x position control
x_1k1=x_d - x_1k1;
xv_1k1=xv_1k0 + dt*xv_2k0;
xv_2k1=(1+dt*(k_1x-kv_x)*xv_2k0 + dt*(kv_x*k_1x - 1)*x_1k1);
phi_dx=(-m/(u_1k1*si_d))*(u_1k1*theta_1k0/m - (1 +k_1x^2)*x_1k1 - k_2x*x_2k1 + (k_1x + k_2x)*xv_1k1 + (xv_2k1 - xv_2k0)/dt);
% y position dynamics
% y_1k0=y_d - y_1k0;
y_1k1=y_1k0 + dt*y_2k0;
y_2k1=y_2k0 - dt*u_1k1*(cos(phi_1k0)*sin(theta_1k0)*sin(si_1k0) - sin(phi_1k0)*sin(si_1k0))/m;
%y position control
y_1k1=y_d - y_1k1;
yv_1k1=yv_1k0 + dt*yv_2k0;
yv_2k1=(1+dt*(k_1y - kv_y)*yv_2k0 + dt*(kv_y*k_1y - 1)*y_1k1);
theta_yd=(-m/(u_1k1*si_d))*(- (1 +k_1y^2)*y_1k1 - k_2y*y_2k1 + (k_1y + k_2y)*yv_1k1 - (yv_2k1 - yv_2k0)/dt);
%roll agle dynamics
% phi_1k0=(phi_d + phi_dx) + phi_1k0;
phi_1k1=phi_1k0 + dt*phi_2k0;
phi_2k1=phi_2k0 + dt*(I_yy - I_zz)*theta_2k0*si_2k0/I_xx + dt*(1/I_xx)*u_2k0;
%roll angle control law
phi_1k1=(phi_d + phi_dx) - phi_1k1;
phiv_1k1=phiv_1k0 + dt*phiv_2k0;
phiv_2k1=(1 + dt*(k_1phi - kv_phi)*phiv_2k0 + dt*(kv_phi*k_1phi - 1)*phi_1k1);
u_2k1=(-I_xx/d)*((1 +k_1phi^2)*phi_1k1 + k_2phi*phi_2k1 - (k_1phi + k_2phi)*phiv_1k1 - (phiv_2k1 - phiv_2k0)/dt);
%pitch angle dynamics
% theta_1k0=(theta_d + theta_yd) + theta_1k0;
theta_1k1=theta_1k0 + dt*theta_2k0;
theta_2k1=theta_2k0 + dt*(I_zz - I_xx)*phi_2k0*si_2k0/I_yy + dt*(1/I_yy)*u_3k0; 
%pitch angle control law
theta_1k1=(theta_d + theta_yd) - theta_1k1;
thetav_1k1=thetav_1k0 + dt*thetav_2k0;
thetav_2k1=(1 + dt*(k_1theta - kv_theta)*thetav_2k0 + dt*(kv_theta*k_1theta - 1)*theta_1k1);
u_3k1=(-I_yy/d)*((1 +k_1theta^2)*theta_1k1 + k_2theta*theta_2k1 - (k_1theta + k_2theta)*thetav_1k1 - (thetav_2k1 - thetav_2k0)/dt);
%yaw angle dynamics
% si_1k0=si_d  + si_1k0;
si_1k1=si_1k0 + dt*si_2k0;
si_2k1=si_2k0 + dt*(I_xx - I_yy)*phi_2k0*theta_2k0/I_zz + dt*(1/I_zz)*u_4k0;
%yaw angle control law
si_1k1=si_d  - si_1k1;
siv_1k1=siv_1k0 + dt*siv_2k0;
siv_2k1=(1 + dt*(k_1si - kv_si)*siv_2k0 + dt*(kv_si*k_1phi - 1)*si_1k1);
u_4k1=(-I_zz/d)*((1 +k_1si^2)*si_1k1 + k_2si*si_2k1 - (k_1si + k_2si)*siv_1k1 - (siv_2k1 - siv_2k0)/dt);
%data holding
j=round((1 + (i*(1/dt))));
data.x(j)=x_1k1;
data.y(j)=y_1k1;
data.z(j)=z_1k1;
data.phi(j)=phi_1k1;
data.si(j)=si_1k1;
data.theta(j)=theta_1k1;
%parameter swaping
phi_1k0=phi_1k1;phi_2k0=phi_2k1;
phiv_1k0=phiv_1k1;phiv_2k0=phiv_2k1;
theta_1k0=theta_1k1;theta_2k0=theta_2k1;
thetav_1k0=thetav_1k1;thetav_2k0=thetav_2k1;
si_1k0=si_1k1;si_2k0=si_2k1;
siv_1k0=siv_1k1;siv_2k0=siv_2k1;
z_1k0=z_1k1;z_2k0=z_2k1;
zv_1k0=zv_1k1;zv_2k0=zv_2k1;
x_1k0=x_1k1;x_2k0=x_2k1;
xv_1k0=xv_1k1;xv_2k0=xv_2k1;
y_1k0=y_1k1;y_2k0=y_2k1;
yv_1k0=yv_1k1;yv_2k0=yv_2k1;
u_1k0=u_1k1;u_2k0=u_2k1;
u_3k0=u_3k1;u_4k0=u_4k1;
end
m=0:dt:tsim;
subplot(2,3,1)
plot(m,data.x)
xlabel('time')
ylabel('x position')
subplot(2,3,2)
plot(m,data.y)
xlabel('time')
ylabel('y position')
subplot(2,3,3)
plot(m,data.z)
xlabel('time')
ylabel('z position')
subplot(2,3,4)
plot(m,data.phi)
xlabel('time')
ylabel('roll angle')
subplot(2,3,5)
plot(m,data.theta)
xlabel('time')
ylabel('pitch angle')
subplot(2,3,6)
plot(m,data.si)
xlabel('time')
ylabel('yaw angle')