% Aufgabe 10

% Erstellen eines kartesischen Gitters
xmesh = linspace(0,1,11);
ymesh = linspace(0,1,11);
zmesh = linspace(0,1,11);

msh = cartMesh(xmesh, ymesh, zmesh);

Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np = msh.np;

% Erstellen des Strom-Vektors (kanonischen Index berechnen und benutzen)
jbow = zeros(1,3*np);

for k = 1:1:max(size(zmesh))
    n = 1 + 4*Mx + 4*My + (k-1)*Mz + 2*np;
    jbow(n) = 1000;  
end

% Erstellen der Permeabilitätsmatrix mit boxMesher
defaultvalue = 4*pi*10^(-7);
boxesB(1).box = [1, msh.nx, 1, floor(msh.ny/2), 1, msh.nz];
boxesB(1).value = defaultvalue;
boxesB(2).box = [1, msh.nx, ceil(msh.ny/2), msh.ny, 1, msh.nz];
boxesB(2).value = 10 * defaultvalue;
mu = boxMesher(msh, boxesB, defaultvalue); 

% Lösen des Systems
[hbow, bbow, relRes] = solveMS(msh, mu, jbow);

figure(1); clf;
plotEdgeVoltage (msh, hbow, ceil(msh.nz/2), [0, 0, 0, 0, 0, 0]);
xlabel('x')
ylabel('y');