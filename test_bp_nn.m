%BP神经网络生成磁滞回线测试脚本

%生成磁滞回线上半部分
%归一化，调用mapminmax函数，此函数有多个原型以实现不同功能
[input,ps1]=mapminmax(H1);
[target,ps2]=mapminmax(B1);
%这里的ps1,2是归一化操作的种子，之后需要这两个种子进行reverse操作

%生成神经网络，newff函数原型为 net = newff(P,T,S,TF,BTF,BLF,PF,IPF,OPF,DDF)
%P：输入参数矩阵。(RxQ1)，其中Q1代表R元的输入向量。其数据意义是矩阵P有Q1列，
%	每一列都是一个样本，而每个样本有R个属性（特征）。一般矩阵P需要归一化，
	%即P的每一行都归一化到[0 1]或者[-1 1]。 
%T：目标参数矩阵。(SNxQ2)，Q2代表SN元的目标向量。
net1=newff(input,target,6,{'tansig','purelin'},'trainlm');

net1.trainParam.epochs=1000;%最大训练次数
net1.trainParam.goal=0.00001;%目标最小误差
LP.lr=0.000001;%学习速率

%对神经网络进行训练
net1=train(net1,input,target);

%生成等距向量
predict_H=-400:50:400;

%归一化
input_test=mapminmax('apply',predict_H,ps1);

%利用已经训练出的神经网络训练数据
output1=net1(input_test);

%reverse，逆运算复原数据
predict_value=mapminmax('reverse',output1,ps2);

%生成磁滞回线下半部分
%归一化，调用mapminmax函数
[input1,ps3]=mapminmax(H2);
[target1,ps4]=mapminmax(B2);
%这里的ps3,4是归一化操作的种子，之后需要这两个种子再进行reverse操作

net2=newff(input,target,6,{'tansig','purelin'},'trainlm');

net2.trainParam.epochs=1000;%最大训练次数
net2.trainParam.goal=0.00001;%目标最小误差
LP.lr=0.000001;%学习速率

%对神经网络进行训练
net2=train(net2,input1,target1);

%生成等距向量，此时可以省略
%predict_H=-400:50:400;

%归一化，此时不可以省略
input_test2=mapminmax('apply',predict_H,ps3);

%利用已经训练出的神经网络net2训练数据
output2=net2(input_test2);

%reverse，逆运算复原数据
predict_value2=mapminmax('reverse',output2,ps4);

%绘图
scatter(H1,B1,4,[222 87 18]/255);hold on
scatter(predict_H,predict_value,6,[0 87 222]/255);hold on
scatter(H2,B2,4,[222 222 18]/255);hold on
scatter(predict_H,predict_value2,6,[0 222 222]/255);