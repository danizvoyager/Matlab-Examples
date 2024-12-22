kf=5.7e-8;
kt=0.016;
km=0.35;
J=0.025;
b=0.002;
ra=3.5;
la=1.5e-5;
m=0.5;
Ix=0.3125;
Iy=0.3125;
Iz=0.3125;
d=0.5;
kx=0.016;
ky=0.016;
kz=0.016;
g=9.81;
A=[   0  1  0  0    0   0    0   0   0   0   0  0;
      0  0  0  0    0   0    0   0   0   0   0  0;
      0  0  0  1    0   0    0   0   0   0   0  0;
      0  0  0  0    0   0    0   0   0   0   0  0;
      0  0  0  0    0   1    0   0   0   0   0  0;
      0  0  0  0    0   0    0   0   0   0   0  0;
      0  0  0  0    0   0    0   1   0   0   0  0;
      0  0  0  0    0   0    0 -kx/m 0   0   0  0;
      0  0  0  0    0   0    0   0   0   1   0  0;
      0  0  0  0    0   0    0   0   0 -ky/m 0  0;
      0  0  0  0    0   0    0   0   0   0   0  1;
      0  0  0  0    0   0    0   0   0   0   0 -kz/m];

B=[0     0    0    0;
   0    d/Ix  0    0;
   0     0    0    0;
   0     0  d/Iy   0;
   0     0    0    0;
   0     0    0   d/Iz;
   0     0    0    0;
   1/m   0    0    0;
   0     0    0    0;
   1/m   0    0    0;
   0     0    0    0;
   1/m   0    0    0];
B1=[0     0    0    0;
    0     0    0    0;
    0     0    0    0;
    0     0    0    0;
    0     0    0    0;
    0     0    0    0;
    0     0    0    0;
  -1/m    0    0    0;
    0     0    0    0;
  -1/m    0    0    0;
    0     0    0    0;
    0     0    0    0];
C=[1 0 0 0 0 0 0 0 0 0 0 0;
   0 0 1 0 0 0 0 0 0 0 0 0;
   0 0 0 0 1 0 0 0 0 0 0 0;
   0 0 0 0 0 0 1 0 0 0 0 0;
   0 0 0 0 0 0 0 0 1 0 0 0;
   0 0 0 0 0 0 0 0 0 0 1 0 ];
D=[0 0 0 0;
   0 0 0 0;
   0 0 0 0;
   0 0 0 0;
   0 0 0 0;
   0 0 0 0];
e=eig(A)
sys_ss=ss(A,B,C,D)
Q=25*(C'*C);
% Q(1,1)=5000;
% Q(3,3)=5000;
% Q(5,5)=5000;
% Q(7,7)=5000;
% Q(9,9)=5000;
% Q(11,11)=5000;
R=eye(4);
K= lqr(sys_ss,Q,R)
sys_tf_uc = tf(sys_ss);
A_c=A-B*K;
pole_zero_unc=zpk(sys_ss)
co=ctrb(sys_ss)
controllability=rank(co)
   Ob = obsv(A,C)  
   Ac=(A-B*K);
   Bc=B;
   Cc=C;
   Dc=D;
  sys_cl=ss(A,B,C,D);
  sys_tf_c = tf(sys_cl);
  pole_zero_c=zpk(sys_cl);