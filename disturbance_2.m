mc=0.5; mp=0.2; L=0.3; b1=0.1; b2=0.002; I=0.006; g=9.81;
DN=(mc+mp)*(I+mp*L^2)-(mp^2*L^2);
A=[0 1 0 0;0 (-b1*(I+mp*L^2)/DN)  (mp^2*L^2*g)/DN (mp*L*b2)/DN; 0 0 0 1; 0 (b1*mp*L)/DN (-(mc+mp)*mp*g*L)/DN (-(mc+mp)*b2)/DN];
B=[0; (I+mp*L^2)/DN; 0; -mp*L/DN];
C=[1 0 0 0;0 0 1 0];
D=[0;0];
system=ss(A,B,C,D)
%%
inputs = {'F'};
outputs = {'x'; 'tetha'};
G=tf(system)
set(G,'InputName',inputs)
set(G,'OutputName',outputs)
%%
clf
figure(1);
t=0:0.01:1;
impulse(G,t);
grid;
title('Open-Loop Impulse Response of the system')
%%
Poles=eig(A)
pzmap(system);
title('Pole-zero mapping of inverted pendulum')

%%
Qc=ctrb(system);
Rank_CO=rank(Qc)
unco=length(A)-rank(Qc)
%%
Q = C'*C;
Q(1,1) = 0.5; 
Q(3,3) = 1000; 
R =0.5;
K = lqr(A,B,Q,R) %state-feedback control gain matrix
Ac = A-B*K %constrol matrix
eig(Ac)
system_c = ss(Ac,B,C,D); %the controlled system state space model
t = 0:0.01:20;
r =ones(size(t));
%figure(3)
[y,t,x]=lsim(system_c,r,t);
% %plot(t,y(:,1),t,y(:,2),'linewidth',2)
subplot 211
plot(t,y(:,1),'k','linewidth',2);% cart position
xlabel('t'),ylabel('x')
grid on
subplot 212
plot(t,y(:,2),'b','linewidth',2);% pendulum angle
xlabel('t'),ylabel('phi')
 grid on