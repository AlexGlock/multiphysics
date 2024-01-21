%% picard method - WR
%
%   ^   [S]
% t |    |     
%   | D0 | D1
%   |    |
%   o----------->
%       x
% two subdomains D0, D1 with interface S at node n/2
% solving two independent systems: dUdt = alpha * laplace(u)
%    

% domain
L = 0.1;         % [m] length
n = 40;          % node count

% timesteps
t_end = 15;      % [s] duration
dt = 0.02;       % [s] time step

% boundary conditions u(t,0) & u(t,L)
U_0 = 90;
U_Lh = 45;       % guess of coupling coeff.
U_L = 20;

% thermal stuff
alpha = 0.0001; 

% 1st order ODE: Ydx = alpha * x + Y 
% -------------------------------------------------------------------------
x_d0 = linspace(0,L/2,n/2);
x_d1 = linspace(L/2, L, n/2);
t = linspace(0,t_end, t_end/dt);

%U = ones(n, 1) *u0;
U_d0 = ones(n/2, 1)* u0;     % solution vector(s)
U_d1 = U_d0;
dUdt_d0 = zeros(n/2, 1);     % derivative
dUdt_d1 = dUdt_d0;

% stepping through time
for j = 1:length(t)

    % on D0 domain --------------------------------------------------------
    for i = 2:n/2-1
        dUdt_d0(i) = alpha*(-(U_d0(i)-U_d0(i-1))/dx^2+(U_d0(i+1)-U_d0(i))/dx^2);
    end
    % boundary nodes
    dUdt_d0(1) = alpha*(-(U_d0(1)-U_0)/dx^2+(U_d0(2)-U_d0(1))/dx^2);
    dUdt_d0(n/2) = alpha*(-(U_d0(n/2)-U_d0(n/2-1))/dx^2+(U_Lh-U_d0(n/2))/dx^2);
    % expl. Euler
    U_d0 = U_d0 + dUdt_d0 *dt;

    % on D1 domain --------------------------------------------------------
    for i = 2:n/2-1
        dUdt_d1(i) = alpha*(-(U_d1(i)-U_d1(i-1))/dx^2+(U_d1(i+1)-U_d1(i))/dx^2);
    end
    % boundary nodes
    dUdt_d1(1) = alpha*(-(U_d1(1)-U_Lh)/dx^2+(U_d1(2)-U_d1(1))/dx^2);
    dUdt_d1(n/2) = alpha*(-(U_d1(n/2)-U_d1(n/2-1))/dx^2+(U_L-U_d1(n/2))/dx^2);
    % expl. Euler
    U_d1 = U_d1 + dUdt_d1 *dt;

    % update coupling ??? -------------------------------------------------
    U_Lh = 0.5 * (U_d0(end)+U_d1(1));
    
    % plot
    figure(1)
    plot(x_d0, U_d0, x_d1, U_d1, 'LineWidth',3)
    axis([0 L 0 100])
    xlabel('X position')
    xline(x_d1(1), '-', {'interface [s]'})
    ylabel('temperature')
    pause(0.01)
end
