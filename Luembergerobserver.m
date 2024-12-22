ra=7.2;
la=0.5;
kb=0.0004;
j=0.00071;
kt=0.01;
A=[-ra/la, -kb/la;
   kt/j  , 0     ];
B=[1/la , 0   ;
   0    , -1/j];
C=[0,1];
D=0;
states={'ia' 'w'};
inputs={'va' 'tl'};
output={'w'};
system=ss(A,B,C,D,'statename', states, 'inputname', inputs, 'outputname',output);
sys_tf=tf(system)
control=ctrb(system)
observability=obsv(system)
syms h11 h12 h21 h22 'real'
eqn = simplify((A- [h11;h21]*C )- [-2 0; 0 -2])
vars=[h11 h21]
[h11 h21] = solve(eqn(2,1)==0,eqn(2,2)==0, vars)
H=double(simplify([h11;h21]))
