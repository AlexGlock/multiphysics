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

% Bestimmung der Arrays für die X, Y, Z Koordinate, 
% jeweils 3 Zeilen (Punkt 1, 2, 3 des Dreiecks) 
% und nd Spalten (Anzahl der Dreiecke)
% und das für die vier Dreiecke Deckel, Boden, Mantel 1, Mantel 2
XDeckel = zeros(3, nd);
YDeckel = zeros(3, nd);
ZDeckel = zeros(3, nd);
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

    % Eintrag i in XBoden, YBoden, ZBoden

    % Eintrag i in XMantel1, YMantel1, ZMantel1 

    % Eintrag i in XMantel2, YMantel2, ZMantel2
    
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