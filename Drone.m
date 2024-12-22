m=0.5;
Ix=0.3125;
Iy=0.3125;
Iz=0.3125;
d=0.5;
kx=0.1;
ky=0.1;
kz=0.1;
pi=3.14;
phi=2*pi;
theta=2*pi;
g=9.81;
A=[0 1 0 0 0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0 0 0 0 0;
0 0 0 1 0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0 0 0 0 0;
0 0 0 0 0 1 0 0 0 0 0 0;
0 0 0 0 0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 1 0 0 0 0;
0 0 g 0 0 0 0 -kx/m 0 0 0 0;
0 0 0 0 0 0 0 0 0 1 0 1;
-g 0 0 0 0 0 0 0 0 -ky/m 0 0;
0 0 0 0 0 0 0 0 0 0 0 1;
0 0 0 0 0 0 0 0 0 0 0 -g-kz/m]
B=[0 0 0 0;
0 d/Ix 0 0;
0 0 0 0;
0 0 d/Iy 0;
0 0 0 0;
0 0 0 d/Iz;
0 0 0 0;
1/m 0 0 0;
0 0 0 0;
1/m 0 0 0;
0 0 0 0;
1/m 0 0 0]
C=[1 0 0 0 0 0 0 0 0 0 0 0;
0 0 1 0 0 0 0 0 0 0 0 0;
0 0 0 0 1 0 0 0 0 0 0 0;
0 0 0 0 0 0 1 0 0 0 0 0;
0 0 0 0 0 0 0 0 1 0 0 0;
0 0 0 0 0 0 0 0 0 0 1 0];
D=[0 0 0 0;
0 0 0 0;
0 0 0 0;
0 0 0 0;
0 0 0 0;
0 0 0 0;];
e=eig(A)
sys_ss=ss(A,B,C,D)
Q=C'*C;
Q(1,1)=5000;
Q(3,3)=5000;
Q(5,5)=5000;
Q(7,7)=5000;
Q(9,9)=5000;
Q(11,11)=5000;
Q
R=eye(4);
K=lqr (A, B, Q, R)
sys_tf_uc = tf(sys_ss);
A_c=A-B*K;
% pole_zero_unc=zpk(sys_ss)
co=ctrb(sys_ss)
controllability=rank(co)
Ob = obsv(A,C)
N=inv(D-C*inv(A)*B)
F= -Inv(A)*B*inv(D - C*inv(A)*B)
Ac=(A-B*K);
Bc=B
Cc=C;
Dc=D;
t=0:0.01:5;
r=1*ones(size(t));
sys_cl=ss(A,B,C,D);
[y,t,x]=lsim(sys_cl,r,t);
[AX,H1,H2]=ploty(t,y(:,1),t,y(:,2),'plot');
set(get(AX(1),'ylabel'),'string','x possition(m)')
set(get(AX(2),'ylabel'),'string','y possition(m))')
hold on
[z,t,x]=lsim(sys_cl,r,t);
[AX,H1,H2]=plotyy(t,y(:,1),t,y(:,3),'plot');
set(get(AX(1),'ylabel'),'string','x possition(m)')
set(get(AX(2),'ylabel'),'string','z possition(m)')
title('step response with) LQR')
sys_tf_c = tf(sys_cl)
pole_zero_c=zpk(sys_cl)