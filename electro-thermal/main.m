%% BEISPIEL von gekoppeltem J-Statik und thermischem Problem

clearvars;
% Quellparameter
src_potential = 3e-5;           % [V]

% Material in in Leiterstreifen (Kupfer)
cond_kappa = 58e6;              % [S/m] 
cond_lambda = 399/(8920*0.383); % [m^2/s] lambda/(dichte*spez.W.Kap)
cond_epsilon = 1.9*8.85e-12;    % [F/m]

% Leiter Durchmesser an der dünnsten Stelle (min 1)
diameter = 2; % integer cell count


%% --- MESH ---------------------------------------------------------------

% Randbedingungen
bc = [0,0,0,0,0,0];

xmesh = linspace(-1,1,45);
ymesh = linspace(-1,1,45);
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

plotPotential(msh, phi, 1);
title("eletrisches Potential \phi");

%% --- Kopplungsgröße Verlustleistung -------------------------------------

% elektrische Leistung in den dualen Volumen (Tonti)
p_el = ebow.*jbow; % diag(ebow)*Mkap*st'*phi;
p_vol = abs(st).*0.5*p_el;

plotPotential(msh, p_vol, 1);
title("Volumenverlustleistung P_{vol}");
colormap("jet")

%% --- Thermisches Problem lösen ------------------------------------------

% Berechnung Systemmatrix: div(lambda*grad(theta)) = pv
A = st*Mlam*st';
% Modifikation Systemmatrix und Ladungsvektor mit modPots
[A, p_vol] = modPots(A, p_vol, temps);
% Gleichungssystem lösen mit gmres(20) oder bicgstab
[y, ~, ~, ~, ~] = bicgstab(A, p_vol, 1e-13, msh.np);
% theta aus y bestimmen (eingeprägte temperaturen einfügen)
idx = isnan(temps);
theta = temps;
theta(idx) = y;

%% --- ergebnisse plotten -------------------------------------------------
% Lösungen plotten

figure();
plotEdgeVoltage(msh, jbow, 1, bc);
title("stationäres Strömungsfeld J");

figure();
[X,Y] = meshgrid(msh.xmesh, msh.ymesh);
theta_surf = reshape(theta(1:msh.nx*msh.ny)+1, [msh.nx, msh.ny]);
surf(X,Y,theta_surf');
colormap('hot');
view(0,90);
title("Wärmeverteilung \theta");


