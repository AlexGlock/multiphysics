% Aufgabe 9

% Erstellen eines kartesischen Gitters
xmesh = linspace(0,1,11);
ymesh = linspace(0,1,11);
zmesh = linspace(0,1,11);

msh = cartMesh(xmesh, ymesh, zmesh);

Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np = msh.np;

% Erstellen des Strom-Vektors
% jbow = 
% ...

% Erstellen des Permeabilitätsvektors
% mu = 

% Lösen des Systems
[hbow, bbow, relRes] = solveMS(msh, mu, jbow);

figure(1); clf;
plotEdgeVoltage (msh, hbow, ceil(msh.nz/2), [0, 0, 0, 0, 0, 0]);
xlabel('x')
ylabel('y');
