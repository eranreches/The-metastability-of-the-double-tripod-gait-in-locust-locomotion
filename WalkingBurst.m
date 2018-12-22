%{

@Copyrights Eran Reches, 2018

This script illustrates how the order parameter xi_Tri versus time behaves
for a walking locust. The walking bouts (whose number is denoted by N) are
seperated by periods of stable idling. The durations of the latters are
drawned from a power-law distribution.

%}

init = [0;pi;0;pi;0;pi]; tf = 10; dt = 0.01; gamma = 1; k = 1; sigma = 0.01; %SDE parameters.
N = 6; %Number of bursts.

%Parameters for the power-law probability distribution of the idling durations.
tmin        = 0.1;
alpha       = 1.5;
inverse_CDF = @(x) tmin*(1-x)^(1/(1-alpha));

xi_Tri = zeros(1,200); %Starting from idling.
t      = 200*dt;

for i = 1:N
    xi_Tri              = [xi_Tri,zeros(1,50),ones(1,50)]; %Tripod burst initiated.
    t                   = t+100*dt;
    [~,~,xi_Tri_temp,~] = EulerMaruyamaSolver(init,tf,dt,gamma,k,sigma); %Solving one realization.
    xi_Tri              = [xi_Tri,xi_Tri_temp];
    t                   = t+tf;
    temp                = ceil(inverse_CDF(rand)/dt); %Drawing idling duration from the above distribution.
    xi_Tri              = [xi_Tri,zeros(1,temp)];
    t                   = t+temp*dt;
end

N = length(xi_Tri); %Number of values.
t = linspace(0,t,N); %Time axis values.
plot(t,xi_Tri,'g','LineWidth',2);

%Figure properties.
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$t$','interpreter','latex','FontSize',25);
ylabel('\boldmath$\xi_{\textrm{Tri}}$','interpreter','latex','FontSize',25);
title(['\boldmath$\Gamma=',num2str(gamma),', k=',num2str(k),'$'],'interpreter','latex','FontSize',25);
xlim([0,t(end)]);
ylim([0,1.1]);