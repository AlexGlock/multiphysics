%% WR - domain coupling example
%
%   ^   [S]
% t |    |     
%   | D0 | D1
%   |    |
%   o----------->
%       x
% two subdomains D0, D1 with interface S at L/2
% solving two independent systems of dUdt = alpha * lap(u)
%    

% domain settings
L = 0.1;         % [m] length
n = 40;          % node count

% timestepping
t_end = 15;         % [s] duration
dt = 0.01;          % [s] time step

% boundary conditions
U_0 = 90;           % [C°] left boundary
U_Lh = 45;          % [C°] first guess of coupling
U_L = 20;           % [C°] right boundary

% initial condition
u0 = 10;            % [C°] temp of domain at t=0

% thermal stuff
alpha = 0.0001;     % funky thermal conductivity 
 
%% DOMAIN & TIME DISCRETIZATION -------------------------------------------
dx = L/n;
x_d0 = linspace(0,L/2-dx,n/2-1);
x_d1 = linspace(L/2+dx, L, n/2-1);
t = linspace(0,t_end, t_end/dt);

% solution vector(s)
U_d0 = ones(n/2-1, 1)* u0;
U_d1 = U_d0;
dUdt_d0 = zeros(n/2-1, 1);
dUdt_d1 = dUdt_d0;

% set initial boundary vals 
U_d0(1) = U_0;
U_d1(end) = U_L;

% stepping through time
for j = 1:length(t)
%% on D0 domain -----------------------------------------------------------
    parfor i = 2:n/2-2
        dUdt_d0(i) = alpha*(-(U_d0(i)-U_d0(i-1))/dx^2+(U_d0(i+1)-U_d0(i))/dx^2);
    end
    % boundary nodes
    dUdt_d0(1) = 0;
    dUdt_d0(n/2-1) = alpha*(-(U_d0(n/2-1)-U_d0(n/2-2))/dx^2+(U_Lh-U_d0(n/2-1))/dx^2);
    % expl. Euler
    U_d0 = U_d0 + dUdt_d0 *dt;
    
 %% on D1 domain ----------------------------------------------------------
    parfor i = 2:n/2-2
        dUdt_d1(i) = alpha*(-(U_d1(i)-U_d1(i-1))/dx^2+(U_d1(i+1)-U_d1(i))/dx^2);
    end
    % boundary nodes
    dUdt_d1(1) = alpha*(-(U_d1(1)-U_Lh)/dx^2+(U_d1(2)-U_d1(1))/dx^2);
    dUdt_d1(n/2-1) = 0;
    % expl. Euler
    U_d1 = U_d1 + dUdt_d1 *dt;

 %% update coupling -------------------------------------------------------
    U_Lh = 0.5 * (U_d0(end) + U_d1(1)) ;
    
    % plot
    figure(1)
    plot(x_d0, U_d0, x_d1, U_d1,'LineWidth',2)
    hold on
    plot(L/2, U_Lh, '*')
    hold off
    axis([0 L 0 100])
    xlabel('X position')
    xline(L/2, '-', {'interface L/2'})
    ylabel('temperature')
end
