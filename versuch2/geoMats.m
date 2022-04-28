% Aufgabe 4

% Methode zur Berechnung der C, S und St (S-Schlange) Matrizen
%
% Eingabe
% msh        Die Datenstruktur, die mit cartMesh erzeugt werden kann
%
% Rueckgabe
% c           Die C-Matrix des primaeren Gitters
% s           Die S-Matrix des primaeren Gitters
% st          Die S-Matrix des dualen Gitters

function [ c, s, st ] = geoMats( msh )

% Bestimmen von Mx, My, Mz sowie np aus struct msh
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np = msh.np;

% Px Matrix erzeugen
Px = createP(Mx,np);
% Py-Matrix erzeugen
Py = createP(My,np);
% Pz-Matrix erzeugen
Pz = createP(Mz,np);
% Matrix derselben Groesse, gefuellt mit Nullen
Z = sparse(np,np);

% Aufbau der C, S und St Matrizen aus den P-Matrizen
c = [Z -Pz Py;
    Pz Z -Px;
    -Py Px Z];
s = [Px Py Pz];
st = [-Px' -Py' -Pz'];
end

function [P] = createP(M,n)
    P = -speye(n);
    P = spdiags(ones(n),M,P);
end