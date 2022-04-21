%Methode zur Erstellung der 1D Curl-Curl-Matrix eines einfachen
%Eigenwertproblems einer eindimensionalen Wellengleichung (TE-Mode).
%
%   Eingabe
%   n       Stützstellenanzahl (n>=3 für ord=2, n>=5 für ord=4)
%   ord     Ordnung des Verfahrens (ord=2 zweite oder ord=4 vierte Ordnung)
%   bc      Randbedingungen (bc=0 keine, bc=1 elektrisch, bc=2 magnetisch)
%
%   Rückgabe
%   cc      1D Curl-Curl-Matrix

function [cc]=createCC(n, ord, bc)

    % Aufstellen der Matrix
    cc = sparse(n,n);
    
    % Einträge eintragen
    if ord==2
        % Bestimmen der Einträge für Ordnung 2 ohne Randbedingungen
        if bc==1
            % Änderung der Matrix bei elektrischem Rand
        elseif bc == 2
            % Änderung der Matrix bei magnetischem Rand
        elseif bc ~= 0
            error('bc kann nur die Werte 0 (elektrisch) oder 1 (magnetisch) annehmen.')
        end
	elseif ord==4
        % Bestimmen der cc Matrix für Ordnung 4 ohne Randbedingungen

        if bc==1
            % Änderung der Matrix bei elektrischem Rand
        elseif bc==2
            % Änderung der Matrix bei magnetischem Rand
        elseif bc~=0
            error('bc kann nur die Werte 0 (elektrisch) oder 1 (magnetisch) annehmen.')
        end

	else
		error('Ordnung %d ist noch nicht implementiert.', n)
    end

end
