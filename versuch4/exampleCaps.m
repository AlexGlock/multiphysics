%   Skript zur numerischen Berechnung der Kondensatorkapazitäten aus
%   den Vorbereitungsaufgaben a)-d).
%   Außerdem werden Plots für das Potential und das elektrische Feld
%   der vier Kondensatorkonfigurationen erstellt. 

%% Erstellen des Gitters
xmesh = linspace(0,1,31);
ymesh = linspace(0,1,31);
zmesh = linspace(0,1,7);
msh = cartMesh(xmesh, ymesh, zmesh);
defaultvalue = 1;

% Randbedingung für alle Raumrichtungen definieren [xmin, xmax, ymin, ymax, zmin, zmax] 
% (0 = magnetisch, 1 = elektrisch)
bcs = [0, 0, 1, 1, 0, 0] ;


%% Erzeugen des Permittivitätsvektors für Kondensatorvariante a) bis e) mithilfe von boxMesher
% a) eine Box mit eps = 1
boxesA(1).box = [1, msh.nx, 1, msh.ny, 1, msh.nz];
boxesA(1).value = 1;
epsA = boxMesher(msh, boxesA, defaultvalue);

% b) 2 Boxen mit eps1 = 1 und eps2 = 2, Reihenschaltung
boxesB(1).box = [1, msh.nx, 1, floor(msh.ny/2), 1, msh.nz];
boxesB(1).value = 1;
boxesB(2).box = [1, msh.nx, ceil(msh.ny/2), msh.ny, 1, msh.nz];
boxesB(2).value = 2;
epsB = boxMesher(msh, boxesB, defaultvalue);

% c) 2 Boxen mit eps1 = 1, eps2 = 2, Parallelschaltung
boxesC(1).box = [1, floor(msh.nx/2), 1, msh.ny, 1, msh.nz];
boxesC(1).value = 1;
boxesC(2).box = [ceil(msh.nx/2), msh.nx, 1, msh.ny, 1, msh.nz];
boxesC(2).value = 2;
epsC = boxMesher(msh, boxesC, defaultvalue);

% d) vier Boxen mit eps = [1,2,3,4], Reihen und Parallelschaltung
% boxesD(1)...
% boxesD(2)...
% boxesD(3)...
% boxesD(4)...
% epsD = boxMesher(msh, boxesD, defaultvalue);

% e) eine Box mit eps = 1, metallischer Block wird später über vorgegebene Potentiale eingeprägt
% boxesE(1)...
% epsE =  


%% Erzeugen der vorgegebenen Potentiale, jedem primalen Volumen kann 
% bei kanonischer Indizierung ein primaler Punkt zugeordnet werden, 
% damit kann auch hier boxmesher verwendet werden

% Variante a) - d), Potentiale am Rand setzen, sonst NaN
boxesPotABCD(1).box = [1, msh.nx, 1, 1, 1, msh.nz];
boxesPotABCD(1).value = 0;
boxesPotABCD(2).box = [1, msh.nx, msh.ny, msh.ny, 1, msh.nz];
boxesPotABCD(2).value = 1;
potABCD = boxMesher(msh, boxesPotABCD, NaN);

% Variante e) Potentiale im metallischen Block und am Rand
% boxesPotE(1)...
% boxesPotE(2)...
% boxesPotE(3)...
% potE = boxMesher(msh, boxesPotE, NaN);


%% Berechnen der Feldverteilung mit solveES
% Initialisierung des Ladungsvektors q entsprechend Methode boxMesher 
q = zeros(msh.np, 1);

% a) eps = 1
[ phiA, ebowA, dbowA, relResA] = solveES( msh, epsA, potABCD, q);
% b) eps = 1, eps = 2, Reihenschaltung
[ phiB, ebowB, dbowB, relResB] = solveES( msh, epsB, potABCD, q);
% c) eps = 1, eps = 2, Parallelschaltung
[ phiC, ebowC, dbowC, relResC] = solveES( msh, epsC, potABCD, q);
% d) eps = [1,2,3,4], Reihen und Parallelschaltung
% [ phiD, ebowD, dbowD, relResD] = solveES( msh, epsD, potABCD, q);
% e) eps = 1 mit metallischem Block, Kondensator mit Sprung
% [ phiE, ebowE, dbowE, relResE] = solveES( msh, epsE, potE, q);


%% Kapazitätsberechnung der verschiedenen Kondensatoranordnungen
% a) e = 1
capA = calcCap(msh, ebowA, dbowA);
fprintf('capA = %e\n',capA);
% b) e = 1, e = 2, Reihenschaltung
capB = calcCap(msh, ebowB, dbowB);
fprintf('capB = %e\n',capB);
% c) e = 1, e = 2, Parallelschaltung
capC = calcCap(msh, ebowC, dbowC);
fprintf('capC = %e\n',capC);
% d) e = [1,2,3,4], Reihen und Parallelschaltung
capD = calcCap(msh, ebowD, dbowD);
fprintf('capD = %e\n',capD);
% e) e = 1 mit metallischem Block, Kondensator mit Sprung
capE = calcCap(msh, ebowE, dbowE);
fprintf('capE = %e\n',capE);

%% Plotten der elektrischen Felder und Potentialfelder
% sinnvolle Schnittebene
% indz = 

% Potential plotten
plotPotential(msh, phiE, indz);

%% E-Feld plotten (2D)
figure(2);
plotEdgeVoltage(msh, ebowE, indz, bcs);
xlabel('x');
ylabel('y');

%% E-Feld plotten (3D)
figure(3);
plotEdgeVoltage(msh, ebowE, 1:msh.nz, bcs);
xlabel('x')
ylabel('y');