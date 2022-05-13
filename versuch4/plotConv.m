%   Aufgabe 5
%
%   Erstellt einen Graphen, in dem das relative Residuum ueber der Anzahl
%   der Iterationen aufgetragen ist.

% Erstellen eines kartesischen Gitters
xmesh = linspace(0,1,11);
ymesh = linspace(0,1,11);
zmesh = linspace(0,1,11);
msh = cartMesh(xmesh, ymesh, zmesh);

% Gewaehlten Kondensator definieren (Materialien, Potentiale)
% ...

% Berechnen der Permittivitaet mit boxMesher
eps = boxMesher(   ,   ,   );


% Berechnen des Potentials mit boxMesher
pot = boxMesher(   ,   ,   );


% Erstellen des Ladungsvektors
q = zeros(msh.np,1);

% Loesen des Gleichungssystems mit dem ES-Solver
[phi, ebow, dbow, relRes] = solveES( msh, eps, pot, q);

% Plot
figure(1); clf;
semilogy(relRes, 'LineWidth', 2);
xlabel('Anzahl der Iterationen n');
ylabel('relatives Residuum');
