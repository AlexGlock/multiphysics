%   Methode zur Berechnung der Kapazitaet eines Plattenkondensators
%
%   Eingabe
%   msh           kartesisches Gitter, wie es von cartMesh erzeugt wird.
%   ebow          Ein Vektor nach dem kanonischen Indizierungsprinzip,
%                 gefuellt mit den elektrischen Gitterspannungen.
%   dbow          Ein Vektor nach dem kanonischen Indizierungsprinzip,
%                 gefuellt mit den elektrischen Gitterfluessen
%
%   Rueckgabe
%   C             Die Kapazitaet des Kondensators


function C = calcCap( msh, ebow, dbow )
% Berechnen der elektrischen Spannung zwischen den Platten
% line gibt den Integrationspfad an, wobei hier entlang der y-Achse
% integriert wird, da die Platten in der XZ-Ebene liegen

% Eine Beschreibung der Argumente von intEdge ist in intEdge.m zu finden
% line.u =
% line.v =
% line.w =
% line.length =
% line.normal =
V = intEdge(msh, ebow, line);

% Elektrische Energie (Statik) [J]
% We =

% Kapazitaet
% C =

end
