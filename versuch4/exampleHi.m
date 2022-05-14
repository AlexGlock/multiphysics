% Aufgabe 7

% Erstellen eines kartesischen Gitters
xmesh = linspace(0,1,11);
ymesh = linspace(0,1,11);
zmesh = linspace(0,1,11);

msh = cartMesh(xmesh, ymesh, zmesh);

Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
nz = msh.nz;
np = msh.np;

% Erstellen des Strom-Vektors (kanonischen Index berechnen und benutzen)
jbow = zeros(1,3*np);

for k = 1:1:nz
    n = 1 + 4*Mx + 4*My + (k-1)*Mz + 2*np;
    jbow(n) = 1000;  
end

% Berechnen des Hilfsfeldes
hiBow = calcHi(msh,jbow);

% Plotten des Hilfsfeldes
figure(1); clf;
plotEdgeVoltage (msh, hiBow, ceil(msh.nz/2), [0, 0, 0, 0, 0, 0]);
xlabel('x')
ylabel('y');