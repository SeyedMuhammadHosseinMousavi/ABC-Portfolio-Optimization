function [z, out]=PortCost(x,model)
DesiredRet=model.DesiredRet;
[~, out]=PortMOC(x,model);
rsk = out.rsk;
ret = out.ret;
viol=max(0,1-ret/DesiredRet);
beta=1000;
z=rsk*(1+beta*viol);
out.viol=viol;
out.IsFeasible=(viol==0);
end