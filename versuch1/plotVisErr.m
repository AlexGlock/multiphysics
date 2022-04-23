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
r = 1;
h = 1;


% Vektor mit verschiedener Anzahl von Dreicken
nd=3:nmax;


% Berechnung von diskreter Oberfläche und Volumen 
oberflaechendiskret = zeros(1,nmax-2);
[~,imax] = size(nd);
for i= 1:imax
    
    n = nd(1,i);
    oberflaechendiskret(1,i) = n*(r^2 * sin(2*pi/n) + 2*h*r*sin(pi/n));
    
end


volumendiskret = zeros(1,nmax-2);
for i= 1:imax
    
    n = nd(1,i);
    volumendiskret(1,i) = n/2*h*r^2*sin(2*pi/n);
    
end

% Berechnung von analytischer Oberfläche und Volumen 
oberflaecheanalytisch = 2*pi*r^2 + 2*pi*r*h;
volumenanalytisch = pi*r^2*h;

% Berechnung von Oberflächen- und Volumenfehler
oberflaechenfehler = abs(ones(1,nmax-2) - oberflaechendiskret ./ oberflaecheanalytisch);
volumenfehler = abs(ones(1,nmax-2) - volumendiskret ./ volumenanalytisch);


% Plotten der beiden Fehler über nd
figure(1)
    loglog(nd,oberflaechenfehler,nd,volumenfehler)
    xlabel('Anzahl Dreiecke Deckelfläche')
    ylabel('relativer Fehler')
    legend({'Oberflächenfehler',...
            'Volumenfehler'},...
            'Location','Northeast')
    set(1,'papersize',[12,9])
    set(1,'paperposition',[0,0,12,9])
    print -dpdf plotVisErrloglog.pdf
    
    
% nd für Fehler kleiner als 10^(-5) finden
oberflaechenfehler_suche = 1;
volumenfehler_suche = 1;
n = 3;

while oberflaechenfehler_suche >= power(10,-5) || volumenfehler_suche >= power(10,-5)
    
    oberflaechediskret_suche = n*(r^2 * sin(2*pi/n) + 2*h*r*sin(pi/n));
    oberflaechenfehler_suche = abs(1-oberflaechediskret_suche/oberflaecheanalytisch);
    
    volumendiskret_suche = n/2*h*r^2*sin(2*pi/n);
    volumenfehler_suche = abs(1-volumendiskret_suche/volumenanalytisch);
    
    n = n+1;
    
end

disp(n-1)
