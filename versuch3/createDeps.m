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
eps = eps_r * eps0; 

% Nur die Diagonale der DA und DAt Matrix ist besetzt, also brauchen wir nur die Diagonale
At = diag(DAt);
A  = diag(DA);

% Berechnen der Flächen für die Flächen in x-, y- und z-Richtung
Atx = At(1:np);
Aty = At(np:2*np);
Atz = At(2*np:3*np);

Ax = A(1:np);
Ay = A(np:2*np);
Az = A(2*np:3*np);

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
            n = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;

            % eps_x
            v1x = eps(n) * Ax(n);
            v2x = 0;
            v3x = 0;
            v4x = 0;

            n2x = n - Mz;
            if n2x > 0
                v2x = eps(n2x) * Ax(n2x);
            end

            n3x = n - My;
            if n3x > 0
                v3x = eps(n3x) * Ax(n3x);
            end

            n4x = n - My - Mz;
            if n4x > 0
                v4x = eps(n4x) * Ax(n4x);
            end

            % eps_y
            v1y = eps(n) * Ay(n);
            v2y = 0;
            v3y = 0;
            v4y = 0;

            n2y = n - Mz;
            if n2y > 0
                v2y = eps(n2y) * Ay(n2y);
            end

            n3y = n - Mx;
            if n3y > 0
                v3y = eps(n3y) * Ay(n3y);
            end

            n4y = n - Mx - Mz;
            if n4y > 0
                v4y = eps(n4y) * Ay(n4y);
            end

            % eps_z
            v1z = eps(n) * Az(n);
            v2z = 0;
            v3z = 0;
            v4z = 0;

            n2z = n - My;
            if n2z > 0
                v2z = eps(n2z) * Az(n2z);
            end

            n3z = n - Mx;
            if n3z > 0
                v3z = eps(n3z) * Az(n3z);
            end

            n4z = n - Mx - My;
            if n4z > 0
                v4z = eps(n4z) * Az(n4z);
            end
            
            meanEpsX(n) = (v1x + v2x + v3x + v4x) / (4*Atx(n));
            meanEpsY(n) = (v1y + v2y + v3y + v4y) / (4*Aty(n));
            meanEpsZ(n) = (v1z + v2z + v3z + v4z) / (4*Atz(n));

        end
    end
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