% Aufgabe 2

% Methode zum Plotten des mit cartMesh erzeugten kartesischen Gitters.
%
% Eingabe
% msh           Struktur, wie sie mit cartMesh erzeugt werden kann.

function [  ] = plotMesh(mesh)

% Zuweisen von nx, nz, nz, xmesh, ymesh und zmesh
nx = mesh.nx;
ny = mesh.ny;
nz = mesh.nz;

xmesh = mesh.xmesh;
ymesh = mesh.ymesh;
zmesh = mesh.zmesh;

% x-Linie
x_x_line_0 = [xmesh(1,1:nx-1)',xmesh(1,2:nx)'];
y_x_line_0 = ones(nx-1,2);
z_x_line_0 = ones(nx-1,2);

% y-Linie
x_y_line_0 = ones(ny-1,2);
y_y_line_0 = [ymesh(1,1:ny-1)',ymesh(1,2:ny)'];
z_y_line_0 = ones(ny-1,2);

% z-Linie
x_z_line_0 = ones(nz-1,2);
y_z_line_0 = ones(nz-1,2);
z_z_line_0 = [zmesh(1,1:nz-1)',zmesh(1,2:nz)'];


x_koordinaten = xmesh;
y_koordinaten = ymesh;
z_koordinaten = zmesh;


% Zeichnen aller Kanten mithilfe einer Dreifachschleife
figure;
for i=1:nx
    x = x_koordinaten(1,i);
    for j=1:ny
        y = y_koordinaten(1,j);
        for k=1:nz
            z = z_koordinaten(1,k);
            
            % x-Kante zeichnen, falls keine Geisterkante vorliegt
            plot3(x_x_line_0,y*y_x_line_0,z*z_x_line_0);
            hold on;
            
            % y-Kante zeichnen, falls keine Geisterkante vorliegt
            plot3(x*x_y_line_0,y_y_line_0,z*z_y_line_0);
            hold on;
            
            % z-Kante zeichnen, falls keine Geisterkante vorliegt
            plot3(x*x_z_line_0,y*y_z_line_0,z_z_line_0);
            hold on;
            
        end
    end
end
xlabel('x');ylabel('y');zlabel('z');