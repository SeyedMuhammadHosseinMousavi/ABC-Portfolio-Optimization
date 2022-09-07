function out = RunABC(model)


%% Problem 
CostFunction=@(x) PortCost(x,model);        % Cost Function
nVar=size(model.R,2);             % Number of Decision Variables
VarSize=[1 nVar];   % Size of Decision Variables Matrix
VarMin=0;         % Lower Bound of Variables
VarMax=1;         % Upper Bound of Variables

%% ABC Settings

MaxIt = 80;              % Maximum Number of Iterations
nPop = 7;               % Population Size (Colony Size)

nOnlooker = nPop;         % Number of Onlooker Bees
L = round(0.6*nVar*nPop); % Abandonment Limit Parameter (Trial Limit)
a = 1;                    % Acceleration Coefficient Upper Bound

%% Initialization

% Empty Bee Structure
empty_bee.Position = [];
empty_bee.Cost = [];
empty_bee.Out = [];

% Initialize Population Array
pop = repmat(empty_bee, nPop, 1);

% Initialize Best Solution Ever Found
BestSol.Cost = inf;

% Create Initial Population
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
[pop(i).Cost pop(i).Out] = CostFunction(pop(i).Position);
if pop(i).Cost <= BestSol.Cost
BestSol = pop(i);
end
end

% Abandonment Counter
C = zeros(nPop, 1);

% Array to Hold Best Cost Values
BestCost = zeros(MaxIt, 1);

%% ABC Main Loop

for it = 1:MaxIt

% Recruited Bees
for i = 1:nPop

% Choose k randomly, not equal to i
K = [1:i-1 i+1:nPop];
k = K(randi([1 numel(K)]));

% Define Acceleration Coeff.
phi = a*unifrnd(-1, +1, VarSize);

% New Bee Position
newbee.Position = pop(i).Position+phi.*(pop(i).Position-pop(k).Position);

% Apply Bounds
newbee.Position = max(newbee.Position, VarMin);
newbee.Position = min(newbee.Position, VarMax);

% Evaluation
[newbee.Cost newbee.Out] = CostFunction(newbee.Position);

% Comparision
if newbee.Cost <= pop(i).Cost
pop(i) = newbee;
else
C(i) = C(i)+1;
end
end
% Calculate Fitness Values and Selection Probabilities
F = zeros(nPop, 1);
MeanCost = mean([pop.Cost]);
for i = 1:nPop
F(i) = exp(-pop(i).Cost/MeanCost); % Convert Cost to Fitness
end
P = F/sum(F);
% Onlooker Bees
for m = 1:nOnlooker
% Select Source Site
i = RouletteWheelSelection(P);
% Choose k randomly, not equal to i
K = [1:i-1 i+1:nPop];
k = K(randi([1 numel(K)]));
% Define Acceleration Coeff.
phi = a*unifrnd(-1, +1, VarSize);
% New Bee Position
newbee.Position = pop(i).Position+phi.*(pop(i).Position-pop(k).Position);
% Apply Bounds
newbee.Position = max(newbee.Position, VarMin);
newbee.Position = min(newbee.Position, VarMax);
% Evaluation
[newbee.Cost newbee.Out] = CostFunction(newbee.Position);
% Comparision
if newbee.Cost <= pop(i).Cost
pop(i) = newbee;
else
C(i) = C(i) + 1;
end
end

% Scout Bees
for i = 1:nPop
if C(i) >= L
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
[pop(i).Cost newbee.Out] = CostFunction(pop(i).Position);
C(i) = 0;
end
end

% Update Best Solution Ever Found
for i = 1:nPop
if pop(i).Cost <= BestSol.Cost
BestSol = pop(i);
end
end

% Store Best Cost Ever Found
BestCost(it) = BestSol.Cost;

% Display Iteration Information
disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
end
%% Export Results

out.BestSol=BestSol;
out.BestCost=BestCost;
end
