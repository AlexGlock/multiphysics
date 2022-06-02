% Versuch 6

%% Gitter erstellen (nicht mesh nennen, da dies ein Matlab-Befehl ist)
gitter_1 = true;
gitter_2 = false;
gitter_3 = false;

if gitter_1 == true
    nx = 11;
    ny = 11;
    nz = 2;
end

if gitter_2 == true
    nx = 41;
    ny = 41;
    nz = 2;
end

if gitter_3 == true
    nx = 91;
    ny = 91;
    nz = 2;
end

xmesh = linspace(0,1,nx);
ymesh = linspace(0,1,ny);
zmesh = linspace(0,1,nz);
msh = cartMesh(xmesh, ymesh, zmesh); 

% Gitterweiten in x-,y- und z-Richtung (äquidistant vorausgesetzt)
delta_x = 1/(nx-1);
delta_y = 1/(ny-1);
delta_z = 1/(nz-1);

Mx = msh.Mx;
My = msh.My;
Mz = msh.Mz;
np = msh.np;

%% Erzeugung der topologischen und geometrischen Matrizen
[c, s, st] = createTopMats(msh);
[ds, dst, da, dat] = createGeoMats(msh);

% Erzeugung der Materialmatrizen: Mmui, Mmu, Meps, Mepsi
% Achtung bei createMmui und createMeps Randbedingungen übergeben, da
% explizites Verfahren und damit Randbedingungen am besten in den
% Materialmatrizen gesetzt werden
eps0 = 8.854e-12;
eps_r = 1;
epsilon = eps0 * eps_r;
mu0 = 4e-7*pi;
mu_r = 1;
mu = mu0 * mu_r;
mui = 1/mu;
bcs = [1,1,1,1,1,1];

Mmui = createMmui(msh, ds, dst, da, mui, bcs);
Mmu = nullInv(Mmui);

Meps = createMeps(msh, ds, da, dat, epsilon, bcs);
Mepsi = nullInv(Meps);


%% CFL-Bedingung

% Minimale Gitterweite bestimmen
delta_s = min([delta_x,delta_y,delta_z]);

% Berechnung und Ausgabe des minimalen Zeitschritts mittels CFL-Bedingung
deltaTmaxCFL = sqrt(mu*epsilon * 1/(1/(delta_x^2) + 1/(delta_y^2) + 1/(delta_z^2)));
fprintf('Nach CFL-Bedingung: deltaTmax = %e\n',deltaTmaxCFL);

%% Stabilitätsuntersuchung mithilfe der Systemmatrix
% Methode 1
if msh.np<4000

A12 = -Mmui * c;
A21 = Mepsi * c';
zero = sparse(3*np, 3*np);
A = [zero, A12; A21, zero];
[~, lambdaMaxA] = eigs(A,1);

% Workaround, da Octave bei [V,D] = eigs(A,1) eine Matrix zurückgibt
% if ~isscalar(lambdaMaxA)
%     lambdaMaxA = lambdaMaxA(1,1);
% end

% delta T bestimmen
deltaTmaxEigA = 2/abs(lambdaMaxA);
fprintf('Nach Eigenwert-Berechnung von A: deltaTmax = %e\n', deltaTmaxEigA);

end

%% Experimentelle Bestimmung mithilfe der Energie des Systems

% Parameter der Zeitsimulation
sigma = 6e-10;
dt = 1e-11;
tend = 2*sigma;
steps = floor(tend/dt);
sourcetype= 1;  % 1: Gauss Anregung, 2: Harmonisch, 3: Konstante Anregung

% Anregung jsbow als anonyme Funktion, die einen 3*np Vektor zurückgibt
% Anregung wird später in Schleife für t>2*sigma_gauss abgeschnitten, also null gesetzt
jsbow_space = zeros(3*np, 1);
x_L = ceil(nx/2);
y_L = ceil(ny/2);

