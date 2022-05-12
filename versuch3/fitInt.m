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
DSDiag = diag(DS);

% Berechnen der Bogenwerte in X,Y,Z-Richtung
eEdgeX =eBow(1:np)./DSDiag(1:np); 
eEdgeY =eBow(np+1:2*np)./DSDiag(np+1:2*np); 
eEdgeZ =eBow(2*np+1:3*np)./DSDiag(2*np+1:3*np); 

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
            if i==1 %Randebene links 
                eX(n)= eEdgeX(n);
            elseif i==nx %Randebene rechts
                eX(n) = eEdgeX(n-Mx);
            else
                eX(n)=(eEdgeX(n-Mx)*DSDiag(n)+eEdgeX(n)*DSDiag(n-Mx))/(DSDiag(n-Mx)+DSDiag(n));
            end
            
            %Y-Richtung
            if j==1 %Randebene unten 
                eY(n) = eEdgeY(n);
            elseif j==ny %Randebene oben
                eY(n)=eEdgeY(n-My);
            else
                eY(n)=(eEdgeY(n-My)*DSDiag(n+np)+eEdgeY(n)*DSDiag(n-My+np))/(DSDiag(n-My+np)+DSDiag(n+np));
            end
            
            %Z-Richtung
            if k==1 %Randebene vorne  
                eZ(n)= eEdgeZ(n);
            elseif k==nz %%Randebene hinten
                eZ(n) = eEdgeZ(n-Mz);
            else
                eZ(n)=(eEdgeZ(n-Mz)*DSDiag(n+2*np)+eEdgeZ(n)*DSDiag(n-Mz+2*np))/(DSDiag(n-Mz+2*np)+DSDiag(n+2*np));
            end
            
            %Punkteindex hochzählen
        end
    end
end

eField = [eX, eY, eZ];

% meshP ist das reduzierte Gitter, das heißt ohne 1. und letzten Punkt
meshP = cartMesh(msh.xmesh(2:end-1), msh.ymesh(2:end-1), msh.zmesh(2:end-1));
