%{

@Copyrights Eran Reches, 2018

This script produces a figure of trajectories in the gait-space.

%}

N = 100; %Number of trajectories.
p = 0;   %Initializing counter (counts the number of trajectories converging idling).
for i=1:N
    init = 2*pi*rand(6,1); %Random initial condition.
    p    = p+GaitSpacePlot(init);
end
disp(['Percentages of trajectories converging to idling: ',num2str(100*p/N),'%']);

%Plotting trajectories from pace and double-tripod.
Tri  = [0;pi;0;pi;0;pi];
Pace = [0;0;0;pi;pi;pi];
GaitSpacePlot(Tri);
GaitSpacePlot(Pace);
GaitSpacePlot(Tri);
GaitSpacePlot(Pace);

% Figure properties.
figure(1);
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$\xi_{\textrm{Idl}}$','interpreter','latex','FontSize',25);
ylabel('\boldmath$\xi_{\textrm{Tri}}$','interpreter','latex','FontSize',25);
zlabel('\boldmath$\xi_{\textrm{Pace}}$','interpreter','latex','FontSize',25);
xlim([0,1]);
ylim([0,1]);
zlim([0,1]);
set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
% set(gca,'XAxisLocation','origin');
% set(gca,'YAxisLocation','origin');
% az = 135;
% el = 45;
% view(az, el);

figure(2);
subplot(1,2,1);
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$\xi_{\textrm{Idl}}$','interpreter','latex','FontSize',25);
ylabel('\boldmath$\xi_{\textrm{Tri}}$','interpreter','latex','FontSize',25);
xlim([0,1]);
ylim([0,1]);
subplot(1,2,2);
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$\xi_{\textrm{Idl}}$','interpreter','latex','FontSize',25);
ylabel('\boldmath$\xi_{\textrm{Pace}}$','interpreter','latex','FontSize',25);
xlim([0,1]);
ylim([0,1]);