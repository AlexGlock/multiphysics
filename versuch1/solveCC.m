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

function [kx ,modes]=solveCC(cc, dx)

    % Bestimmen der Eigenwerte und -vektoren mit eig

    
    % Bestimmen der Wellenzahlen aus den Eigenwerten
    
    % Sortieren der Wellenzahlen. Sortierindex mit zurückgeben lassen !
    
    % Sortieren der Eigenvektoren mithilfe des Sortierindexes und damit
    % Bestimmung der Moden.
end