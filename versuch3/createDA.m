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
% np =

%% Berechnen der Flächen in xyz-Richtung
%DSdiag =

%DSx = 
%DSy = 
%DSz = 

%Ax = 
%Ay = 
%Az = 

% Zusammenfügen zur Gesamtmatrix DA bzw. DAt
DA = spdiags( [Ax; Ay; Az], 0, 3*np, 3*np);

end