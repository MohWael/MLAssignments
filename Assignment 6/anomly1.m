close all
clear all 
clc

dataset=readtable('house_prices_data_training_data.csv');
Data=table2array(dataset(1:17999,4:21));
[m n]=size(Data);
%data = var_Normalise(Data);

Mean=mean(Data);
Std=std(Data);
eps=0.001;
Anomy=0;
%pdf_data=zeros(1,18);

for i=1:18
    %pdf_data(i)=normpdf(Data(1,i),mean_data(i),std_Data(i));
    A(i)=normpdf(Data(10000,i),Mean(i),Std(i));
    if prod(A)<eps || prod(A)>1-eps
        Anomy=Anomy+1;
    end
end

%if prod(pdf_data)>0.99
%    anomly=1;
%end
%if prod(pdf_data)<0.001
%    anomly=0;
%end