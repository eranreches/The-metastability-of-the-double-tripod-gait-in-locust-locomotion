%{

@Copyrights Eran Reches, 2018

This script demonstrate the stability of the idling
gait and the instability of the double-tripod.

%}

tf = 60; dt = 0.01; gamma = 1; k = 0; sigma = 0.1; %SDE parameters.
hold on

init           = [0;pi;0;pi;0;pi]; %Xi_Tri from initial double-tripod.
[t,~,xi_Tri,~] = EulerMaruyamaSolver(init,tf,dt,gamma,k,sigma);
plot(t,xi_Tri,'r','LineWidth',2);

init            = [0,0,0,0,0,0]; %Xi_Idle from initial idling.
[t,~,~,xi_Idle] = EulerMaruyamaSolver(init,tf,dt,gamma,k,sigma);
plot(t,xi_Idle,'Color',[236.8950,176.9700,31.8750]/256,'LineWidth',2);

%Figure properties.
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$t$','interpreter','latex','FontSize',25);
ylabel('\boldmath$\xi$','interpreter','latex','FontSize',25);
title(['\boldmath$\Gamma=',num2str(gamma),', k=',num2str(k),', \sigma=',num2str(sigma),'$'],'interpreter','latex','FontSize',25);
xlim([0,tf]);
ylim([0,1.1]);