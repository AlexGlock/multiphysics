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
    cc = zeros(n,n+ord);


    % Einträge eintragen
    if ord==2

        % Bestimmen der Einträge für Ordnung 2 ohne Randbedingungen
        diff = [1,-2,1];
        i = 1;
        while i <= n
            cc(i,i:i+ord) = diff(1,:);
            i = i+1;
        end  

        if bc==1
            % Änderung der Matrix bei elektrischem Rand
            cc(:,3) = cc(:,3) - cc(:,1);
            cc(:,n) = cc(:,n) - cc(:,n+2);
            cc = cc(:,2:n+1);

        elseif bc == 2
            % Änderung der Matrix bei magnetischem Rand
            cc(:,3) = cc(:,3) + cc(:,1);
            cc(:,n) = cc(:,n) + cc(:,n+2);
            cc = cc(:,2:n+1);

        elseif bc==0
            cc = cc(:,2:n+1);

        elseif bc ~= 0
            error('bc kann nur die Werte 0 (elektrisch) oder 1 (magnetisch) annehmen.')
        end


    elseif ord==4

        % Bestimmen der cc Matrix für Ordnung 4 ohne Randbedingungen
        diff = [-1,16,-30,16,-1];
        i = 1;
        while i <= n
            cc(i,i:i+ord) = diff(1,:);
            i = i+1;
        end 

        if bc==1
            % Änderung der Matrix bei elektrischem Rand
            cc(:,5) = cc(:,5) - cc(:,1);
            cc(:,4) = cc(:,4) - cc(:,2);
            cc(:,n) = cc(:,n) - cc(:,n+4);
            cc(:,n+1) = cc(:,n+1) - cc(:,n+3);
            cc = cc(:,3:n+2);

        elseif bc==2
            % Änderung der Matrix bei magnetischem Rand
            cc(:,5) = cc(:,5) + cc(:,1);
            cc(:,4) = cc(:,4) + cc(:,2);
            cc(:,n) = cc(:,n) + cc(:,n+4);
            cc(:,n+1) = cc(:,n+1) + cc(:,n+3);
            cc = cc(:,3:n+2);
        
        elseif bc==0
            cc = cc(:,3:n+2);

        elseif bc~=0
            error('bc kann nur die Werte 0 (elektrisch) oder 1 (magnetisch) annehmen.')
        end

    else
        error('Ordnung %d ist noch nicht implementiert.', n)
    end

end
