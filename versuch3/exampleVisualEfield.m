%% Aufgabe Visualisierung E-Feld 

% Erstellen des Meshs und benötigter Geometrie-Matrizen
xmesh = linspace(-3,3,16);
ymesh = linspace(-3,3,16);
zmesh = linspace(1,3,3);

msh = cartMesh(xmesh, ymesh, zmesh);

%% Erzeugen benötigter Geometriematrizen
[DS, DSt] = createDS(msh);
[DA] = createDA(DS);
[DAt] = createDA(DSt);

DSDiag = diag(DS);
DAtDiag = diag(DAt);

%% Spezifikation des kartesischen Gitters 
Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;

np = msh.np;
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;

%% Berechnung von dBow
Dfield = @(x,y,z)([x./sqrt(x^2+y^2)^3,y./sqrt(x^2+y^2)^3,z]);
% Bogenspannungsvektor initieren
dBow = zeros(3*np,1);
% Schleife ueber alle Punkte
for i=1:nx
    for j=1:ny
        for k=1:nz
            % kanonischen Index n bestimmen
            n = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;
            % deltas auf primärem Gitter
            deltaX=DSDiag(n);
            deltaY=DSDiag(n+np);
            deltaZ=DSDiag(n+2*np);
            
            % x-, y- und z-Koordinate des dualen Gitterpunkts bestimmen
            x = xmesh(i)+deltaX/2;
            y = ymesh(j)+deltaY/2;
            z = zmesh(k)+deltaZ/2;

            if (i == nx)||(i==1)||(j ==ny)||(j==1)||(k==nz)||(k==1) %Ist Randpunkt
                %Hier müsste wahrscheinlich noch eine Fallunterscheidung
                %für die unterschiedlichen Ränder rein 
                dBow(n)=0;
                dBow(n + np)=0;
                dBow(n + 2*np)=0;

            else
                
                % Bogenwert fuer x-Fläche mit Index n
                DValue = Dfield(x,y-deltaY/2,z-deltaZ/2);
                dBow(n) = DAtDiag(n+np)*DValue(1);

                % Bogenwert fuer y-Fläche mit Index n
                DValue = Dfield(x-deltaX/2,y,z-deltaZ/2);
                dBow(n + np) = DAtDiag(n+np)*DValue(2);
                
                % Bogenwert fuer z-Fläche mit Index n
                DValue = Dfield(x-deltaX/2,y-deltaY/2,z);
                dBow(n + 2*np) = DAtDiag(n+2*np)*DValue(3);
            end
        end
    end
end

%% Isotrope Permittivität
eps_r = ones(3*np,1);

bc = 1; % PEC
Deps = createDeps( msh, DA, DAt, eps_r, bc );
Meps = createMeps( DAt, Deps, DS );
MepsInv = nullInv( Meps );

eBow = MepsInv * dBow;

figure(1);
plotEBow(msh,eBow,2);
title('Isotropes E-Feld');
xlabel('x');
ylabel('y');
zlabel('Elektrisches Feld E in V/m');

figure(2);
plotEdgeVoltage(msh,eBow,2,[bc bc bc bc bc bc]);
title('Isotropes E-Feld');
xlabel('x in m');
ylabel('y in m');


% Folge-Aufgabe: Anisotrope Permittivität
eps_r(1:np) = 4*ones(np,1);

bc = 1; % PEC
Deps = createDeps( msh, DA, DAt, eps_r, bc );
Meps = createMeps( DAt, Deps, DS );
MepsInv = nullInv( Meps );

eBow = MepsInv * dBow;

figure(3);
plotEBow(msh,eBow,2);
title('Anisotropes E-Feld');
xlabel('x');
ylabel('y');
zlabel('Elektrisches Feld E in V/m');

figure(4);
plotEdgeVoltage(msh,eBow,2,[bc bc bc bc bc bc]);
title('Anisotropes E-Feld');
