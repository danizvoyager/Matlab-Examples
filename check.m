clc
close all
clear all
a1=0.071;a2=0.057;a4=0.057;a3=0.071;
A1=28;A2=32;A3=28;A4=32;
Kc=0.5; g=981;delt=0.1;tsim=200;
k1=3.14;k2=3.29;gm1=0.3378;gm2=0.4333;
x01=12.6;x02=13;x03=4.8;x04=4.9;
u_1k0=5.3755;%(a1*sqrt(2*g*x01)-a3*sqrt(2*g*x03))/gm1*k1;
u_2k0=7.391;%(a2*sqrt(2*g*x02)-a4*sqrt(2*g*x04))/gm2*k2;
u_k0=[u_1k0;u_2k0];
Q_k0=0.001*eye(4);
p_k00=0.1*eye(4);
R_k0=0.001*eye(2);
a11=-a1*sqrt(g)/A1
a13= a3*sqrt(g)/A1
a21=-a2*sqrt(g)/A2
a24= a4*sqrt(g)/A2
a31=-a3*sqrt(g)/A3
a41=-a4*sqrt(g)/A4
b1=gm1*k1*Kc/A1;
b2=gm2*k2*Kc/A2;
b3=(1-gm2)*k2*Kc/A3;
b4=(1-gm1)*k1*Kc/A4;
dm=[0.3;0.3];
x_1k1=0;x_2k1=0;x_3k1=0;x_4k1=0;
x_1k0=x01;x_2k0=x02;x_3k0=x03;x_4k0=x03;
x_k0=[x_1k0;x_2k0;x_3k0;x_4k0];
x_k1=[x_1k1;x_2k1;x_3k1;x_4k1];
beta1=1;beta2=1;m1=1;m2=1;
F=[a11/sqrt(2*x01),0                ,a13/sqrt(2*x03) ,0;
   0              ,a21/sqrt(2*x02)  ,0               ,a24/sqrt(2*x04);
   0              ,0                ,a31/sqrt(2*x03) ,0;
   0              ,0                ,0               ,a41/sqrt(2*x04)]
G=[b1, 0;
   0      ,b2;
   0      ,b3;
   b4,0]
H=[Kc,0,0,0;
   0,Kc,0,0];
D=[0,0;0,0];
[num1,den1] = ss2tf(F,G,H,D,1);
[num2,den2] = ss2tf(F,G,H,D,2);
sys_11=tf(num1(1,:),den1);
Z_1 = zero(sys_11);
sys_12=tf(num1(2,:),den1);
Z_2 = zero(sys_12);
sys_21=tf(num2(1,:),den2);
Z_3 = zero(sys_21);
sys_22=tf(num2(2,:),den2);
Z_4 = zero(sys_22);
H1=Kc*eye(4);
T=[-1/b1,0    ,0    ,1/b4;
    0   ,-1/b2,1/b3 ,0   ;
    0   ,0    ,1/b3 ,0   ;
    0   ,0    ,0    ,1/b4];
Y=(T*F)/T;
Gl=T*G;
Y11=[Y(1,1),Y(1,2);Y(2,1),Y(2,2)];
Y12=[Y(1,3),Y(1,4);Y(2,3),Y(2,4)];
Y21=[Y(3,1),Y(3,2);Y(4,1),Y(4,2)];
Y22=[Y(3,3),Y(3,4);Y(4,3),Y(4,4)];
Qlqr=10*eye(2);
Rlqr=10*eye(2);
Klqr = lqrd(Y11,Y12,Qlqr,Rlqr,delt)