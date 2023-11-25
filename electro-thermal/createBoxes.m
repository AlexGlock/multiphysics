%% Create Material and Charge Distributions here
function [kappaBox, lambdaBox, epsBox, tempBox, potBox] = createBoxes(msh, kappa, lambda, epsilon, potential, width, height)

disp('erstelle Verteilungen mit Box Mesher')
lambda_air = 0.026;
temp_air = 0;
eps0 = 8.85e-12;
y_len = floor(msh.ny*0.6);

%% --- volume allocated: Kappa, Lambda, epsilon 

% --- Creating kappa Distribution -----------------------------------------
boxeskappa(1).box = [msh.nx/2-width/2+1, msh.nx/2+width/2-1, 1, msh.ny-y_len, 1, msh.nz];
boxeskappa(2).box = [msh.nx/2-1, msh.nx/2+1, msh.ny-y_len+1, msh.ny-3, 1, msh.nz];
boxeskappa(1).value = kappa; % in conductor
boxeskappa(2).value = kappa; % in conductor
defaultkappa = 0;
kappaBox = boxMesher(msh, boxeskappa, defaultkappa);

% --- Creating lambda Distribution ----------------------------------------
boxeslambda = boxeskappa;
boxeslambda(1).value = lambda;
boxeslambda(2).value = lambda;
defaultlambda = lambda_air;
lambdaBox = boxMesher(msh, boxeslambda, defaultlambda);

% --- Creating epsilon Distribution ---------------------------------------
boxeseps = boxeskappa;
boxeseps(1).value = epsilon;
boxeseps(2).value = epsilon;
defaulteps = eps0;
epsBox = boxMesher(msh, boxeseps, defaulteps);

%% --- Node Allocated: potential and temp

% --- Creating initial potential Distribution -----------------------------
boxespot(1).box = [msh.nx/2-width/2+1, msh.nx/2+width/2, 1, height, 1, msh.nz];
boxespot(1).value = potential;
defaultpot = NaN;
potBox = boxMesher(msh, boxespot, defaultpot);

% --- Creating initial heat Distribution ----------------------------------
boxestemp(1).box = [msh.nx/2-width/2+1, msh.nx/2+width/2, 1, msh.ny-y_len, 1, msh.nz];
boxestemp(1).value = NaN; 
boxestemp(2).box = [msh.nx/2-1, msh.nx/2+2, msh.ny-y_len+1, msh.ny-2, 1, msh.nz];
boxestemp(2).value = NaN;
boxestemp(3).box = [msh.nx/2-width/2+1, msh.nx/2+width/2, 1, height, 1, msh.nz];
boxestemp(3).value = temp_air;
defaulttemp = temp_air;
tempBox = boxMesher(msh, boxestemp, defaulttemp);


end