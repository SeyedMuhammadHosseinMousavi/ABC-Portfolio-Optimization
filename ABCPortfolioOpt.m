% artificial bee colony algorithm for portfolio optimization
% data is a small 21*6 stock matrix stored in "R". You can use your data. 
% "nSol" is the number of solutions (less, faster). "Risk" and "return" will be
% printed at the end. Bye!

clc;
clear;
close all;

%% Run ABC
data=load('mydata');
R=data.R;

nAsset=size(R,2);
MinRet=min(mean(R,1));
MaxRet=max(mean(R,1));

nSol=10;

DR=linspace(MinRet,MaxRet,nSol);
model.R=R;
model.method='cvar';
model.alpha=0.95;
W=zeros(nSol,nAsset);
WReturn=zeros(nSol,1);
WRisk=zeros(nSol,1);
for k=1:nSol
model.DesiredRet=DR(k);
disp(['Running for Solution #' num2str(k) ':']);
out = RunABC(model);
disp('__________________________');
disp('');
W(k,:)=out.BestSol.Out.w;
WReturn(k)=out.BestSol.Out.ret;
WRisk(k)=out.BestSol.Out.rsk;
end
EF=find(~IsDominated(WRisk,WReturn));

%% res
figure;
plot(WRisk,WReturn,'y','LineWidth',2);
hold on;
plot(WRisk(EF),WReturn(EF),'r','LineWidth',4);
legend('','Efficient Frontier');
ax = gca; 
ax.FontSize = 14; 
ax.FontWeight='bold';
set(gca,'Color','w')
grid on;
xlabel('Risk');
ylabel('Return');
%% itr
figure;
plot(out.BestCost,'k', 'LineWidth', 2);
xlabel('ITR');
ylabel('Cost Value');
ax = gca; 
ax.FontSize = 14; 
ax.FontWeight='bold';
set(gca,'Color','c')
grid on;

%%
out.BestSol.Out
disp(['Risk is: ' num2str(out.BestSol.Out.rsk)]);
disp(['Return is: ' num2str(out.BestSol.Out.ret)]);

