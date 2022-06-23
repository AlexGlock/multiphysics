%% Wähle inhomogen oder homogen
% material_option = 'homogen';
material_option = 'inhomogen';

%% Materialdaten und rot-Operator der Leitung laden
if strcmp( material_option, 'homogen' )
    mur = 1;
    epsr = 0.9;
	[Meps,Mmui,C] = setupProblem(epsr,mur);
elseif strcmp( material_option, 'inhomogen' )
    load material_data
    Mepsi = Mepsi_inhomogen;
    Mmui = Mmui_inhomogen;
    % Erstellen der nicht-inversen Kapazitätsmatrix
    Meps=nullInv(Mepsi);
else
    error('unknown material option. material_option should be either homogen or inhomogen')
end

% Initialisierung
nx=4; ny=4; nz=151;
np=nx*ny*nz;
Mx=1; My=nx; Mz=nx*ny;
h=sparse(3*np,1);
e=sparse(3*np,1);

% checks correct size of mesh. Otherwise generates exception.
assert(np==size(Mmui,1)/3)

%% R-Matrix erstellen
R = 50;
Rmat = ohmic_termination_distributed_front_and_back(np, R);

%% Simulation in Zeitbereich
% initialisiere Feldwerte und Parameter
nts = 1500;
dt = 2.1e-11;
time = 0:dt:(nts*dt);
fmax = 1e9;

% Sampling-Frequenz der Zeitdiskretisierung
Fs = 1/dt;
fprintf('Sampling-Frequenz: %d Hz\n',Fs);

% index used for current and voltage measurements
idx2measure = 5;

% Initialisierung
ebow = zeros(3*np,1);
hbow = zeros(3*np,1);
U1 = zeros(1,nts);
I1 = zeros(1,nts);
U2 = zeros(1,nts);
I2 = zeros(1,nts);

% Anregungssignal (verteilter eingeprägter Strom von Außen- zu Innenleiter an vorderer Stirnfläche)
je = gauss_pulse(time, fmax, np, true);

% Zeitschleife
tic;
for k=2:nts
    dt = time(k) - time(k-1);

    [hbow,ebow] = leapfrog(hbow, ebow, je(:,k), Mmui, Meps, C, Rmat, dt);

    % Spannung und Strom für Ein- und Ausgang
   U1(k) = ebow(idx2measure);
   I1(k) = -je(idx2measure,k)*8 - U1(k)/R;
   U2(k) = ebow(idx2measure + 150*Mz);
   I2(k) = -U2(k)/R;

end
time_TD = toc;

figure(1)
subplot(2,2,1)
plot(time(2:end),U1);
xlabel('Zeit in s')
ylabel('U_1 in V')
title('Eingangsspannung im Zeitbereich')

subplot(2,2,2)
plot(time(2:end),I1);
xlabel('Zeit in s')
ylabel('I_1 in A')
title('Eingangsstrom im Zeitbereich')

subplot(2,2,3)
plot(time(2:end),U2);
xlabel('Zeit in s')
ylabel('U_2 in V')
title('Ausgangsspannung im Zeitbereich')

subplot(2,2,4)
plot(time(2:end),I2);
xlabel('Zeit in s')
ylabel('I_2 in V')
title('Ausgangsstrom im Zeitbereich')


%% Transformation in den Frequenzbereich zur Auswertung der Impedanz

% Anzahl an Samples Ns, zero-padding zp, Anzahl an Samples für fft N und maximale zu plottende Frequenz fmax2plot
Ns = 1000;
N = 2^(ceil(log2(Ns)));
zp = N - Ns;
fmax2plot = 10e6;

% Transformation der Eingangsgrößen
[U1_fft,freq]=fftmod(U1,N,Fs);
I1_fft=fftmod(I1,N,Fs);

% Transformation der Ausgangsgrößen
U2_fft=fftmod(U2,N,Fs);
I2_fft=fftmod(I2,N,Fs);

% Darstellung der Spannungen und Ströme an Ein-/Ausgang im Frequenzbereich
figure(2)
subplot(2,2,1)
plot(freq,abs(U1_fft));
xlabel('Frequenz in Hz')
ylabel('U_1 in V')
title('Eingangsspannung im Frequenzbereich')
xlim([0 2*fmax]);

subplot(2,2,2)
plot(freq,abs(I1_fft));
xlabel('Frequenz in Hz')
ylabel('I_1 in A')
title('Eingangsstrom im Frequenzbereich')
xlim([0 2*fmax]);

