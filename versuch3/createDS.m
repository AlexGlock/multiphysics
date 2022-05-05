% Methode zum Erstellen der Geometriematrizen DS und DSt
%
% Eingabe
% msh           Struktur, die von cartMesh erzeugt wird. Benutzen Sie
%               hierfür die bereitgestellte Methode.
%
% Rueckgabe
% DS            DS-Matrix
% DSt           DSt-Matrix

function [ DS, DSt ] = createDS( msh )

%% nx, ny, nz und np aus msh struct holen
nx = msh.nx;
ny = msh.ny;
nz = msh.nz;
np = msh.np;


%% Erstellen der Matrix DS
% Überlegen Sie sich, wie Sie die von Matlab bereitgestellte Methode diff
% geschickt verwenden können. Achten Sie auch auf die Geisterkanten

% Gitterabstände/Schrittweiten entlang der x-Achse
%dx = [   ,   ];

% Gitterabstände/Schrittweiten entlang der y-Achse
%dy = [   ,   ];

% Gitterabstände/Schrittweiten entlang der z-Achse
%dz = [   ,   ];

% Diagonalvektor erstellen (erst alle x-Kante, dann alle y-Kanten und dann alle z-Kanten)
% Ist aufgrund der schwierigen Implementation schon gegeben. 
% Versuchen sie sich aber klar zu machen, 
% was die 3 komplizierten reshape und repmat Konstrukte eigentlich tun.
DSdiag = [repmat(dx, 1, ny*nz), ...
		repmat(reshape(repmat(dy, nx, 1), 1, nx*ny), 1, nz),...
		reshape(repmat(dz, nx*ny, 1), 1, np)];

% aus dem Diagonalvektor für DS die matrix erstellen (Befehl spdiags verwenden)
%DS = 


%% Das Gleiche nochmal für die Matrix DSt

% Gitterabstände/Schrittweiten entlang der x-Achse
%dxt = 

% Gitterabstände/Schrittweiten entlang der y-Achse
%dyt = 

% Gitterabstände/Schrittweiten entlang der z-Achse
%dzt = 

% Diagonalvektor erstellen (erst alle x-Kante, dann alle y-Kanten und dann alle z-Kanten)
DStdiag = [repmat(dxt, 1, ny*nz), ...
		repmat(reshape(repmat(dyt, nx, 1), 1, nx*ny), 1, nz),...
		reshape(repmat(dzt, nx*ny, 1), 1, np)];

% aus dem Diagonalvektor für DS die matrix erstellen (Befehl spdiags verwenden)
%DSt = 

end