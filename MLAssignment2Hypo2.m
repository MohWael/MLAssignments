clc
clear all
close all
ds = datastore('heart_DD.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',250);
T = read(ds);

m= length(T{:,1})*0.6;
mF= length(T{:,1})*0.2;
mS= length(T{:,1})*0.2;
x=T{1:m,1:13};
y=T{1:m,14};
 
p=find(y==1);
n=find(y==0);

m1= length(T{1:m,1});
a = length(T{:,1});
Alpha=0.001;
lamda=100;
 
X=[ones(m,1) x.^2 x];
Y=T{1:m,14}/mean(T{1:m,14});
n=length(X(1,:)); 
 for w=2:n
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
    end
 end
 
 theta=zeros(n,1);
 
 h=1./(1+exp(-X*theta)); 
 
 k=1;
 E(k)=-(1/m)*sum(Y.*log(h)+(1-Y).*log(1-h))+(lamda/(2*m))*sum((theta).^2); 
 
 g=zeros(size(theta,1),1);
  
 for i=1:size(g)
     g(i)=(1/m)*sum((h-Y)'*X(:,i));
 end
 

R=1;
while R==1
Alpha=Alpha*1.01;
theta=theta-(Alpha/m1)*X'*(h-Y);
h=1./(1+exp(-X*theta)); 
k=k+1

E(k)=(-1/m1)*sum(Y.*log(h)+(1-Y).*log(1-h))+(lamda/(2*m1))*sum((theta).^2);
if E(k-1)-E(k) <0 
    break
end 
q=(E(k-1)-E(k))./E(k-1);
if q <.0000001
    R=0;
end
end
 
figure(1)
plot(E)


xF=T{m+1:m+mF,1:13};
yF=T{m+1:m+mF,14};
 
mFF= length(T{m+1:m+mF,1});
Alpha=0.001;
lamda=100;
 
XF=[ones(mF,1) xF.^2 xF];
YF=T{m+1:m+mF,14}/mean(T{m+1:m+mF,14});


nF=length(XF(1,:)); 
 for w=2:nF
    if max(abs(XF(:,w)))~=0
    XF(:,w)=(XF(:,w)-mean((XF(:,w))))./std(XF(:,w));
    end
 end
 
 theta1=theta;
 
 hF=1./(1+exp(-XF*theta1)); 
 
 kF=1;
 EF(kF)=-(1/mF)*sum(YF.*log(hF)+(1-YF).*log(1-hF))+(lamda/(2*mF))*sum((theta1).^2); 
 g=zeros(size(theta1,1),1);    
  
 for i=1:size(g)
     g(i)=(1/mF)*sum((hF-YF)'*XF(:,i));
 end
 
p=a-(m+mS);
xS=T{m+mF+1:end,1:13};
yS=T{m+mF+1:end,14};
 
 

mS= length(T{m+mF+1:end,1});
Alpha=0.001;
lamda=100;
 
XS=[ones(p,1) xS.^2 xS];
YS=T{m+mF+1:end,14}/mean(T{m+mF+1:end,14});


nS=length(XS(1,:)); 
 for w=2:nS
    if max(abs(XS(:,w)))~=0
    XS(:,w)=(XS(:,w)-mean((XS(:,w))))./std(XS(:,w));
    end
 end
 
 theta2=theta1(1:nS);
 
 hS=1./(1+exp(-XS*theta2)); 
 
 kS=1;
 ES(kS)=-(1/mS)*sum(yS.*log(hS)+(1-yS).*log(1-hS))+(lamda/(2*mS))*sum((theta2).^2); 
 
 g=zeros(size(theta2,1),1);    
  
 for i=1:size(g)
     g(i)=(1/mS)*sum((hS-yS)'*XS(:,i));
 end
 