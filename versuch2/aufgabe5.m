%% Beispielgitter definieren (3D)
%xmesh = [1 2 3]; % Np = 27 < 50
xmesh = 1:16; %Np = 4096 < 5000
ymesh = xmesh;
zmesh = ymesh;

% Erzeugen des Gitters
msh = cartMesh(xmesh, ymesh, zmesh);

% Erzeugen der Matrizen c, s, st und ct
[c, s, st] = geoMats(msh);
ct = c';

% Darstellen der Matrizen mit spy.
figure;
spy(c);
title('Visualisierung der C-Matrix des primaren Gitters.');
set(1,'papersize',[9,9])
set(1,'paperposition',[0,0,9,9])
print -dpdf curlMatrix.pdf

figure;
spy(s);
title('Visualisierung der S-Matrix des primaren Gitters.');
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
print -dpdf divMatrix.pdf

figure;
spy(st);
title('Visualisierung der S-Matrix des dualen Gitters.');

figure;
spy(ct);
title('Visualisierung der C-Matrix des dualen Gitters.');

% Speicherbedarf in Byte ermitteln
[x,y] = size(c);
storageC = x*y*8;
storageCsparse = length(find(c ~= 0))*8;
fprintf('Speicherplatz fuer volle Matrix C: %d Byte\n',storageC);
fprintf('Speicherplatz fuer Matrix C im sparse-Format: %d Byte\n',storageCsparse);
