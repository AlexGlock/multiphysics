% Aufgabe 10

% Skript, das die diskreten Felder a) und b) mithilfe eines Vektor-
% feldes visualisiert.
% Verwendet werden die Methoden aus den vorherigen Aufgabe.

%% Aufgabe 9
% Beispielgitter erzeugen (3D)

%% msh struct berechnen
msh = cartMesh(xmesh, ymesh, zmesh);

%% anonymous function der beiden gegebenen Felder bestimmen
% f1 = 
% f2 = 

%% Bogengröße der beiden Felder mithilfe von impField bestimmen
fbow1 = impField( msh, f1 );
fbow2 = impField( msh, f2 );

%% diskretes Feld fbow mithilfe von plotArrowfield plotten
figure;
plotEdgeVoltage(msh, fbow1);
figure;
plotEdgeVoltage(msh, fbow2);
