% Aufgabe 1

% Methode zur Erstellung einer Struktur, in der die einzelnen Punkte des
% Gitters sortiert nach dem kanonischen Indizierungsschema in einem
% dreidimensionalen Vektor (x,y,z) abgelegt werden. Ausserdem wird die
% Anzahl der Punkte in x-,y-,z-Richtung und die Einzelkoordinaten der
% Punkte in jede Richtung gespeichert. Die Struktur basiert auf der
% Annahme, dass es sich um ein kartesisches Gitter handelt.
%
% Eingabe
% xmesh        Die x-Koordinaten der Punkte des Gitters (eindimensionaler 
%              Vektor) 
% ymesh        Die y-Koordinaten der Punkte des Gitters (eindimensionaler 
%              Vektor) 
% zmesh        Die z-Koordinaten der Punkte des Gitters (eindimensionaler 
%              Vektor) 
%
% Rueckgabe
% msh          Struktur bestehend aus:
%              nx = Anzahl der Punkte in x-Richtung
%              ny = Anzahl der Punkte in y-Richtung
%              nz = Anzahl der Punkte in z-Richtung
%              np = Anzahl der Punkte insgesamt
%              xmesh = wie xmesh aus der Eingabe
%              ymesh = wie ymesh aus der Eingabe
%              zmesh = wie zmesh aus der Eingabe
%              Mx = Inkrement in x-Richtung
%              My = Inkrement in y-Richtung
%              Mz = Inkrement in z-Richtung

function [ mesh ] = cartMesh( xmesh, ymesh, zmesh )


% Bestimmen von nx, ny, nz und np sowie Mx, My und Mz

    nx = max(size(xmesh));
    ny = max(size(ymesh));
    nz = max(size(zmesh));

    np = nx*ny*nz;


    Mx = xmesh(2:nx,:) - xmesh(1:nx-1,:);
    My = ymesh(2:ny,:) - ymesh(1:ny-1,:);
    Mz = zmesh(2:nz,:) - zmesh(1:nz-1,:);


% Zuweisen der Bestandteile zum struct msh

    mesh = struct;

    mesh.xmesh = xmesh;
    mesh.ymesh = ymesh;
    mesh.zmesh = zmesh;

    mesh.nx = nx;
    mesh.ny = ny;
    mesh.nz = nz;
    mesh.np = np;

    mesh.Mx = Mx;
    mesh.My = My;
    mesh.Mz = Mz;

    
end