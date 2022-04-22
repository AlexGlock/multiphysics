%Skript für die Visualisierung eines diskretisierten Zylinders.
%
%   Eingabe
%   nd          Anzahl Dreiecksflächen je Deckel
%   h           Höhe des Zylinders
%   r           Radius des Zylinders
%
%   Rückgabe
%   figure(1)   Plot Zylinder (wird abgespeichert in cyl.pdf)

% Parameter setzen
nd=20;
h=1;
r=1;

% Berechnung von delta phi
delphi = 2*pi/nd;

% Bestimmung der Arrays für die X, Y, Z Koordinate, 
% jeweils 3 Zeilen (Punkt 1, 2, 3 des Dreiecks) 
% und nd Spalten (Anzahl der Dreiecke)
% und das für die vier Dreiecke Deckel, Boden, Mantel 1, Mantel 2

XDeckel = zeros(3, nd);
YDeckel = zeros(3, nd);
ZDeckel = ones(3, nd);


XBoden = zeros(3, nd);
YBoden = zeros(3, nd);
ZBoden = zeros(3, nd);


XMantel1 = zeros(3, nd);
YMantel1 = zeros(3, nd);
ZMantel1 = zeros(3, nd);


XMantel2 = zeros(3, nd);
YMantel2 = zeros(3, nd);
ZMantel2 = zeros(3, nd);


for i=1:nd
    % Eintrag i in XDeckel, YDeckel, ZDeckel
    XDeckel(1,i) = 0;
    XDeckel(2,i) = cos(delphi*(i-1));
    XDeckel(3,i) = cos(delphi*i);
    
    YDeckel(1,i) = 0;
    YDeckel(2,i) = sin(delphi*(i-1));
    YDeckel(3,i) = sin(delphi*i);
    
    ZDeckel = ones(3, nd);

    
    % Eintrag i in XBoden, YBoden, ZBoden
    
    XBoden(1,i) = 0;
    XBoden(2,i) = cos(delphi*(i-1));
    XBoden(3,i) = cos(delphi*i);
    
    YBoden(1,i) = 0;
    YBoden(2,i) = sin(delphi*(i-1));
    YBoden(3,i) = sin(delphi*i);
    
    ZBoden = zeros(3, nd);

    
    % Eintrag i in XMantel1, YMantel1, ZMantel1 
    
    XMantel1(1,i) = cos(delphi*(i-1));
    XMantel1(2,i) = cos(delphi*(i-1));
    XMantel1(3,i) = cos(delphi*i);
    
    YMantel1(1,i) = sin(delphi*(i-1));
    YMantel1(2,i) = sin(delphi*(i-1));
    YMantel1(3,i) = sin(delphi*i);
    
    ZMantel1(1,i) = 0;
    ZMantel1(2,i) = 1;
    ZMantel1(3,i) = 0;

    
    % Eintrag i in XMantel2, YMantel2, ZMantel2
    
    XMantel2(1,i) = cos(delphi*(i-1));
    XMantel2(2,i) = cos(delphi*i);
    XMantel2(3,i) = cos(delphi*i);
    
    YMantel2(1,i) = sin(delphi*(i-1));
    YMantel2(2,i) = sin(delphi*i);
    YMantel2(3,i) = sin(delphi*i);

    ZMantel2(1,i) = 1;
    ZMantel2(2,i) = 1;
    ZMantel2(3,i) = 0;
    
end

% Plotten und Speichern der Dreiecke mithilfe von Patch
figure(1)

patch(XBoden,YBoden,ZBoden,zeros(3,nd))
patch(XDeckel,YDeckel,ZDeckel,zeros(3,nd))
patch(XMantel1,YMantel1,ZMantel1,zeros(3,nd))
patch(XMantel2,YMantel2,ZMantel2,zeros(3,nd))

view([1,-1,0.5])    
xlabel('x')
ylabel('y')
zlabel('z')
set(1,'papersize',[12,9])
set(1,'paperposition',[0,0,12,9])
set(gca,'DataAspectRatio',[1 1 1])
print -dpdf cyl.pdf