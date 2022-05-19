% Aufgabe 1,3,4,7,8,9

%% Aufgabe 1
% -------------------------------------------------------------------------
% ------------ Problem modellieren ----------------------------------------
% -------------------------------------------------------------------------
% Konsolenausgabe
disp('Gitter erstellen')
% Erstellen des Gitters mit cartMesh
% xmesh = 
% ymesh = 
% zmesh = 
% msh = cartMesh(xmesh, ymesh, zmesh);

% np = msh.np;
% Mx = msh.Mx;
% My = msh.My;
% Mz = msh.Mz;

% Randbedingung für alle Raumrichtungen definieren [xmin, xmax, ymin, ymax, zmin, zmax] (0 = magnetisch, 1 = elektrisch)
% bc = [ , , , , , ] 

% Erstellen von jsbow
jsbow = zeros(3*np,1);
% jsbow(...) = ...;
% jsbow(...) = ...;
% ...

% Erstellen der Materialverteilung mui und kappa mithilfe von boxmesher
disp('Materialmatrizen erstellen')
% boxeskappa(1).box = [ ,  ,  ,  ,  , ];
% boxeskappa(1).value = 
% kappa = boxMesher(msh, boxeskappa, ...);

% boxesmu(1).box = [ ,  ,  ,  ,  , ];
% boxesmu(1).value = 
% mu = boxMesher(msh, boxesmu, ...);

% Inverse Permeabilität berechnen (siehe Hinweis Aufgabe 1)
% mui = ....


%% Aufgabe 3
% -------------------------------------------------------------------------
% ----------- Lösen des magnetostatischen Problems ------------------------
% -------------------------------------------------------------------------
solve_statik = true;
if solve_statik
	disp('Loesung des statischen Problems')
    
	% Solver benutzen, um A-Feld zu bestimmen
	[abow_ms, hbow_ms, bbow_ms, relRes] = solveMSVec(msh, mui, jsbow);
	
	% Grafisches Darstellen des magnetischen Vektorpotentials, am besten 
    % unter der Verwendung verschiedener Ebenen
	figure(1)
	plotEdgeVoltage(msh, abow_ms, 3,  bc)
	title('Statische Loesung des Vektorpotentials')

    % Grafisches Darstellen der z-Komponente des B-Feldes
	% ...
end

% Verschiebt diese Zeile zur nächsten Aufgabe, wenn Aufgabe 3 abgeschlossen ist
return


%% Aufgabe 5
% -------------------------------------------------------------------------
% ----------- Magnetoquasistatisches Problem im Frequenzbereich -----------
% -------------------------------------------------------------------------
disp('Lösung des quasistatischen Problems im Frequenzbereich')

% Frequenz festlegen
% f = 
% omega =

% Löser ausführen
[abow_mqs_f, hbow_mqs_f, bbow_mqs_f, jbow_mqs_f, relRes] = solveMQSF(msh, mui,...
                                                         kappa, jsbow, f, bc);

% Grafisches Darstellen der Stromdichte auf der Oberfläche der leitfähigen
% Platte (Real- und Imaginärteil)
figure(3)
plotEdgeVoltage(msh,real(jbow_mqs_f),2,bc)
title(['Realteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Frequenzbereich'])
xlabel('x')
ylabel('y')

figure(4)
plotEdgeVoltage(msh,imag(jbow_mqs_f),2,bc)
title(['Imaginaerteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Frequenzbereich'])
xlabel('x')
ylabel('y') 


%% Aufgabe 7
% -------------------------------------------------------------------------
% ----------- Magnetoquasistatisches Problem im Zeitbereich --------------
% -------------------------------------------------------------------------
disp('Loesung des quasistatischen Problems im Zeitbereich')

% Zeitparameter so setzen, dass drei Perioden durchlaufen werden
periods =                   % Anzahl an Perioden
nperperiod =                % Anzahl an Zeitpunkten pro Periode
tend =                      % Endzeit
nt =                        % Gesamtzahl an Zeitpunkten
time =                      % Zeit-Vektor

% Anfangswert für die Lösung der DGL wählen
% abow_init = ...

% Anregung jsbow als Funktion der Zeit
% jsbow_t = @(t)(....);

% Lösen des MQS-Problems
[abow_mqs_t, hbow_mqs_t, bbow_mqs_t, jbow_mqs_t, ebow_mqs_t] = solveMQST(msh, mui, kappa, abow_init, jsbow_t, time, bc);

% Index für Plot wählen
i = 3; j = 2; k = 2;
idx2plot = 1 + (i-1)*Mx + (j-1)*My + (k-1)*Mz;

% Vektorpotential (Lösung der DGL) für gewählte primäre Kante (idx2plot) über die Zeit plotten
figure(5)
plot(time,abow_mqs_t(idx2plot,:));
title('Loesung des quasistatischen Problems im Zeitbereich');
xlabel('Zeit');
ylabel('Vektorpotential abow_{mqs,t}');

