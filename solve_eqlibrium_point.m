syms u_1 u_2 gm1 gm2 'real'
syms q11 q12 q21 q22 'real'
W_l =[q11, q12;q21,q22];
a1=0.071;a2=0.057;a4=0.057;a3=0.071;
A1=28;A2=32;A3=28;A4=32;
Kc=0.5; g=981;delt=0.1;tsim=200;
k1=3.14;k2=3.29;
h1=12.6;h2=13;h3=4.8; h4=4.9;
eqn_1=simplify((-a1*sqrt(2*h1*g) + a3*sqrt(2*g*h3) + gm1*k1*Kc*u_1)/A1);
eqn_2=simplify((-a2*sqrt(2*h2*g) + a4*sqrt(2*g*h4) + gm2*k2*Kc*u_2)/A2);
eqn_3=simplify((-a3*sqrt(2*h3*g)  + (1-gm2)*k2*Kc*u_2)/A3);
eqn_4=simplify((-a4*sqrt(2*h4*g)  + (1-gm1)*k1*Kc*u_1)/A4);
eqn_a=solve(eqn_1==0);
eqn_b=solve(eqn_2==0);
eqn_c=solve(eqn_3==0);
eqn_d=solve(eqn_4==0);
gm1_val=double(solve(eqn_b==eqn_c));
gm2_val=double(solve(eqn_a==eqn_d));
gm1=gm1_val; gm2=gm2_val;
u_1=(a4*sqrt(2*h4*g))/((1-gm1)*k1*Kc);
u_2=(a3*sqrt(2*h3*g))/ ((1-gm2)*k2*Kc);
Y11 =[-0.0158         0;
           0   -0.0109];
Y12 =[-0.0451   -0.0020;
      -0.0147   -0.0260];
Klqr =[-0.6888   -0.2014;
        0.0627   -0.6423];
P_n=[1223.39,-32.47;-32.57,162.17];
eqn_l= P_n - ((Y11 - Y12*Klqr)' *P_n*(Y11 - Y12*Klqr) + W_l)
vars=[q11,q12,q21, q22];
[q11,q12,q21,q22]=solve(eqn_l==0, vars);
W_l=double([q11, q12; q21, q22])

