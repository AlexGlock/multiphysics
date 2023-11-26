%% BEISPIEL von gekoppeltes J-Statik und Thermisches Problem

clearvars;
% Quellparameter
src_potential = 10;             % [V]

% Material in in Leiterstreifen (Kupfer)
cond_kappa = 5.8e7;             % [S/m] 
cond_lambda = 390.0;            % [W/mK] 
cond_epsilon = 1.9*8.85e-12;    % [F/m]

diameter = 2; % integer cell count


%% --- MESH ---------------------------------------------------------------

% Randbedingungen
bc = [0,0,0,0,0,0];

xmesh = linspace(-1,1,65);
ymesh = linspace(-1,1,65);
zmesh = linspace(0,1,2);
msh = cartMesh(xmesh, ymesh, zmesh);
[kappa, lambda, epsilon, temps, pots] = createBoxes(msh, cond_kappa, cond_lambda, cond_epsilon, src_potential, diameter);

%% --- Topologie und Material Matrizen ------------------------------------

% Erzeugung topologische Matrizen
[~, ~, st] = createTopMats(msh);
% Erzeugung geometrische Matrizen
[ds, ~, da, dat] = createGeoMats(msh);
% Erzeugung der Materialmatrix mit createMeps
Meps = createMeps(msh, ds, da, dat, epsilon, bc);
Mkap = createMeps(msh, ds, da, dat, kappa, bc);
Mlam = createMeps(msh, ds, da, dat, lambda, bc); 

%% --- J-Statik lösen -----------------------------------------------------

% Berechnung Systemmatrix: div(kap*grad(phi)) = 0
q = zeros(msh.np,1);
A = st*Mkap*st';
% Modifikation Systemmatrix und Ladungsvektor mit modPots
[A, q] = modPots(A, q, pots);
% Gleichungssystem lösen mit gmres(20)
[x, ~, ~, ~, ~] = gmres(A, q, 20, 1e-13, msh.np);
% phi aus x bestimmen (eingeprägte Potentiale wieder einfügen)
idx = isnan(pots);
phi = pots;
phi(idx) = x;
% Elektrische Gitterspannung und Gitterfluss berechnen
ebow = st'*phi;
dbow = Meps*ebow;
jbow = Mkap*ebow;


%% --- Kopplungsgröße Leistung --------------------------------------------

% elektrische Leistung in den dualen Volumen (Tonti)
pe = ebow.*jbow;
pv = 0.5*abs(st)*pe;
plotPotential(msh, pv, 1);

%% --- Thermisches Problem lösen ------------------------------------------

% Berechnung Systemmatrix: div(lambda*grad(theta)) = pv
A = st* Mlam*st';
% Modifikation Systemmatrix und Ladungsvektor mit modPots
[A, pv] = modPots(A, pv, temps);
% Gleichungssystem lösen mit gmres(20) oder bicgstab
[y, ~, ~, ~, ~] = gmres(A, pv, 20, 1e-13, msh.np);
% theta aus y bestimmen (eingeprägte temperaturen einfügen)
idx = isnan(temps);
theta = temps;
theta(idx) = y;

%% --- ergebnisse plotten -------------------------------------------------
% Lösungen plotten

plotPotential(msh, phi, 1);
title("eletrisches Potential Phi");

figure();
plotEdgeVoltage(msh, jbow, 1, bc);
title("stationäres Strömungsfeld J");

figure();
[X,Y] = meshgrid(msh.xmesh, msh.ymesh);
theta_surf = reshape(theta(1:msh.nx*msh.ny)+1, [msh.nx, msh.ny]);
surf(X,Y,theta_surf');
colormap('hot');
view(0,90);
title("Wärmeverteilung Theta");


