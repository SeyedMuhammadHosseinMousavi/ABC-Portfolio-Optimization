function [z, out]=PortMOC(x,model)
R=model.R;
if isfield(model,'method')
method=model.method;
else
method='';
end
if isfield(model,'alpha')
alpha=model.alpha;
else
alpha='';
end
w=x/sum(x);
[rsk, ret]=CalculatePortfolioObjectives(w, R, method, alpha);
z=[rsk
-ret];
out.w=w;
out.rsk=rsk;
out.ret=ret;
end