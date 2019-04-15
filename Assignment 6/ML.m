close all
clear
clc

dataset = readtable('house_prices_data_training_data.csv');
Data = table2array(dataset(1:17999, 4:21));
[m n]=size(Data);

correlation_x = corr(Data);
covariance_x = cov(Data);

K = 0;
Alpha=0.01;
lamda=0.001;


% Normalisation
for w=1:n
    if max(abs(Data(:,w)))~=0;
        data(:,w)=(Data(:,w)-mean((Data(:,w))))./std(Data(:,w));
        
    end
end


[eigen_vector S V] =  svd(covariance_x);
% eigen_values= diag(S)';

%Calculate the K whic gives me the alpha<0.001
alpha=0.5;
while (alpha>=0.001)
    K=K+1;
    lamda1(K,:)=sum(max(S(:,1:K)));
    lamda2=sum(max(S));
    alpha=1-lamda1./lamda2;
end

reduced_data=eigen_vector(:, 1:K)'*(data)';
data_approx=eigen_vector(:,1:K)*reduced_data;
error_func=(1/m)*(sum(data_approx-data').^2);


%Linear Regression
h=1;
Theta=zeros(n,1);
k1=1;
Y=Data(:,3)/mean(Data(:,3));
E(k1)=(1/(2*m))*sum((data_approx'*Theta-Y).^2); %cost function

while h==1
    Alpha=Alpha*1;
    Theta=Theta-(Alpha/m)*data_approx*(data_approx'*Theta-Y);
    k1=k1+1;
    E(k1)=(1/(2*m))*sum((data_approx'*Theta-Y).^2);
    
    %Regularization
    Reg(k1)=(1/(2*m))*sum((data_approx'*Theta-Y).^2)+(lamda/(2*m))*sum(Theta.^2);
    %
    if E(k1-1)-E(k1)<0;
        break
    end
    q=(E(k1-1)-E(k1))./E(k1-1);
    if q <.000001
        h=0;
    end
end

%%%%%%% K-clustering
K  = 10;
max_iterations = 50;
%centroidss = initCentroids(data, K);
cost = zeros(1,10);
% 
for K=2:10

% centroidss = initCentroids(data, K);
for i=1:10
    for j=1:18
   Intial_centroids(i,j)=rand;
    end
end


for i=1:max_iterations
 
indices=getClosestCentroids(data, Intial_centroids);

 [centroids,error]=computeccentroids(data, indices, K);
 Intial_centroids = centroids; 
end

Error_per_Ietration(K)=error;
end
plot(Error_per_Ietration)
axis([2,10, 1, 10])
[a best_K] = min(Error_per_Ietration(2:10));









