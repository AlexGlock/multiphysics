% Methode zur Berechnung der DA oder DAt Matrix. Die Berechnung beider Matrizen
% erfolgt analog. Daher koennen mit dieser Methode beide Matrizen berechnet
% werden. Falls DSt als Matrix uebergeben wird, entsteht DAt, falls DS als
% Matrix übergeben wird, entsteht DA.
%
% Eingabe
% DS               Matrix DS oder DSt, erzeugt von createDS
% 
% Rückgabe
% DA               Matrix DA oder DAt, je nach Eingabe.

function [ DA ] = createDA( DS )

% Anzahl der Punkte
np = max(size(DS))/3;

%% Berechnen der Flächen in xyz-Richtung
DSdiag = spdiags(DS);

DSx = DSdiag(1:np);
DSy = DSdiag(np+1:2*np);
DSz = DSdiag(2*np+1:3*np);

Ax = DSy .* DSz;
Ay = DSz .* DSx;
Az = DSx .* DSy;

% Zusammenfügen zur Gesamtmatrix DA bzw. DAt
DA = spdiags( [Ax; Ay; Az], 0, 3*np, 3*np);

end