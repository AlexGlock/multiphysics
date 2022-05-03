% Aufgabe 8

% Skript zur Darstellung der relativen Anzahl der Fehlerkanten als
% doppel-logarithmischer Graph
nxyMax = 10;
relOccurence = zeros(1,nxyMax);
for nxy=1:nxyMax
    
    
    % Gittererzeugung: kartesisches Gitter mit nxy Punkten in x- und y-
    xmesh = 1:1:nxy;
    ymesh = 1:1:nxy;
    zmesh = 1;
    [ msh ] = cartMesh( xmesh, ymesh, zmesh );
    
    % Richtung. Es handelt sich um ein ebenes Gitter (x-y-Ebene) mit z = 1
    
    % Geisterkanten finden
    [ edg ] = boundEdg( msh );
    
    % Geisterkanten zaehlen
    anzahl_geisterkanten = 3*msh.np - edg'*edg;
    
    % Berechnen der relativen Anzahl für dieses nxy
    anzahl_geisterkanten_relativ = anzahl_geisterkanten / (3*msh.np);
    relOccurence(1,nxy) = anzahl_geisterkanten_relativ;
    
end

% Darstellen der relativen Anzahl als doppel-logarithmischer Graph
figure;
plot(1:nxyMax,relOccurence, 'LineWidth', 2);
legend('Mit boundEdg ermittelter, relativer Anteil an Geisterkanten');
xlabel('N_{xy}');
ylabel('Rel. Anteil');
title(['Relative Anzahl der Geisterkanten bei N_x bzw. N_y von 1 bis ',...
       num2str(nxyMax)]);
ylim([min(relOccurence),max(relOccurence)])

