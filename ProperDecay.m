%{

@Copyrights Eran Reches, 2018

This function produce a graph of the fraction of 'good' decays versus
the coupling strength k.

Inputs:

N          - Number of realizations to run for each value of k.
k_interval - interval of k values.

Outputs:

rho - vector of fractions of 'good' decays.

%}

function [rho] = ProperDecay(N,k_interval)

init = [0;pi;0;pi;0;pi]; tf = 10; dt = 0.01; gamma = 1; sigma = 0.01; %SDE parameters.
plot_enable = false; t_sep = 8; th = 0; %NGraphsPlotter parameters.
rho  = []; %Fraction of proper decays.
down = 0.1; %Lower bound.

for k = k_interval
    [t,xi_Tri_cell] = NGraphsPlotter(N,init,tf,dt,gamma,k,sigma,plot_enable,t_sep,th); %Solving N realizations.
    p = 0; %Counting good decays.
    for i = 1:N
        if t(find(xi_Tri_cell{i}>down,1,'last')) < t_sep
            p = p+1;
        end
    end
    rho = [rho,p/N];
end

plot(k_interval,rho,'m','LineWidth',2); %Plotting.

%Figure properties.
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$k$','interpreter','latex','FontSize',25);
ylabel('\boldmath$\rho$','interpreter','latex','FontSize',25);
title(['\boldmath$\Gamma=',num2str(gamma),'$'],'interpreter','latex','FontSize',25);
xlim([k_interval(1),k_interval(end)]);
ylim([0.5,1]);

end