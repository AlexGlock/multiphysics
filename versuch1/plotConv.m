%Skript für die Darstellung des Konvergenzverhaltens der Lösung der
%eindimensionalen Wellengleichung. Verwendet createCC (Erstellung der
%Systemmatrix) und solveCC (Lösen des Eigenwertproblems).
%
%   Eingabe
%   L           Abmessung/Länge des eindimensionalen Gebietes
%   nmax        Maximale Stützstelleanzahl
%   kxind       Betrachtete Mode (Grundmode=1)
%
%   Rückgabe
%   figure(1)   Plot Konvergenzverhalten kx, linear (wird abgespeichert in
%               plotConv.pdf)
%   figure(2)   Plot Konvergenzverhalten fehler, doppelt-logarithmisch (wird
%               abgespeichert in plotConvloglog.pdf)

% Setzen der Parameter
nmax = 100;
L = 1;
kxind = 1;
kxAna = pi/L;
nOrd2 = 3:nmax;
nOrd4 = 5:nmax;

% Konvergenzstudie für Ordnung 2 und keine Randbedingung
disp('Konvergenzstudie für Ordnung 2 und keine Randbedingung')
kxOrd2bc0 = zeros(length(nOrd2),1);
errOrd2bc0 = zeros(length(nOrd2),1);
for i=1:length(nOrd2)
  n = nOrd2(i);
  dx = L/(n-1);
  kx = solveCC(createCC(n, 2, 0), dx);
  kxOrd2bc0(i) = kx(kxind);
  errOrd2bc0(i) = abs(kxAna - kx(kxind))/kxAna;
end

% Konvergenzstudie für Ordnung 4 und keine Randbedingung
disp('Konvergenzstudie für Ordnung 4 und keine Randbedingung')
kxOrd4bc0 = zeros(length(nOrd4),1);
errOrd4bc0 = zeros(length(nOrd4),1);
for i=1:length(nOrd4)
  n = nOrd4(i);
  dx = L/(n-1);
  kx = solveCC(createCC(n, 4, 0), dx);
  kxOrd4bc0(i) = kx(kxind);
  errOrd4bc0(i) = abs(kxAna - kx(kxind))/kxAna;
end

% Konvergenzstudie für Ordnung 2 und elektrische Randbedingung
disp('Konvergenzstudie für Ordnung 2 und elektrische Randbedingung')
kxOrd2bc1 = zeros(length(nOrd2),1);
errOrd2bc1 = zeros(length(nOrd2),1);
for i=1:length(nOrd2)
  n = nOrd2(i);
  dx = L/(n-1);
  kx = solveCC(createCC(n, 2, 1), dx);
  kxOrd2bc1(i) = kx(kxind);
  errOrd2bc1(i) = abs(kxAna - kx(kxind))/kxAna;
end

% Konvergenzstudie für Ordnung 4 und elektrische Randbedingung
disp('Konvergenzstudie für Ordnung 4 und elektrische Randbedingung')
kxOrd4bc1 = zeros(length(nOrd4),1);
errOrd4bc1 = zeros(length(nOrd4),1);
for i=1:length(nOrd4)
  n = nOrd4(i);
  dx = L/(n-1);
  kx = solveCC(createCC(n, 4, 1), dx);
  kxOrd4bc1(i) = kx(kxind);
  errOrd4bc1(i) = abs(kxAna - kx(kxind))/kxAna;
end


% Formel für analytische Lösung
% kxAna = m*pi/L mit m=1

% Plot für die Wellenzahl über Stützstellenanzahl
figure(1)

hold all
yline(kxAna);
plot(nOrd2, kxOrd2bc0, nOrd4, kxOrd4bc0, nOrd2, kxOrd2bc1, nOrd4, kxOrd4bc1);
hold off

legend({'analytische Wellenzahl',...
        'zweite Ordnung ohne Randbed.','vierte Ordnung ohne Randbed.',...
        'zweite Ordnung mit Randbed.','vierte Ordnung mit Randbed.'
       },...
        'Location','Southeast')
xlabel('Stützstellenanzahl')
ylabel('Wellenzahl in 1/m')
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
print -dpdf plotConv.pdf

% Plot für den relativen Wellenzahlfehler über Gitterschrittweite (loglog)
figure(2)

loglog(L./(nOrd2-1), errOrd2bc0, L./(nOrd4-1), errOrd4bc0, L./(nOrd2-1), errOrd2bc1, L./(nOrd4-1), errOrd4bc1)

legend({'zweite Ordnung ohne Randbed.','vierte Ordnung ohne Randbed.',...
        'zweite Ordnung mit Randbed.','vierte Ordnung mit Randbed.'
       }, 'Location','Southeast')
xlabel('Gitterschrittweite')
ylabel('rel. Fehler der Wellenzahl')
set(2,'papersize',[12,9])
set(2,'paperposition',[0,0,12,9])
print -dpdf plotConvloglog.pdf