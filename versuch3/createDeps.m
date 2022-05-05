% Methode zur Erstellung der Materialmatrix Deps.
%
% Eingabe 
%	msh         kartesisches Gitter, erzeugt von cartMesh
% 	DA          Die DA Matrix, erzeugt von createDA (DS) 
% 	DAt         Die DAt Matrix, erzeugt von createDA (DSt) 
%	eps_r       Ein Vektor der Länge np, in dem die relativen
%               Epsilon-Werte für alle Elemente in kanonischer
%               Indizierung eingetragen sind.
%   bc          bc=0 für keine Randbedingungen
%				bc=1 für elektrische Randbedingungen
%
% Rückgabe 
%	Deps        Die Matrix Deps der gemittelten Permittivitäten


function [ Deps ] = createDeps( msh, DA, DAt, eps_r, bc )

if size(eps_r,1) == msh.np
    eps_r = [eps_r;eps_r;eps_r];
end

% für diese Funktion brauchen wir die folgenden Größen des Meshes
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;
np = msh.np;
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;

% Berechnen der Permittivität aus der relativen Permittivität
eps0 = 8.854187817*10^-12;
%eps = 

% Nur die Diagonale der DA und DAt Matrix ist besetzt, also brauchen wir nur die Diagonale
At = diag(DAt);
A  = diag(DA);

% Berechnen der Flächen für die Flächen in x-, y- und z-Richtung
%Atx = 
%Aty = 
%Atz = 

%Ax = 
%Ay = 
%Az = 

% Erstellen der Vektoren für die gemittelten epsilon Werte für x-, y- und z-Flächen
meanEpsX = zeros(np, 1);
meanEpsY = zeros(np, 1);
meanEpsZ = zeros(np, 1);

% Gehe durch alle Punkte und setze die gemittelten epsilon Werte für x-, y- und z-Flächen
% Beachten Sie, dass manche Indizes in der Formel im Skript kleiner als 1 werden können und
% damit speziell behandelt werden müssen (if anweisung)
for i = 1:nx
    for j = 1:ny
        for k = 1:nz
   

        end
    end
end
    
    
    meanEpsX(n) = 
    meanEpsY(n) = 
    meanEpsZ(n) = 
end

%% Randbedingungen

% Spezialfall nur bei PEC Rand (bc=1)
if bc==1
    for i=1:nx
        for j=1:ny
            for k=1:nz


            end
        end
    end
end
    
% Matrix Deps mithilfe des Diagonalenvektors (spdiags) erzeugen
Deps = spdiags([meanEpsX; meanEpsY; meanEpsZ], 0, 3*np, 3*np);
    
end