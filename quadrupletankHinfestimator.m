clc
close all
clear all 
syms p11 p12 p21 p22 'real'
P_n =[p11, p12;p21,p22];
a1=0.071;a2=0.057;a4=0.057;a3=0.071;
A1=28;A2=32;A3=28;A4=32;
Kc=0.5; g=981;delt=0.1;tsim=200;
k1=3.14;k2=3.29;gm1=0.3373;gm2=0.433;GM=1;
x01=12.6;x02=13;x03=4.8; x04=4.9;
u_1k0=Kc*5.3755;%(a1*sqrt(2*g*x01)-a3*sqrt(2*g*x03))/gm1*k1;
u_2k0=Kc*7.3910;%(a2*sqrt(2*g*x02)-a4*sqrt(2*g*x04))/gm2*k2;
u_k0=[u_1k0;u_2k0];
u_0=u_k0;
Q_k0=0.01*eye(4);
xest_k00=[0;0;0;0];
p_k00=eye(4);
R_k0=0.01*eye(2);
a11=-a1*sqrt(2*g)/A1;
a13= a3*sqrt(2*g)/A1;
a21=-a2*sqrt(2*g)/A2;
a24= a4*sqrt(2*g)/A2;
a31=-a3*sqrt(2*g)/A3;
a41=-a4*sqrt(2*g)/A4;
b1=gm1*k1/A1;
b2=gm2*k2/A2;
b3=(1-gm2)*k2/A3;
b4=(1-gm1)*k1/A4;
dm=[0.3;0.3];
x_1k1=0;x_2k1=0;x_3k1=0;x_4k1=0;
x_1k0=x01;x_2k0=x02;x_3k0=x03;x_4k0=x04;
x_k0=[x_1k0;x_2k0;x_3k0;x_4k0];
x_k1=[x_1k1;x_2k1;x_3k1;x_4k1];
beta1=1;beta2=1;m1=1;m2=1;
F=[a11/sqrt(2*x01),0                ,a13/sqrt(2*x03) ,0;
   0              ,a21/sqrt(2*x02)  ,0               ,a24/sqrt(2*x04);
   0              ,0                ,a31/sqrt(2*x03) ,0;
   0              ,0                ,0               ,a41/sqrt(2*x04)];
G=[b1, 0;
   0 ,b2;
   0 ,b3;
   b4,0];
H=[Kc,0,0,0;
   0,Kc,0,0];
H1=eye(4);
T=[-1/b1,0    ,0    ,1/b4;
    0   ,-1/b2,1/b3 ,0   ;
    0   ,0    ,1/b3 ,0   ;
    0   ,0    ,0    ,1/b4];
Y=(T*F)/T;
Gl=T*G;
Y11=[Y(1,1),Y(1,2);Y(2,1),Y(2,2)]
Y12=[Y(1,3),Y(1,4);Y(2,3),Y(2,4)]
Y21=[Y(3,1),Y(3,2);Y(4,1),Y(4,2)]
Y22=[Y(3,3),Y(3,4);Y(4,3),Y(4,4)]
Qlqr=10*eye(2)
Rlqr=10*eye(2)
Klqr = lqrd(Y11,Y12,Qlqr,Rlqr,delt)
vars=[p11,p12,p21, p22];
eqn= simplify((Y11 - Y12*Klqr)' *P_n*(Y11 - Y12*Klqr) + eye(2));
[p11,p12,p21,p22]=solve(eqn==P_n, vars);
P_n=double([p11, p12; p21, p22]);
statenoise = randn(4, 1);
meastnoise = randn(2, 1); 
Statenoise = Q_k0* statenoise;
Meastnoise = R_k0 * meastnoise;
%system dynamics
for i=0:delt:tsim
 %prediction stage
  xest_k10=F*x_k0 + G*u_k0;
  p_k10=F*p_k00*(F') + Q_k0;
%system dynamics
 x_k1=x_k0 + delt*(F*x_k0 + G*u_k0 + Statenoise);
%measurment result;
 z_k1=H*x_k1 + Meastnoise; 
 z_ak1=H1*x_k1;
%measurment result;
%state estimation
%determine inovation matrix and kalman filter gain
%determine inovation matrix and kalman filter gain
vk=z_k1 - H*xest_k10;
k_inf=(p_k10*(H'))/(H*p_k10*H' + R_k0);
%update after measurment
xest_k11=xest_k10 + k_inf*vk;
p_k11=inv(inv(p_k10) + (H'/R_k0)*H  - (GM^(-2))*eye(4));
%controller design
si_z=[-beta1*exp(-m1*abs(x_k1(1,1) - x01)),0;
      0                       ,-beta1*exp(-m2*abs(x_k1(2,1) - x02))];
P=[1223.39,-32.47;-32.57,162.17];
ck1=[Klqr - si_z*(Y12')*P_n*(Y11-Y12*Klqr),eye(2)];
u_k1=-(ck1*T*G)\((ck1)*T*(F*x_k1 + Statenoise));
%store data
j=round((1 + (i*(1/delt))));
data.x_1k1(j)=x_k1(1,1);
data.z_a1k1(j)=z_ak1(1,1);
data.x_2k1(j)=x_k1(2,1);
data.z_a2k1(j)=z_ak1(2,1);
data.x_3k1(j)=x_k1(3,1);
data.z_a3k1(j)=z_ak1(3,1);
data.x_4k1(j)=x_k1(4,1);
data.z_a4k1(j)=z_ak1(4,1);
data.u_1k(j)=u_k1(1,1);
data.u_2k(j)=u_k1(2,1);
u_k0=u_k1;
x_k0=x_k1;
p_k00=p_k10;
p_k10=p_k11;
xest_k00=xest_k10;
xest_k10=xest_k11;
end
r=0:delt:tsim;
subplot(2,3,1);
plot(r,[data.x_1k1;data.z_a1k1])
subplot(2,3,2);
plot(r,[data.x_2k1;data.z_a2k1])
subplot(2,3,3);
plot(r,data.u_1k)
subplot(2,3,4);
plot(r,[data.x_3k1;data.z_a3k1])
subplot(2,3,5);
plot(r,[data.x_4k1;data.z_a4k1])
subplot(2,3,6);
plot(r,data.u_2k)

