function f=IsDominated(rsk,ret)
n=numel(rsk);
f=false(n,1);
for i=1:n
for j=i+1:n
if rsk(i)<rsk(j) && ret(i)>ret(j)
f(j)=true;
end
if rsk(i)>rsk(j) && ret(i)<ret(j)
f(i)=true;
end
end
end
end