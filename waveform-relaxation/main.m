%% waveform relaxation algorithm

%   1D heat propagation
%
%   0 ============== L
%

% domain
L = 0.1;          % [m] length
n = 30;        % node count

% timesteps
t_end = 10;     % [s] duration
dt = 0.05;       % [s] time step

% boundary conditions u(t,0) & u(t,L)
U_0 = 90;
U_L = 0;

% initial condition u(0,x)
u0 = 0;

% thermal stuff
alpha = 0.0001; 

% -------------------------------------------------------------------------
dx = L/n;
x = linspace(0,L,n);
t = linspace(0,t_end, t_end/dt);

U = ones(n, 1)* u0;     % solution vector
dUdt = zeros(n, 1);     % derivative

% stepping through time
for j = 1:length(t)
    % interior nodes
    for i = 2:n-1
        dUdt(i) = alpha*(-(U(i)-U(i-1))/dx^2+(U(i+1)-U(i))/dx^2);
    end
    % boundary nodes
    dUdt(1) = alpha*(-(U(1)-U_0)/dx^2+(U(2)-U(1))/dx^2);
    dUdt(n) = alpha*(-(U(n)-U(n-1))/dx^2+(U_L-U(n))/dx^2);

    % expl. Euler
    U = U + dUdt *dt;

    % plot
    figure(1)
    %imagesc(U)
    %colormap('hot')
    plot(x, U, 'LineWidth',3)
    axis([0 L 0 100])
    xlabel('X position')
    ylabel('temperature')
    pause(0.05)
end

%% WR approach
%
%   ^   [S]
% t |    |     
%   | D0 | D1
%   |    |
%   o----------->
%       x
% two subdomains D0, D1 with interface S
