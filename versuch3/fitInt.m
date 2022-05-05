% Methode zur Interpolation des diskreten elektrischen Feldes eBow auf die
% Punkte des kartesischen Gitters.
%
% Eingabe
% msh                Das kartesische Gitter als msh, erzeugt von cartMesh
% eBow               Das diskrete elektrische Feld auf den Kanten des
%                    Gitters, sortiert nach kanonischer Indizierung
% 
% Rückgabe
% meshP              Das reduzierte, kartesische Gitter mesh, bei dem 1. und letzter Punkt fehlen
% eField             Das elektrische Feld, interpoliert auf die Punkte des
%                    reduzierten primären Gitters

function [ meshP, eField ] = fitInt( msh, eBow )

% Spezifikationen des kartesischen Gitters
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np = msh.np;
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;

% Kantenlängen bestimmen
[DS, ~] = createDS(msh);

% Berechnen der Bogenwerte in X,Y,Z-Richtung
%eEdgeX = 
%eEdgeY = 
%eEdgeZ = 

%% Interpolation des E-Feldes
eX = zeros(np,1);
eY = zeros(np,1);
eZ = zeros(np,1);
for k = 1:nz
    for j = 1:ny
        for i = 1:nx
            % Berechnung des kanonischen Index
            n = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;
            
            %X-Richtung
            
            %Y-Richtung
            
            %Z-Richtung
        end
    end
end

eField = [eX, eY, eZ];

% meshP ist das reduzierte Gitter, das heißt ohne 1. und letzten Punkt
meshP = cartMesh(msh.xmesh(2:end-1), msh.ymesh(2:end-1), msh.zmesh(2:end-1));
