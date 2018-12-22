%{

@Copyrights Eran Reches, 2018

This function plots a trajectory in the gait-space starting at init.

Inputs:

init - initial condition.

Outputs:

flag - a boolean variable indicating if the trajectory converges to idling.

%}

function [flag] = GaitSpacePlot(init)
tf = 50; dt = 0.01; gamma = 1; k = 0; sigma = 0.01; %Simulation parameters.
ex = @(phi1,phi2) exp(1i*(phi1-phi2)); %Imaginary exponent.

%Single realization.
[~,phi,xi_Tri,xi_Idl] = EulerMaruyamaSolver(init,tf,dt,gamma,k,sigma);
xi_Pace = abs(ex(phi(1,:),0)...
             +ex(phi(2,:),0)...
             +ex(phi(3,:),0)...
             +ex(phi(4,:),pi)...
             +ex(phi(5,:),pi)...
             +ex(phi(6,:),pi))/6; %Idle order parameter.

%Convergence check.
th   = 0.97;
flag = xi_Idl(end)>th;

%Plotting.
figure(1);
scatter3(xi_Idl,xi_Tri,xi_Pace,10,[xi_Idl',xi_Tri',xi_Pace'],'filled');
hold on
figure(2);
subplot(1,2,1);
scatter(xi_Idl,xi_Tri,10,[xi_Idl',xi_Tri',xi_Pace'],'filled');
hold on
subplot(1,2,2);
scatter(xi_Idl,xi_Pace,10,[xi_Idl',xi_Tri',xi_Pace'],'filled');
hold on

end