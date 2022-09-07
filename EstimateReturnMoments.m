function [MU, SIGMA]=EstimateReturnMoments(R, Semi)
if ~exist('Semi','var')
Semi = 0;
end
MU=mean(R,1)';
n=size(R,2);
if ~Semi
SIGMA=cov(R);
else
sigma=zeros(n,1);
for i=1:n
dev = R(:,i) - MU(i);
sigma(i) = sqrt(mean(dev(dev<0).^2));
end
rho=corrcoef(R);
SIGMA=rho;
for i=1:n
SIGMA(i,:)=SIGMA(i,:)*sigma(i);
SIGMA(:,i)=SIGMA(:,i)*sigma(i);
end
end
end