subplot(2,2,3)
plot(freq,abs(U2_fft));
xlabel('Frequenz in Hz')
ylabel('U_2 in V')
title('Ausgangsspannung im Frequenzbereich')
xlim([0 2*fmax]);

subplot(2,2,4)
plot(freq,abs(I2_fft));
xlabel('Frequenz in Hz')
ylabel('I_2 in V')
title('Ausgangsstrom im Frequenzbereich')
xlim([0 2*fmax]);


%% Darstellung der Ein-/Ausgangsimpedanz im Frequenzbereich

% Berechnung Ein- und Ausgangsimpedanz im Frequenzbereich
je_vec = -full(je(idx2measure,:)*8);
Js_fft = fftmod(je_vec,N,Fs);
Z1_fft=U1_fft./(I1_fft - Js_fft);
Z2_fft=U2_fft./I2_fft;

figure(3);
plot(freq,abs(Z1_fft),'k-');
xlabel('Frequenz in Hz');
ylabel('Z_1 in \Omega');
title('Eingangsimpedanz');
xlim([0 fmax2plot]);
ylim([45 55]);

figure(4);
plot(freq,abs(Z2_fft),'b-');
xlabel('Frequenz in Hz');
ylabel('Z_2 in \Omega');
title('Ausgangsimpedanz');
xlim([0 fmax2plot]);
ylim([45 55]);


%% Auswertung Wellengrößen

Zwsqrt = sqrt(R);

a1 = 0.5 * (U1_fft/Zwsqrt + I1_fft*Zwsqrt);
b1 = 0.5 * (U1_fft/Zwsqrt - I1_fft*Zwsqrt);
b2 = 0.5 * (U2_fft/Zwsqrt - I2_fft*Zwsqrt);
%
S11 = b1./a1;
S21 = b2./a1;
%
energy = abs(S11).^2 + abs(S21).^2;

% Darstellung Energie und Wellengrößen
figure(5);
plot(freq, abs(S11),freq,abs(S21),freq,energy);
xlabel('Frequenz in Hz')
ylabel('\{S-Parameter,Energie\}')
title('S-Parameter und Energie')
legend('S11','S21','Energie')
xlim([0 fmax2plot]);

%% Auswertung Rechenzeit Frequenzbereich (FD) <-> Zeitbereich (TD)
%% NB: we are in frequency domain now, that is all quantities are /phasors/!

% Angular frequency (pick one)
omega = 2*pi*1e9;

% System matrix
% AF = 

% Source current (make sure it is divergence free)
jbowF                = sparse(size(AF, 1), 1);
jbowF([ 7,11],    :) =  [1/8; 1/8];
jbowF([ 5, 9],    :) = -[1/8; 1/8];
jbowF([10,11]+np, :) =  [1/8; 1/8];
jbowF([ 2, 3]+np, :) = -[1/8; 1/8];

% Right hand side
% rhsF = ;

% Linear systems resulting from FD wave problems
% are hard to solve with an iterative solver.
% For this reason, we will use a direct solver
% (i.e. LU factorization with forward/backward substitution).
% However, this requires a full rank matrix:
% we thus need to get rid of the entries associated with:
%  i)  the ghost edges and
%  ii) the edges with a PEC boundary condition.
% In both cases, ebow = 0 for these edges.
% Hints: * those edges can be easily identified from the zero entries in Meps,
%        * C = setdiff(A, B) returns the data in A that is not in B,
%          with no repetitions; C is in sorted order.

% Eliminate known values of ebow from AF and rhsF

% AF_reduced   = ; % keep only true unknowns
% rhsF_reduced = ;               

% Solve and keep track of timing
% NB: * 'backslash' should trigger an LU factorization,
%     * you can check this with "spparms('spumoni', 1);" (MATLAB only)
tic;
ebowF_reduced  = AF_reduced\rhsF_reduced;
time_FD = toc;

% Recover ebow for all edges
% ebowF = sparse();
% ebowF() = ;

% As a quick validation, let us plot the voltage along the waveguide,
% as we did in lab 7
% idxEdge2plot = 5;
% u_lineF = ebowF(idxEdge2plot:Mz:idxEdge2plot+(nz-1)*Mz);
% figure;
% plot();
% title();
% xlabel();
% ylabel();

% Display timings
% * Ask yourself, does the comparison make sense?
% * What are the pro and cons of FD and TD simulations?
fprintf('Time TD: %e\n', time_TD);
fprintf('Time FD: %e\n', time_FD);
