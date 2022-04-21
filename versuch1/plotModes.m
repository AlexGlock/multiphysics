%Skript zur Darstellung der ersten beiden Eigenmoden. Verwendet createCC 
%(Erstellung der Systemmatrix) und solveCC (Lösen des Eigenwertproblems).

% setzen der parameter n, ord, bc, L
n=100;
ord=4;
bc=1;
L=5;

% Erstellen der CC matrix
cc = createCC(n, ord, bc);

% Gitterschrittweite bestimmen
dx = L/(n-1);

% Lösen der Eigenwertgleichung mit solveCC
[kx, modes] = solveCC(cc, dx);

% Sonderbetrachtung für magnetische Randbedingungen
if bc==2
    % Lösche ersten Mode, denn er ist nur die statische Lösung (konstant)
    modes = modes(:,2:n);
end

% x-Koordinaten für jede Stützstelle in einen Vektor schreiben
x = linspace(0, L, n);

% Grundmode und 2.Mode plotten
figure(1)
hold all

m1 = modes(:,1);
m2 = modes(:,2);
plot(x,m1);
plot(x,m2);

hold off
legend({'erster Mode','zweiter Mode'},'Location','Southeast')
xlabel('x in m')
ylabel('Amplitude E-Feld (ohne Einheit)')
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
print -dpdf modes.pdf