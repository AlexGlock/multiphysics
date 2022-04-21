%Skript zur Darstellung der Diskretisierungsfehler eines Zylinders.
%
%   Eingabe
%   nmax        Maximale Stützstellenanzahl
%
%   Rückgabe
%   figure(1)   Plot Fehler doppelt-logarithmisch (wird abgespeichert 
%               in plotVisErrloglog.pdf)

% Parameter setzen
nmax=1000;

% Vektor mit verschiedener Anzahl von Dreicken
nd=3:nmax;

% Berechnung von diskreter Oberfläche und Volumen 
% oberflaecheDiskrete =
% volumenDiskrete =

% Berechnung von analytischer Oberfläche und Volumen 
% oberflaecheAnalytisch =
% volumenAnalytisch =

% Berechnung von Oberflächen- und Volumenfehler
% oberflaechenFehler =
% volumenFehler =


% Plotten der beiden Fehler über nd
figure(1)
    loglog(nd,oberflaechenFehler,nd,volumenFehler)
    xlabel('Anzahl Dreiecke Deckelfläche')
    ylabel('relativer Fehler')
    legend({'Oberflächenfehler',...
            'Volumenfehler'},...
            'Location','Northeast')
    set(1,'papersize',[12,9])
    set(1,'paperposition',[0,0,12,9])
    print -dpdf plotVisErrloglog.pdf
    
    
% nd für Fehler kleiner als 10^(-5) finden