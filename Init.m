%% Init.m
% Writes relevant data to binary file.
% author: Xiaojing ZHANG
% date: October 17, 2011


clc; 
clear all;
format('short');

%% MPC parameters:
N = 10;      % MPC horizon
m = 2;      % # input
n = 5;      % # states

%% System dynamic parameters

A = [1 0 1.2 1.3 1
    0.5 2.1 1 1 -0.3
    1 1 .2 1 -2
    0 1 0.3 1.4 -2
    0.4 -0.9 2 1.2 -.4];   

B = [1 0 
    1.3 1
    0 1.2
    -0.1 1
    0.2 -1];

s = [0 ; 2 ; 1.4 ; 2 ; 1];

K = -[  -0.687725010189527   1.970370349984470  -0.865901978685416  -3.069636538756281  2.096473307971948
   0.181027584433678   1.040671203681152  -0.344287251091615   0.362844179335401  -1.109614558033092]; 

%% cost and constraint matrices
Q_tilde = 10*eye(n);
Q_tilde_f = Q_tilde+5;

R = 2*eye(m);

% constraint matrices: constrained on 
H = eye(n); k = 1000*ones(n,1);
Fx{1} = [H ; -H];
Fx{2} = [H ; -H];
Fx{3} = [H ; -H];
Fx{4} = [H ; -H];
Fx{5} = [H ; -H];
Fx{6} = [H ; -H];
Fx{7} = [H ; -H];
Fx{8} = [H ; -H];
Fx{9} = [H ; -H];
Fx{10} = [H ; -H];
fx{1} = [k ; k]-3;
fx{2} = [k ; k]-0;
fx{3} = [k ; k];
fx{4} = [k ; k];
fx{5} = [k ; k]-2;
fx{6} = [k ; k]+3;
fx{7} = [k ; k]+4;
fx{8} = [k ; k]+2;
fx{9} = [k ; k]-10;
fx{10} = [k ; k]+10;


H = eye(m); k = 100*ones(m,1);
Fu{1} = [H ; -H];
Fu{2} = [H ; -H];
Fu{3} = [H ; -H];
Fu{4} = [H ; -H];
Fu{5} = [H ; -H];
Fu{6} = [H ; -H];
Fu{7} = [H ; -H];
Fu{8} = [H ; -H];
Fu{9} = [H ; -H];
Fu{10} = [H ; -H];
fu{1} = [k ; k+20]+1;
fu{2} = [k+4 ; k]-0;
fu{3} = [k ; k]+5;
fu{4} = [k ; k]+10;
fu{5} = [k ; k-10];
fu{6} = [k ; k]+2;
fu{7} = [k ; k]-7;
fu{8} = [k ; k]+10;
fu{9} = [k ; k]-10;
fu{10} = [k+10 ; k];


F_xTheta = [ 1  1  1  0  0  
            -1 -1 -1  0  0   
             0  0  0  1  1 
             0  0  0 -1 -1
             1  0  1  0  0
            -1  0 -1  0  0
             0  0  0  1  0
             0  0  0 -1  0
             0 0   -1  1  1
             0  0  1 -1  -1];
F_theta = [ 1  0
           -1  0
            0  1
            0 -1
            0  1
            0 -1
            1  0
           -1  0
            0  1
            0 -1];
      
f_xTheta = 100*[20 20 20 20 30 30 40 40 50 50]';


%% Parameters for constructor
kappa_start_PhaseI = 100;  % barrier parameter for PhaseI - can be as high as 1e10
kappa_start_PhaseII = 1e9;  % barrier parameter for PhaseII - 
mu = 1/10;   % decrease parameter of kappa, i.e. kappa := mu*kappa
eps_nt = 0.1;   % tolerance for residua norm([r_p ; r_d]) in Newton method
eps_normRp = 0.1;   % tolerance for primal residua norm(r_p)
eps_barrier = 0.1;  % barrier parameter, suboptimality of the solution
eps_ls = 1e-7;     % smallest t, s.t. z+ = z + t*dz, nu+ = nu + t*dnu
n_iter = 20;    % number of maximum Newton iterations for a fixed kappa in PhaseII
alpha_ls = 0.01; % alpha parameter in line search, (0.01,0.3)
beta_ls = 0.5;  % 0.1 < beta_ls < 0.8
reg_PhaseI = 0.1; % regularization Term in PhaseI
reg_PhaseII = 1e-5;  % regularization Term in PhaseII
 

%% write data for constructor arguments into file
% ConstrParam.bin

writeParam      % call writeParam.m

disp(['new parameters written to binary file']);
