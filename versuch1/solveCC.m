%Löst das Eigenwertproblem einer Matrix und gibt Wellenzahlen,
%berechnet aus Eigenwerten und Gitterschrittweite, und 
%Eigenvektoren geordnet aus. Bereinigt _nicht_ von unphysikalischen Moden.
%
%   Eingabe
%   cc          Curl-Curl-Matrix
%   dx          Gitterschrittwete
%
%   Rückgabe
%   kx          Wellenzahlen (aufsteigend)
%   modes       Eigenmoden (geordnet entsprechend kx)

function [kx, modes]=solveCC(cc, dx)

    % Bestimmen der Eigenwerte und -vektoren mit eig
    [V, D] = eig(cc);
    
    % Bestimmen der Wellenzahlen aus den Eigenwerten
    kx = arrayfun(@(v) sqrt(-v) / dx, diag(D));
    
    % Sortieren der Wellenzahlen. Sortierindex mit zurückgeben lassen !
    [kx, i] = sort(kx);
    
    % Sortieren der Eigenvektoren mithilfe des Sortierindexes und damit
    modes = V(:,i);
end