% Aufgabe 4
%
% Einfacher Solver fuer magnetoquasistatische Probleme im Frequenzbereich
%
%   Eingabe
%   msh         Kanonisches kartesisches Gitter
%   mui         Inverse Permeabilitaet entsprechend Methode createMmui
%   kap         Diskrete gemittelte Leitfähigkeit
%   jsbow       Stromgitterfluss (Erregung), als Funktion der Zeit
%   f           Frequenz der Anregung
%   bc          Randbedingungen (0=magnetisch, 1=elektrisch)
%
%   Rückgabe
%   abow        Integriertes magnetisches Vektorpotential
%   hbow        Magnetische Gitterspannung
%   bbow        Magnetische Gitterfluss
%   jbow        Stromgitterfluss
%   relRes      Relatives Residuum fuer jeden Iterationsschritt

function [abow, hbow, bbow, jbow, relRes] = solveMQSF(msh, mui, kap, jsbow, f, bc)

    % Anzahl der Rechenpunkte des Gitters
    np = msh.np;

    % Erzeugung topologische Matrizen
    [c, ~, ~] = createTopMats(msh);

    % Erzeugung geometrische Matrizen
    [ds, dst, da, dat] = createGeoMats(msh);

    % Erzeugung der Materialmatrix
    mmui = createMmui(msh, ds, dst, da, mui, bc);
    mkap = createMeps(msh, ds, da, dat, kap, bc);

    % Berechnung der Kreisfrequenz
    omega = 2*pi*f;

    % Berechnung Systemmatrix A und rechte Seite rhs
    A = c'*mmui*c + 1i*omega*mkap;
    rhs = jsbow;

    % Initialisieren der Lösung
    % abow =

    % Gleichungssystem loesen
    [abow, flag, relRes, iter, resVec] = gmres(A, rhs, 20, 1e-6, 1000);
    % Wenn gmres(20) nicht konvergieren würde, probieren Sie bitte bicgstab
    % [abow, flag, relRes, iter, resVec] = bicgstab(A, rhs, 1e-6, 1000);
    if flag == 0
      fprintf('gmres(20): converged at iteration %2d to a solution with relative residual %d.\n',iter,relRes);
    else
      error('gmres(20): some error ocurred, please check flag output.')
    end
    relRes = resVec./norm(rhs);

    % Magnetische Gitterspannung, magnetischen Fluss und Stromgitterfluss
    % berechnen
    bbow = c*abow;
    hbow = mmui*bbowM;
    jbow = -1i*omega*mkap*abow;
end