%% Beispielgitter definieren (3D)

% Erzeugen des Gitters

% Erzeugen der Matrizen c, s, st und ct

% Darstellen der Matrizen mit spy.
figure;
spy(c);
title('Visualisierung der C-Matrix des primaren Gitters.');

figure;
spy(s);
title('Visualisierung der S-Matrix des primaren Gitters.');

figure;
spy(st);
title('Visualisierung der S-Matrix des dualen Gitters.');

figure;
spy(ct);
title('Visualisierung der C-Matrix des dualen Gitters.');

% Speicherbedarf in Byte ermitteln
