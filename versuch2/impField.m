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
            
            % x-, y- und z-Koordinate des Gitterpunktes bestimmen
            x = xmesh(i);
            y = ymesh(j);
            z = zmesh(k);

            % Bogenwert fuer x-Kante mit Index n
            if (edg(n) == 1)
                xend = xmesh(i+1);
                xm = (x + xend)/2;
                xl = xend - x;
                
                fx = field(xm,y,z);
                fieldBow(n) = fx(1) * xl;
            end
            % Bogenwert fuer y-Kante mit Index n
            if (edg(n + np) == 1)
                yend = ymesh(j+1);
                ym = (y + yend)/2;
                yl = yend - y;
                
                fy = field(x,ym,z);
                fieldBow(n + np) = fy(2) * yl;
            end
            % Bogenwert fuer z-Kante mit Index n
            if (edg(n + 2*np) == 1)
                zend = zmesh(k+1);
                zm = (z + zend)/2;
                zl = zend - z;
                
                fz = field(x,y,zm);
                fieldBow(n + 2*np) = fz(3) * zl;
            end
        end
    end
end