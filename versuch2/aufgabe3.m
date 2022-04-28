% Aufgabe 3

% Visualisierung eines Beispielgitters mit cartMesh und plotMesh

%% Beispielgitter definieren (3D)

xmesh = [1,2,3,6];
ymesh = [1,2,4,5];
zmesh = [1,2,3,4];

% Erzeugen des Gitters

[mesh] = cartMesh(xmesh, ymesh, zmesh);

%% Darstellen des Gitters

plotMesh(mesh);
