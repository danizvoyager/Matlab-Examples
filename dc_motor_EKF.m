close all
clear all
clc
x_k0=[0.5;0.5]; x_est_k00=[0;0]; tsim=0.4; delt=0.1;
u_k0=[0;1];R_k0=0.01; w_ref=5;
e_k0=0;
Q_k0=0.01*eye(2);
P_k00=0.01*eye(2);
Kp=1;Ki=1;Kd=1;
statenoise = randn(2, 1)
meastnoise = randn(1, 1) 
w_k = Q_k0* statenoise;
v_k = R_k0 * meastnoise;
for i=0:delt:tsim
%prediction stage
x_est_k10=f(x_est_k00,u_k0,delt)
P_k10=grad_f(x_est_k00,delt)*P_k00*(grad_f(x_est_k00,delt))' + Q_k0
%system dynamics(new measurment)
x_k1=f(x_k0,u_k0,delt)+ w_k;
z_k1=h(x_k1) + v_k;
z_ak1=x_k1;
%determine kalman gain
k_k=(P_k10*(grad_h(x_est_k10))')/(grad_h(x_est_k10)*P_k10*(grad_h(x_est_k10))'+ R_k0)
%measurment update
x_est_k11=x_est_k10 + k_k*(z_k1 - h(x_est_k10));
P_k11=(eye(2)- k_k*(grad_h(x_est_k10)))*P_k10;
e_k1=w_ref - x_k1(2,1);
u_k1=-(Kp*e_k1 + u_k0 + Ki*delt*e_k1 + Kd*delt*(e_k1 - e_k0));
u_k0=u_k1;
x_k0=x_k1;
P_k00=P_k10;
P_k10=P_k11;
x_est_k00=x_est_k10;
x_est_k10=x_est_k11;
e_k0=e_k1;
j=round((1 + (i*(1/delt))));
data.x_1k1(j)=x_k1(1,1);
data.z_a1k1(j)=z_ak1(1,1);
data.x_2k1(j)=x_k1(2,1);
data.z_a2k1(j)=z_ak1(2,1);
data.u_1k(j)=u_k1(1,1);
data.u_2k(j)=u_k1(2,1);
end
r=0:delt:tsim;
subplot(2,2,1);
plot(r,[data.x_1k1;data.z_a1k1])
subplot(2,2,2);
plot(r,[data.x_2k1;data.z_a2k1])
subplot(2,2,3);
plot(r,data.u_1k)
subplot(2,2,4);
plot(r,data.u_2k)
%gradient of h
function delh=grad_h(x)
delh=1;
end
%output function definition
function output_fun=h(x)
output_fun=x(1,1);
end
%state functions definition 
function state_fun=f(x,u,delt)
state_fun=[x(1,1) - 100*delt*((36*x(1,1))/5 - u(1,1) + (123*x(2,1)*x(1,1))/1000);
 x(1,1) - (9223372036854775808*delt*(u(2,1) + x(2,1)/2500 - (123*x(1,1)^2)/1000))/6498787937167875]
end
% gradient of f      
function delf=grad_f(x,delt)
delf =[1 - 100*delt*((123*(x(2,1)))/1000 + 36/5), -(123*delt*x(1,1))/10;
(94539563377761452032*delt*x(1,1))/270782830715328125, 1 - (2305843009213693952*delt)/4061742460729921875]
end

 