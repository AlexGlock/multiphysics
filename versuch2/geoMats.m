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
Px = spdiags(ones(np),Mx,-speye(np));
% Py-Matrix erzeugen
Py = spdiags(ones(np),My,-speye(np));
% Pz-Matrix erzeugen
Pz = spdiags(ones(np),Mz,-speye(np));
% Matrix derselben Groesse, gefuellt mit Nullen
Z = sparse(np,np);

% Aufbau der C, S und St Matrizen aus den P-Matrizen
c = [Z -Pz Py;
    Pz Z -Px;
    -Py Px Z];
s = [Px Py Pz];
st = [-Px' -Py' -Pz'];
end