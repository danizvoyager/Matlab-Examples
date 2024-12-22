clear
close all
load('tf3')
Ni=4;
Nj=3;
Ts=0.1;
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
xn_train = [n1t,n2t,n3t,n4t]';          
dn_train = [x1t,x2t,x3t]';  
xn_test = [n1ts,n2ts,n3ts,n4ts];          
dn_test = [x1ts,x2ts,x3ts];
xn_val = [n1v,n2v,n3v,n4v];          
dn_val = [x1v,x2v,x3v];
% create network
net = network( ...
1, ... % numInputs, number of inputs,
2, ... % numLayers, number of layers
[0; 1], ... % biasConnect, numLayers-by-1 Boolean vector,
[1; 0], ... % inputConnect, numLayers-by-numInputs Boolean matrix,
[0 0; 1 0], ... % layerConnect, numLayers-by-numLayers Boolean matrix
[0 1] ... % outputConnect, 1-by-numLayers Boolean vector
);
 %number of hidden layer neurons
net.layers{1}.size = 40;
% hidden layer transfer function
net.layers{1}.transferFcn = 'radbas';
net = configure(net,xn_train,dn_train);
% View network structure
view(net);
% initial network response without training
initial_output = net(xn_train);
% network training
net.trainFcn = 'trainlm';
net.performFcn = 'mse';
net = train(net,xn_train,dn_train);
% network response after training
y=net(xn_train)
perf = perform(net,dn_train,y)
IW=net.IW
LW=net.LW
b=net.b