for k = 1:nz-1
    n = 1 + x_L*Mx + y_L*My + (k-1)*Mz + 2*np;
    jsbow_space(n) = 1;  
end

jmax = 1;

% Gauss Anregung
jsbow_gauss = @(t)(jsbow_space * jmax * exp(-4*((t-sigma)/sigma)^2));

% Harmonische Anregung (optional)
% jsbow_harm = @(t)(jsbow_space * ...);

% Konstante Anregung (optional, für t>0)
% jsbow_const = @(t)(jsbow_space * ...);

% Initialisierungen
ebow_new = sparse(3*np,1);
hbow_new = sparse(3*np,1);
energy = zeros(1,steps);
leistungQuelle = zeros(1,steps);

% Plot parameter für "movie"
figure(1)
zlimit = 30/(delta_x(1));
draw_only_every = 4;

% Zeitintegration
for ii = 1:steps
    % Zeitpunkt berechnen
    t = ii*dt;

    % alte Werte speichern
    ebow_old = ebow_new;
    hbow_old = hbow_new;

    if sourcetype == 1
        % Stromanregung js aus jsbow(t) für diesen Zeitschritt berechnen
        if t <= 2*sigma
            js = jsbow_gauss(t);
        else
            %js = 0;
            js = sparse(3*np,1);
        end
    elseif sourcetype == 2
        % Harmonische Anregung
        js = jsbow_harm(t);
    elseif sourcetype == 3
        % konstante Anregung
        js = jsbow_const(t);
    end
    
    % Leapfrogschritt durchführen
    [hbow_new,ebow_new] = leapfrog(hbow_old, ebow_old, js, Mmui, Mepsi, c, dt);
    
    % Feld anzeigen
    if mod(ii, draw_only_every)
        z_plane = 1;
        idx2plot = (2*np+1+(z_plane-1)*Mz):(2*np+z_plane*Mz);
		ebow_mat = reshape(ebow_new(idx2plot),nx,ny);
    	figure(1)
        mesh(ebow_mat)
        xlabel('i')
        ylabel('j')
        zlabel(['z-Komponente des E-Feldes für z=',num2str(z_plane)])
		axis([1 nx 1 ny -zlimit zlimit])
		caxis([-zlimit zlimit])
        drawnow
    end

    % Gesamtenergie und Quellenenergie für diesen Zeitschritt berechnen
    energy_t = 0.5 * (ebow_new' * Meps*ebow_new + hbow_new' * Mmu * hbow_new);
    leistungQuelle_t = ebow_new' * js;

    % Energiewerte speichern
    energy(ii) =  energy_t;
    leistungQuelle(ii) = leistungQuelle_t;
end

% Anregungsstrom über der Zeit plotten
figure(2)
jsbow_plot = zeros(1,steps);
for step = 1:steps
    if sourcetype == 1
        jsbow_spatial = jsbow_gauss(step*dt);
    elseif sourcetype == 2
        jsbow_spatial = jsbow_harm(step*dt);
    elseif sourcetype == 3
        jsbow_spatial = jsbow_const(step*dt);
    end
    nonzero_idx = find(jsbow_spatial~=0);
    jsbow_plot(step) = jsbow_spatial(nonzero_idx);
end
plot(dt:dt:dt*steps, jsbow_plot);
xlabel('t in s');
ylabel('Anregungsstrom J in A');

% Energie über der Zeit plotten
figure(3); clf;
plot (dt:dt:dt*steps, energy)
legend(['Zeitschritt: ', num2str(dt)])
xlabel('t in s')
ylabel('Energie des EM-Feldes W in J')

% Zeitliche Änderung der Energie (Leistung)
leistungSystem = diff(energy) / dt;
figure(4); clf;
hold on
plot(2*dt:dt:dt*(steps), leistungSystem)
plot(dt:dt:dt*steps, leistungQuelle, 'r')
hold off
legend('Leistung System', 'Leistung Quelle')
xlabel('t in s')
ylabel('Leistung P in W')