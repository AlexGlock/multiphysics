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
defaultvalue = 1;
boxesEps(1).box = [1, msh.nx, 1, msh.ny, 1, msh.nz];
boxesEps(1).value = 1;

boxesPot(1).box = [1, floor(msh.nx/2), ceil(msh.ny/2), msh.ny, 1, msh.nz];
boxesPot(1).value = 1;
boxesPot(2).box = [1, msh.nx, msh.ny, msh.ny, 1, msh.nz];
boxesPot(2).value = 1;
boxesPot(3).box = [1, msh.nx, 1, 1, 1, msh.nz];
boxesPot(3).value = 0;

% Berechnen der Permittivitaet mit boxMesher
eps = boxMesher(msh, boxesEps, defaultvalue);


% Berechnen des Potentials mit boxMesher
pot = boxMesher(msh, boxesPot, NaN);


% Erstellen des Ladungsvektors
q = zeros(msh.np,1);

% Loesen des Gleichungssystems mit dem ES-Solver
[phi, ebow, dbow, relRes] = solveES( msh, eps, pot, q);

% Plot
figure(1); clf;
semilogy(relRes, 'LineWidth', 2);
xlabel('Anzahl der Iterationen n');
ylabel('relatives Residuum');
