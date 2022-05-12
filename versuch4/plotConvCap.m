%   Aufgabe 6
%
%   Erstellt einen Graphen, in dem die Kapazität der Kondensatorkon-
%   figuration e) über der Anzahl der Gitterpunkte np aufgetragen ist.

%   Sie können nahezu analog zu Aufgabe 5 vorgehen. Sie müssen die
%   Berechnung noch auf das Kovergenzverhalten hinsichtlich des Gitters
%   anpassen. Sie benötigen daher die Kapazität. Berechnen Sie diese
%   mit calcCap(msh, ebow, dbow).

% Parameter und Initialisierungen
N = 50;
stuetzstellen = 5:2:(N+5);
cap = zeros(N/2+1,1);
nrgridpoints = zeros(N/2+1,1);

for i = 1:length(stuetzstellen)

    n = stuetzstellen(i);

    % Erstellen des kartesischen Gitters mit cartMesh
    xmesh = linspace(0,1,n);
    ymesh = linspace(0,1,n);
    zmesh = linspace(0,1,5);
    msh = cartMesh(xmesh,ymesh,zmesh);

    % Berechnen der Permittivität mit boxMesher
    % defaultvalue =
    % ...

    % Erstellen des Potentialvektors mit den eingeprägten Potentialen (auch mit boxMesher)
    %
    %    Schematische Darstellung des Gitters
    %    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %             ^y
    %             |
    %         N_y +-------+-------+
    %             |\kappa |       |
    %             |\to    |       |  Ebene: z = z_i
    %             |\infty |       |         \forall i\in\{1, \dots, N_z\}
    % ceil(N_y/2) +-------+-------+
    %             |       |       |
    %             |       |       |
    %             |       |       |  x
    %           1 +-------+-------+-->
    %             1  ceil(N_x/2)  N_x
    %
    % ...

    % Berechnen der Feldverteilung
    q = zeros(msh.np, 1);
    [phi, ebow, dbow, relRes] = solveES( msh, eps, pot, q);

    % Berechnen und speichern der Kapazität
    cap(i) = calcCap(msh, ebow, dbow);

    % Anzahl der Gitterpunkte speichern
    % nrgridpoints(i) =
end

% Plot
figure(1); clf;
plot(nrgridpoints, cap, 'b.-', 'LineWidth', 2);
xlabel('Anzahl der Punkte np');
ylabel('Numerisch berechnete Kapazitaet des Kondensators / F');
