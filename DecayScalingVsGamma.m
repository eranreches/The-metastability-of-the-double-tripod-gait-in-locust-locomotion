%{

@Copyrights Eran Reches, 2018

This script simulates N SDE realizations for various noises. The mean
plateau duration for each value of gamma is claculated using the
DecayTime routine with decay_th=0.9. Then those values are plotted
against the noise in loglog scale, and also fitted to a line.

Note: The value of decay_th=0.9 is arbitrary and can affect the slope.

%}

init = [0;pi;0;pi;0;pi]; tf = 50; dt = 0.01; gamma = 0.1; k = 1; sigma = 0.01; %SDE parameters.
N = 100; plot_enable = false; t_sep = 0; th = 0; %NGraphsPlotter parameters.
Ngamma = 14; %Numbers of gamma values.
gamma = gamma*(1.2).^(1:Ngamma)/1.2;
mu = zeros(1,Ngamma); %Initializing vector for mean plateu durations.
s  = zeros(1,Ngamma); %Initializing vector for std of plateu durations.
decay_th = 0.9; %Threshold for the end of the plateu.

for i = 1:Ngamma
    [t,xi_Tri_cell] = NGraphsPlotter(N,init,tf,dt,gamma(i),k,sigma,plot_enable,t_sep,th);
    [~,temp1,temp2] = DecayTime(t,xi_Tri_cell,decay_th);
    mu(i) = temp1;
    s(i)  = temp2;
end
err=s/sqrt(N);
err=icdf('T',0.975,N)*err/2; %Using Student's t distribution with 95% convidence interval for unknown standard deviation.

%Fitting.
FIT = fittype('a*x+b');
FIT = fit(log(gamma)',log(mu)',FIT);
FIT_fun = @(x) FIT.a*x+FIT.b;

%Plotting.
hold on
plot(gamma,exp(FIT_fun(log(gamma))),'m','LineWidth',2);
errorbar(gamma,mu,err,'go','LineWidth',2);
set(gca,'xscale','log');
set(gca,'yscale','log');

%Line slope.
disp(['slope=',num2str(FIT.a)]);

%Figure properties.
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$\Gamma$','interpreter','latex','FontSize',25);
ylabel('\boldmath$\langle \tau \rangle$','interpreter','latex','FontSize',25);
title(['\boldmath$k=',num2str(k),', \sigma=',num2str(sigma),'$'],'interpreter','latex','FontSize',25);
xlim([gamma(1)/1.2,gamma(end)*1.2]);
ylim([10^(0.3),10^(1.6)]);