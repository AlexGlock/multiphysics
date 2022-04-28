% Aufgabe 7

% Methode zur Bestimmung der Geisterkanten  
%
% Eingabe
% msh           Struktur, die von cartMesh erzeugt wird
%
% Rueckgabe
% edg           Ein eindimensionaler Vektor, in dem fuer jede Geisterkante 
%               false (0) und jede "normale" Kante true (1) steht. Es 
%               wird das kanonische Indizierungsschema für die
%               Nummerierung der Kanten verwendet.

function [ edg ] = boundEdg( msh )


    % nx, ny, nz, np und Mx, My und Mz aus struct msh
    nx = msh.nx;
    ny = msh.ny;
    nz = msh.nz;
    np = msh.np;

    Mx = 1;
    My = nx;
    Mz = nx*ny;

    % Bitvektor der Groesse 3*np erzeugen
    edg = true(3*np,1);

    n =@(i,j,k) 1 + (i-1)*Mx + (j-1) * My + (k-1)*Mz;
    % Geisterkanten an der rechten YZ-Flaeche auf False setzen
    i = nx;
    for j=1:ny
        for k=1:nz
            edg(n(i,j,k),1) = 0;
        end
    end

    % Geisterkanten an der rechten XZ-Flaeche auf False setzen
    j = ny;
    for i=1:nx
        for k=1:nz
            edg(n(i,j,k)+np,1) = 0;
        end
    end

    % Geisterkanten an der rechten XY-Flaeche auf False setzen
    k = nz;
    for i=1:nx
        for j=1:ny
            edg(n(i,j,k)+2*np,1) = 0;
        end
    end

    
end