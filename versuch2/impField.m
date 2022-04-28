% Aufgabe 9

% Methode zur Bestimmung der elektrischen Gitterspannungen 
% aus einem kontinuierlichen E-Feld 
%
% Eingabe
% msh             Struktur, wie sie mit cartMesh erzeugt werden kann
% field           Das konitnuierliche elektrische Feld als anonyme 
%                 Funktion. Die Funktion muss von der Form 
%                 @(r) fx(r)*([1,0,0])+fy(r)*([0,1,0])+fz(r)*([0,0,1])
%                 sein, wobei r ein dreidimensionaler Vektor ist.
%
% Rueckgabe
% fieldBow        Vektor mit den Gitterspannungen, sortiert nach dem 
%                 kanonischen Indizierungsschema fuer Kanten

function [ fieldBow ] = impField( msh, field )

% Gittereigenschaften aus struct holen
np = msh.np;
nx = msh.nx; ny = msh.ny; nz = msh.nz;
Mx = msh.Mx; My = msh.My; Mz = msh.Mz;
xmesh = msh.xmesh; ymesh = msh.ymesh; zmesh = msh.zmesh;

% Geisterkantenindizes
edg = boundEdg(msh);

% Bogenspannungsvektor initieren
fieldBow = zeros(3*np,1);

% Schleife ueber alle Punkte
for i=1:nx
    for j=1:ny
        for k=1:nz
            % kanonischen Index n bestimmen
            n = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;
            
            % Abbrechen, falls Kante eine Geisterkante ist
            if (edg(n) == 0)
                continue
            end
            
            % x-, y- und z-Koordinate des Gitterpunktes bestimmen
            x = xmesh(i);
            y = ymesh(j);
            z = zmesh(k);
            % Kantenmittelpunkte bestimmen
            xm = (x + xmesh(i+1))/2;
            ym = (y + ymesh(j+1))/2;
            zm = (z + zmesh(k+1))/2;
            % Kantenlaengen bestimmen
            xl = xmesh(i+1) - x;
            yl = ymesh(i+1) - y;
            zl = zmesh(i+1) - z;

            % Bogenwert fuer x-Kante mit Index n
            fx = field(xm,y,z);
            fieldBow(n) = fx(1) * xl;
            % Bogenwert fuer y-Kante mit Index n
            fy = field(x,ym,z);
            fieldBow(n + np) = fy(2) * yl;
            % Bogenwert fuer z-Kante mit Index n
            fz = field(x,y,zm);
            fieldBow(n + 2*np) = fz(3) * zl;
        end
    end
end