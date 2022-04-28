% Aufgabe 3

% Visualisierung eines Beispielgitters mit cartMesh und plotMesh

%% Beispielgitter definieren (3D)
xmesh = [1, 4, 7];
ymesh = [1, 3, 7, 8];
zmesh = [1, 2, 5, 6, 8];

% Erzeugen des Gitters
msh = cartMesh(xmesh, ymesh, zmesh);

%% Darstellen des Gitters
plotMesh(msh);
