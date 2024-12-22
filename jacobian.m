syms 'x' 'delt' 'w' 'u_1' 'u_2' 'real'
r=7.2; kmf=0.123; D=0.0004; J=0.0007046; L=0.01;
f=[x + (delt/L)*(-r*x - kmf*w*x + u_1);
   w + (delt/J)*(kmf*(x^2) - D*w - u_2)]
   delf =simplify(jacobian(f,[x,w]))
