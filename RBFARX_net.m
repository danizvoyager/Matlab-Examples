clear
close all
load tf20
load input
load output
ust=input(1:100,:)'          % training data
yst=output(1:100,:)'
usv=input(101:200,:)';        % validating data, validated in 'Validating.m'
ysv=output(101:200,:)';
xn_train=con2seq(ust);  
dn_train=con2seq(yst);
xn_val=con2seq(usv);  
dn_val=con2seq(ysv);
net = narxnet([1,2,3,4],[1,2,3,4],12);
net.layers{1}.transferFcn = 'radbas';
net.layers{1}.netInputFcn = 'netprod';
% net.biasConnect(1)=1;
% net.biasConnect(2)=1;
view(net)
[Xs,Xi,Ai,Ts] = preparets(net,xn_train,{},dn_train)
net = train(net,Xs,Ts,Xi,Ai);
[Y,Xf,Af] = net(Xs,Xi,Ai);
perf = perform(net,Ts,Y)
view(net)
[netc,Xic,Aic] = closeloop(net,Xf,Af);
gensim(netc,0.05);
view(netc);
gregnet = netc;
save gregnet;
y=netc(xn_train);
Y_r=cell2mat(seq2con(y));
% t=0:1:length(yst)-1;
figure(1)
plot(Y_r(1,:));
legend('Network output','Actual output')
title('Temperature')
  figure(2)
plot(Y_r(2,:));
legend('Network output','Actual output')
title('Pressure')
  figure(3)
plot(Y_r(3,:));
legend('Network output','Actual output')
title('Drum Level')