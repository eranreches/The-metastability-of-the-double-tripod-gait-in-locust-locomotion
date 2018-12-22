%{

@Copyrights Eran Reches, 2018

This script simulates N SDE realizations for various noises. The mean
plateau duration for each value of sigma is claculated using the
DecayTime routine with decay_th=0.9. Then those values are plotted against
the noise in semi-logarithmic scale, and also fitted to a line.

Note: The value of decay_th=0.9 is arbitrary and can affect the slope.

%}

init = [0;pi;0;pi;0;pi]; tf = 30; dt = 0.01; gamma = 1; k = 1; sigma = 1e-15; %SDE parameters.
N = 100; plot_enable = false; t_sep = 0; th = 0; %NGraphsPlotter parameters.
Nnoise = 14; %Numbers of noise values.
sigma = sigma*10.^(1:Nnoise)/10;
mu = zeros(1,Nnoise); %Initializing vector for mean plateu durations.
s  = zeros(1,Nnoise); %Initializing vector for std of plateu durations.
decay_th = 0.9; %Threshold for the end of the plateu.

for i = 1:Nnoise
    [t,xi_Tri_cell] = NGraphsPlotter(N,init,tf,dt,gamma,k,sigma(i),plot_enable,t_sep,th); %Solving N realizations.
    [temp1,temp2]   = DecayTime(t,xi_Tri_cell,decay_th); %Extracting mean and standard deviation.
    mu(i)           = temp1;
    s(i)            = temp2;
end
err=s/sqrt(N);
err=icdf('T',0.975,N)*err/2; %Using Student's t distribution with 95% convidence interval for unknown standard deviation.

%Fitting.
FIT = fittype('a*x+b');
FIT = fit(log(sigma)',mu',FIT);
FIT_fun = @(x) FIT.a*x+FIT.b;

%Plotting.
hold on
plot(sigma,FIT_fun(log(sigma)),'m','LineWidth',2);
errorbar(sigma,mu,err,'go','LineWidth',2);
set(gca,'xscale','log');

%Line slope.
disp(['slope=',num2str(FIT.a)]);

%Figure properties.
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$\sigma$','interpreter','latex','FontSize',25);
ylabel('\boldmath$\langle \tau \rangle$','interpreter','latex','FontSize',25);
title(['\boldmath$\Gamma=',num2str(gamma),', k=',num2str(k),'$'],'interpreter','latex','FontSize',25);
xlim([sigma(1)/100,sigma(end)*100]);