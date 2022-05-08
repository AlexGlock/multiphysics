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
diagDS = diag(DS);

% Berechnen der Bogenwerte in X,Y,Z-Richtung
eEdgeX =eBow(1:np)./diagDS(1:np) 
eEdgeY =eBow(np+1:2*np)./diagDS(np+1:2*np); 
eEdgeZ =eBow(2*np+1:3*np)./diagDS(2*np+1:3*np); 

%% Interpolation des E-Feldes
eX = zeros(np,1);
eY = zeros(np,1);
eZ = zeros(np,1);

%% Verwendung von Meps wieso? eBow schon gegeben ...
%Meps = createMeps( DAt, Deps, DS );
%MepsInv = nullInv( Meps );

for k = 1:nz
    for j = 1:ny
        for i = 1:nx
            % Berechnung des kanonischen Index
            n = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;
            
            % problem RAND <-> Randbedingungen nicht gegeben Interpolation am Rand wie?
            % -> momentan ist Kantenwert = Punktwert wenn interpol nicht
            % möglich
            
            %X-Richtung
            if (i == nx)||(i==1) %Randebene rechts u. links 
                eX(n)= eEdgeX(n);
            else
                eX(n)=(eEdgeX(n-Mx)*diagDS(n)+eEdgeX(n)*diagDS(n-Mx))/(diagDS(n-Mx)+diagDS(n));
            end
            
            %Y-Richtung
            if (j ==ny)||(j==1) %Randebene oben und unten 
                eY(n) = eEdgeY(n);
            else
                eY(n)=(eEdgeY(n-My)*diagDS(n+np)+eEdgeY(n)*diagDS(n-My+np))/(diagDS(n-My+np)+diagDS(n+np));
            end
            
            %Z-Richtung
            if (k==nz)||(k==1) %%Randebene hinten und vorne  
                eZ(n)= eEdgeZ(n);
            else
                eZ(n)=(eEdgeZ(n-Mz)*diagDS(n+2*np)+eEdgeZ(n)*diagDS(n-Mz+2*np))/(diagDS(n-Mz+2*np)+diagDS(n+2*np));
            end
            
            %Punkteindex hochzählen
        end
    end
end

eField = [eX, eY, eZ];

% meshP ist das reduzierte Gitter, das heißt ohne 1. und letzten Punkt
meshP = cartMesh(msh.xmesh(2:end-1), msh.ymesh(2:end-1), msh.zmesh(2:end-1));
