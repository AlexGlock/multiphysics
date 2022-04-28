% Aufgabe 2

% Methode zum Plotten des mit cartMesh erzeugten kartesischen Gitters.
%
% Eingabe
% msh           Struktur, wie sie mit cartMesh erzeugt werden kann.

function [  ] = plotMesh( msh )

% Zuweisen von nx, nz, nz, xmesh, ymesh und zmesh


% Zeichnen aller Kanten mithilfe einer Dreifachschleife
figure;
for i=1:nx
    for j=1:ny
        for k=1:nz
            % x-Kante zeichnen, falls keine Geisterkante vorliegt
            
            % y-Kante zeichnen, falls keine Geisterkante vorliegt
            
            % z-Kante zeichnen, falls keine Geisterkante vorliegt
        end
    end
end
xlabel('x');ylabel('y');zlabel('z');