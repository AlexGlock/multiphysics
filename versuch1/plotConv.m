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
nOrd2 = 3:nmax;
nOrd4 = 5:nmax;


% Konvergenzstudie für Ordnung 2 und keine Randbedingung
disp('Konvergenzstudie für Ordnung 2 und keine Randbedingung')
kxOrd2bc0 = zeros(length(nOrd2),1);
for i=1:length(nOrd2)
  n = nOrd2(i);

end;

% Konvergenzstudie für Ordnung 4 und keine Randbedingung
disp('Konvergenzstudie für Ordnung 4 und keine Randbedingung')
kxOrd4bc0 = zeros(length(nOrd4),1);
for i=1:length(nOrd4)
  n = nOrd4(i);

end;

% Konvergenzstudie für Ordnung 2 und elektrische Randbedingung
disp('Konvergenzstudie für Ordnung 2 und elektrische Randbedingung')
kxOrd2bc1 = zeros(length(nOrd2),1);
for i=1:length(nOrd2)
  n = nOrd2(i);

end;

% Konvergenzstudie für Ordnung 4 und elektrische Randbedingung
disp('Konvergenzstudie für Ordnung 4 und elektrische Randbedingung')
kxOrd4bc1 = zeros(length(nOrd4),1);
for i=1:length(nOrd4)
  n = nOrd4(i);

end;


% Formel für analytische Lösung
% kxAna = 

% Plot für die Wellenzahl über Stützstellenanzahl
figure(1)

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

legend({'zweite Ordnung ohne Randbed.','vierte Ordnung ohne Randbed.',...
        'zweite Ordnung mit Randbed.','vierte Ordnung mit Randbed.'
       }, 'Location','Southeast')
xlabel('Gitterschrittweite')
ylabel('rel. Fehler der Wellenzahl')
set(2,'papersize',[12,9])
set(2,'paperposition',[0,0,12,9])
print -dpdf plotConvloglog.pdf