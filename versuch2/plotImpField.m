% Aufgabe 10

% Skript, das die diskreten Felder a) und b) mithilfe eines Vektor-
% feldes visualisiert.
% Verwendet werden die Methoden aus den vorherigen Aufgabe.

%% Aufgabe 9
% Beispielgitter erzeugen (3D)
xmesh = 0:2:10;
ymesh = 0:2:10;
zmesh = 0:2:10;

%% msh struct berechnen
msh = cartMesh(xmesh, ymesh, zmesh);
xmin = xmesh(1);
xmax = xmesh(end);

%% anonymous function der beiden gegebenen Felder bestimmen
f1 = @(x,y,z) [5/2 -1.3 2];
f2 = @(x,y,z) [0 3*sin(pi*(x-xmin)/(xmax-xmin)) 0];

%% Bogengroesse der beiden Felder mithilfe von impField bestimmen
fbow1 = impField( msh, f1 );
fbow2 = impField( msh, f2 );

%% diskretes Feld fbow mithilfe von plotArrowfield plotten
figure;
plotEdgeVoltage(msh, fbow1);
figure;
plotEdgeVoltage(msh, fbow2);
set(1,'papersize',[9,9])
set(1,'paperposition',[0,0,9,9])
print -dpdf fbow2.pdf
