%% Beispielgitter definieren (3D)
xmesh = [1, 3, 5, 7, 9];
ymesh = xmesh;
zmesh = ymesh;

% Erzeugen des Gitters
msh = cartMesh(xmesh, ymesh, zmesh);

% Erzeugen der Matrizen c, s, st und ct
[c, s, st] = geoMats(msh);
ct = c';
g = -st';

% rotgrad = divrot = 0 berechnen
disp(c*g)
disp(s*c)
disp(st*ct)