% Stromdichteverteilung für gewählte duale Fläche (idx2plot) über die Zeit plotten
figure(6)
plot(time,jbow_mqs_t(idx2plot,:));
title('Loesung des quasistatischen Problems im Zeitbereich');
xlabel('Zeit');
ylabel('Strom jbow_{mqs,t}');


%% Aufgabe 8
% -------------------------------------------------------------------------
% ----------     Vergleich Frequenzbereich <=> Zeitbereich        ---------
% ---------- Transformation Lösung Frequenzbereich in Zeitbereich ---------
% ----------          Vergleich Real- und Imaginärteil            ---------
% -------------------------------------------------------------------------
disp('Vergleich Frequenzbereich <=> Zeitbereich')

% Transformation der Frequenzbereichslösung in den Zeitbereich
% abow_mqs_f_t = ;
% jbow_mqs_f_t = ;

% Vektorpotential (Lösung der DGL) Frequenzbereich vs. Zeitbereich für gewählte duale Fläche (idx2plot) über die Zeit plotten
figure(7)
plot(time,abow_mqs_t(idx2plot,:),'b-');
hold on
plot(time,abow_mqs_f_t(idx2plot,:),'g--');
hold off
title('Vergleich Zeitloesung zu Frequenzloesung')
xlabel('Zeit t')
ylabel('Vektorpotential abow_{mqs,t}')
legend('Zeitloesung','Frequenzloesung')

% Stromdichte-Lösung Frequenzbereich vs. Zeitbereich für gewählte duale Fläche (idx2plot) über die Zeit plotten
figure(8)
plot(time,jbow_mqs_t(idx2plot,:),'b-');
hold on
plot(time,jbow_mqs_f_t(idx2plot,:),'g--');
hold off
title('Vergleich Zeitloesung zu Frequenzloesung')
xlabel('Zeit t')
ylabel('Strom jbow_{mqs,t}')
legend('Zeitloesung','Frequenzloesung')

% Vergleich von Zeitlösung zur Frequenzlösung im Zeitbereich
% -> Implementierung der Fehlernorm aus der Aufgabenstellung
% ...
% ...
% ...
% errorTimeVSfrequency = 
% fprintf('Relativer Fehler im Zeitbereich: %e\n',errorTimeVSfrequency);

%% Aufgabe 9
% -------------------------------------------------------------------------
% ----------     Vergleich Frequenzbereich <=> Zeitbereich        ---------
% ---------- Transformation Lösung Zeitbereich in Frequenzbereich ---------
% ----------               Vergleich der Phasoren                 ---------
% -------------------------------------------------------------------------

% (Vergleich der Phasoren)

% Transformation der Zeitbereichslösung in den Frequenzbereich
% Bestimmung von Real- und Imaginärteil des komplexen Phasors,
% der aus dem Zeitsignal gewonnen werden kann
    % t_real =
    % t_imag =
    jbow_re_t = zeros(3*msh.np,1);
    jbow_im_t = zeros(3*msh.np,1);
    for i = 1:3*msh.np
    %    jbow_re_t(i) = interp1(...);
    %    jbow_im_t(i) = ...
    end


% Vergleich von Real- und Imaginärteil des Phasors aus dem Zeitbereich
% mit dem Phasor aus der Frequenzbereichslösung (Implementierung der Formel aus Aufgabenstellung)
% errorPhasorReal = ...
% errorPhasorImag = ...
% fprintf('Relativer Fehler Realteil: %e\n',errorPhasorReal);
% fprintf('Relativer Fehler Imaginärteil: %e\n',errorPhasorImag);
  
% Plot: gleiches Feldbild für Phasoren des Zeitintegration zum optischen 
% Vergleich mit den Plots, die man für die Phasoren des Frequenzbereiches
% erhalten hat
figure(9)
plotEdgeVoltage(msh,jbow_re_t, 2, bc)
title(['Realteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Zeitbereich'])
xlabel('x')
ylabel('y')
zlabel('z')
figure(10)
plotEdgeVoltage(msh,jbow_im_t, 2, bc)
title(['Imaginaerteil der Stromdichte auf der Plattenoberflaeche, '  ...
      'Quasistatik, Zeitbereich'])
xlabel('x')
ylabel('y')
zlabel('z')


%% Aufgabe 10
% -------------------------------------------------------------------------
% -------------- Konvergenz des Fehlers der Zeitintegration ---------------
% -------------------------------------------------------------------------

% Konvergenz des Fehlers der Zeitintegration
% nperperiodMax = 100
% plotConvSolveMQST(msh,mui,kappa,jsbow_t,jbow_mqs_f,periods,tend,f,nperperiodMax,bc);