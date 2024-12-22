clear
close all
tr=load('training.mat');
in=load('input.mat');
out=load('output.mat');
test = load('test.mat');
val = load('Validation.mat');
n1t = tr.training.AirFlowTPH;
n2t = tr.training.Airflow2TPH;
n3t = tr.training.waterFlow;
n4t = tr.training.stokerSpeed;
x1t = tr.training.Temperatureoc;
x2t = tr.training.pressureps;
x3t = tr.training.DrumLevel;
n1ts = test.Test.AirFlowTPH;
n2ts = test.Test.Airflow2TPH;
n3ts = test.Test.waterFlow;
n4ts = test.Test.stokerSpeed;
x1ts = test.Test.Temperatureoc;
x2ts = test.Test.pressureps;
x3ts = test.Test.DrumLevel;
n1v = val.Validation.AirFlowTPH;
n2v = val.Validation.Airflow2TPH;
n3v = val.Validation.waterFlow;
n4v = val.Validation.stokerSpeed;
x1v = val.Validation.Temperatureoc;
x2v = val.Validation.pressureps;
x3v = val.Validation.DrumLevel;
xn_train = [n1t,n2t,n3t,n4t];          
dn_train = [x1t,x2t,x3t];         
xn_test = [n1ts,n2ts,n3ts,n4ts];          
dn_test = [x1ts,x2ts,x3ts];
xn_val = [n1v,n2v,n3v,n4v];          
dn_val = [x1v,x2v,x3v];
Ts = 1;
z = iddata(dn_train,xn_train,Ts);
z_test=iddata(dn_test,xn_test,Ts);
z_val=iddata(dn_val,xn_val,Ts);
net=cascadeforwardnet(300)
net.layers{1}.transferFcn = 'logsig';
net.layers{1}.netInputFcn = 'netsum';
net_estimator = neuralnet(net);
nanbnk = [3*ones(3,3), 3*ones(3,4), ones(3,4)];
sysMIMO = idnlarx(z.OutputName, z.InputName, nanbnk, net_estimator)
getreg(sysMIMO);
sysMIMO =nlarx(z,sysMIMO)
compare(z,sysMIMO)