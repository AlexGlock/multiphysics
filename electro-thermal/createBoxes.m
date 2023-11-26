%% Create Material and Charge Distributions here
function [kappaBox, lambdaBox, epsBox, tempBox, potBox] = createBoxes(msh, kappa, lambda, epsilon, potential, diameter)

disp('erstelle Verteilungen mit Box Mesher')
lambda_air = 0.026;
temp_air = 0;
eps0 = 8.85e-12;

if ceil(diameter) < 1
    connector = 1;
else
    connector = round(diameter);
end

outer_height = ceil(msh.ny*0.5) + connector;
% calc geometric quantities
outer_width = ceil(msh.nx*0.33);
inner_width = msh.nx - 2*outer_width;

%% --- volume allocated: Kappa, Lambda, epsilon 

% --- Creating kappa Distribution -----------------------------------------

boxeskappa(1).box = [1, outer_width+inner_width, outer_height+1, msh.ny, 1, msh.nz];
boxeskappa(1).value = 0; 
boxeskappa(2).box = [outer_width+1, msh.nx, 1, msh.ny-outer_height, 1, msh.nz];
boxeskappa(2).value = 0;
defaultkappa = kappa;
kappaBox = boxMesher(msh, boxeskappa, defaultkappa);

% --- Creating lambda Distribution ----------------------------------------
boxeslambda = boxeskappa;
boxeslambda(1).value = lambda_air;
boxeslambda(2).value = lambda_air;
defaultlambda = lambda;
lambdaBox = boxMesher(msh, boxeslambda, defaultlambda);

% --- Creating epsilon Distribution ---------------------------------------
boxeseps = boxeskappa;
boxeseps(1).value = eps0;
boxeseps(2).value = eps0;
defaulteps = epsilon;
epsBox = boxMesher(msh, boxeseps, defaulteps);

%% --- Node Allocated: potential and temp

% --- Creating initial potential Distribution -----------------------------
boxespot(1).box = [1, outer_width, 1, 2, 1, msh.nz];
boxespot(1).value = potential;
boxespot(2).box = [outer_width+inner_width+1, msh.nx, msh.ny-1, msh.ny, 1, msh.nz];
boxespot(2).value = 0;
defaultpot = NaN;
potBox = boxMesher(msh, boxespot, defaultpot);

% --- Creating initial heat Distribution ----------------------------------
boxestemp(1).box = [1, outer_width+inner_width+1, outer_height, msh.ny, 1, msh.nz];
boxestemp(1).value = temp_air; 
boxestemp(2).box = [outer_width, msh.nx, 1, msh.ny-outer_height, 1, msh.nz];
boxestemp(2).value = temp_air;
defaulttemp = NaN;
tempBox = boxMesher(msh, boxestemp, defaulttemp);


end