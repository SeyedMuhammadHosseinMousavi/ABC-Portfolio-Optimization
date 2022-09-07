function [rsk, ret]=CalculatePortfolioObjectives(w, R, method, alpha)
w=reshape(w,[],1);
% Methods
% mv = Mean-Variance
% msv = Mean-Semi-Variance
% mad = Mean-Absolute-Deviation
% cvar = Conditional Value at Risk
if ~exist('method','var') || isempty(method)
method = 'mv';
end
if ~exist('alpha','var') || isempty(alpha)
alpha = 0.95;
end
method=lower(method);
switch method
case 'mad'
port=PortfolioMAD();
port=port.setScenarios(R);
case 'cvar'
port=PortfolioCVaR();
port=port.setScenarios(R);
port=port.setProbabilityLevel(alpha);
otherwise
Semi=strcmp(method,'msv');
[MU, SIGMA]=EstimateReturnMoments(R,Semi);
port=Portfolio();
port=port.setAssetMoments(MU,SIGMA);
end
port=port.setDefaultConstraints();
rsk = port.estimatePortRisk(w);
ret = port.estimatePortReturn(w);
end