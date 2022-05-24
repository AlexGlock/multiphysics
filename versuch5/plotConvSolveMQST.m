% Aufgabe 10
%
% plotConvSolveMQST(msh,mui,kappa,jsbow,jbow_mqs_f,tend,f,ntmax, bc) stellt den 
% relativen Fehlers der Lösung im Zeitbereich abhängig
% von der Schrittweite bezüglich der Lösung im Frequenzbereich in der
% 2-Norm (siehe norm(A,p)) dar.
%
%   Parameter
%   msh            Kanonisches kartesisches Gitter
%   mui            Inverse Permeabilität entsprechend Methode createMmui
%   kappa          Leitfähigkeit entsprechend Methode createMeps
%   jsbow          Stromgitterfluss (Erregung)
%   jbow_mqs_f     Referenzlösung im Frequenzbereich
%   periods        Anzahl der zu simulierenden Perioden des Zeitsignals
%   tend           Endzeitpunkt
%   f              Frequenz der Anregung
%   nperperiodMax  Maximale Stützstellenzahl pro Periode
%   bc             Randbedingungen (0=magnetisch, 1=elektrisch)

function plotConvSolveMQST(msh, mui, kappa, jsbow, jbow_mqs_f, periods, tend, f, nperperiodMax, bc)

% Kreisfrequenz
omega = 2*pi*f;

% Samples pro Periode als Vektor für Konvergenzstudie 
nperperiod_vec=floor(linspace(5,nperperiodMax,5));

% Initialisierung des Fehlers
errorTimeDomain = zeros(length(nperperiod_vec),1);
errorPhasorReal = zeros(length(nperperiod_vec),1);
errorPhasorImag = zeros(length(nperperiod_vec),1);

% Anfangswert für die Lösung der DGL im Zeitbereich wählen
abow_init = zeros(3*msh.np,1);

for e=1:length(nperperiod_vec)

    nperperiod = nperperiod_vec(e);
    nt = periods*nperperiod + 1;
    time = linspace(0,tend,nt);
    
	% Löse MQS im Zeitbereich
    [~, ~, ~, jbow_mqs_t,~] = solveMQST(msh, mui, kappa, abow_init, jsbow, time, bc);

    % Transformation der Frequenzbereichslösung in den Zeitbereich
    jbow_mqs_f_t = real(jbow_mqs_f * exp(1i*omega*time));
    
    % Vergleich von Zeitlösung zur Frequenzlösung im Zeitbereich
    % -> Implementierung der Fehlernorm aus der Aufgabenstellung
    imax = size(jbow_mqs_t);
    imax = imax(1,2);
    errorz = zeros(1,imax);
    errorn = zeros(1,imax);
    for i = 1:1:imax
        errorz(i) = norm(jbow_mqs_t(:,i) - jbow_mqs_f_t(:,i));
        errorn(i) = norm(jbow_mqs_f_t(:,i));
    end

    errorTimeDomain(e) = max(errorz) / max(errorn);


	% Vergleich von Zeitlösung zur Frequenzlösung im Frequenzbereich
    % (Vergleich der Phasoren)

    % Real- und Imaginärteil der Stromdichte aus Zeitsignal bestimmen
    t_real = 0;
    t_imag = 0.015;
    jbow_re_t = zeros(3*msh.np,1);
    jbow_im_t = zeros(3*msh.np,1);
    for i = 1:3*msh.np
        jbow_re_t(i) = interp1(time,jbow_mqs_t(i,:),t_real);
        jbow_im_t(i) = interp1(time,jbow_mqs_t(i,:),t_imag);
    end

    % Fehler Real- und Imaginärteil
    errorPhasorReal(e) = norm(jbow_re_t - real(jbow_mqs_f))/norm(real(jbow_mqs_f));
    errorPhasorImag(e) = norm(jbow_im_t - imag(jbow_mqs_f))/norm(imag(jbow_mqs_f));

end

% Plot Vergleich im Zeitbereich
figure(11)
plot(log(nperperiod_vec),log(errorTimeDomain),'-x','LineWidth',2);
xlabel('Anzahl der Stuetzstellen pro Periode','FontSize',14);
ylabel('Relativer Fehler im Zeitbereich','FontSize',14);

% Plot Vergleich im Frequenzbereich (Vergleich der Phasoren)
figure(12)
plot(log(nperperiod_vec),log(errorPhasorReal),'-x','LineWidth',2);
hold all;
plot(log(nperperiod_vec),log(errorPhasorImag),'-x','LineWidth',2);
hold off;
xlabel('Anzahl der Stuetzstellen pro Periode');
ylabel('Relativer Fehler im Frequenzbereich');
legend('Realteil','Imaginaerteil');