clear 
ds = tabularTextDatastore('house_data_complete1.csv','TreatAsMissing','NA',.....
    'MissingValue',0,'ReadSize',25000);

T = read(ds);
size(T);
Alpha=.01; % Alpha
m=ceil(length(T{:,1})*0.6);
mF=ceil(length(T{:,1})*0.2);
mS=ceil(length(T{:,1})*0.2);

U0=T{1:m,2}; %Date
U=T{1:m,4:19}; %All other features
U1=T{1:m,20:21}; %Sqft_living & Sqft_Iot15
U2=U.^5; %Squaring of all features
U0F=T{m+1:m+mF,2};
U0S=T{m+mF+1:end,2};
UF=T{m+1:m+mF,4:19};
US=T{m+mF+1:end,4:19};
U1F=T{m+1:m+mF,20:21};
U1S=T{m+mF+1:end,20:21};
U2F=UF.^5;
U2S=US.^5;

X=[ones(m,1) U U1 U2]; 
XF=[ones(mF,1) UF U1F U2F];
l=length(T{:,1})-(m+mF);
XS=[ones(l,1) US U1S U2S];

n=length(X(1,:)); %no. of all columns in vector X
nF=length(XF(1,:));
nS=length(XS(1,:));

%Mean Normalization of Vector X
for w=2:n
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
    end
end

Y=T{1:m,3}/mean(T{1:m,3}); %Normalization of Price
YF=T{m+1:m+mF,3}/mean(T{m+1:m+mF,3});
YS=T{m+mF+1:end,3}/mean(T{m+mF+1:end,3});
Theta=zeros(n,1);
k=1;
lamda=0;

E(k)=(1/(2*m))*sum((X*Theta-Y).^2)+(lamda/(2*m))*sum((Theta).^2);

R=1;
while R==1
Alpha=Alpha*1.01;
Theta=Theta-(Alpha/m)*X'*(X*Theta-Y);
k=k+1;

E(k)=(1/(2*m))*sum((X*Theta-Y).^2);
if E(k-1)-E(k)<0
    break
end 
q=(E(k-1)-E(k))./E(k-1);
if q <.0001;
    R=0;
end
end
figure(1)
plot(E)

ThetaF=Theta;
ThetaS=ThetaF;
kk=1;


for w=2:nF
    if max(abs(XF(:,w)))~=0
   XF(:,w)=(XF(:,w)-mean((XF(:,w))))./std(XF(:,w));  
   end
end
for w=2:nS
    if max(abs(XS(:,w)))~=0
   XS(:,w)=(XS(:,w)-mean((XS(:,w))))./std(XS(:,w));  
    end
end
EF=(1/(2*mF))*sum((XF*ThetaF-YF).^2);
ES=(1/(2*mS))*sum((XS*ThetaS-YS).^2);