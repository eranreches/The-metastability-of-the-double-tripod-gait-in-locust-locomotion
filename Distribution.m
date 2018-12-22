%{

@Copyrights Eran Reches, 2018

This function produce the histogram of walking times P(T).

Inputs:

k  - feedback coupling strength.
th - threshold for walking.

Outputs:

cent - bin centers.
val  - bin values.

Note: Choose the binning to get the best graph.

%}

function [cent,val] = Distribution(k,decay_th)

%Parameters.
N = 1000; init = [0;pi;0;pi;0;pi]; tf = 60; dt = 0.01; gamma = 1; sigma = 0.01; %SDE parameters.
plot_enable = false; t_sep = 0; th = 0; %NGraphsPlotter parameters.
[t,xi_Tri_cell] = NGraphsPlotter(N,init,tf,dt,gamma,k,sigma,plot_enable,t_sep,th); %N realizations.

t_sep = 20; %Time seperator for coloring.
T     = DecayTime(t,xi_Tri_cell,decay_th); %Calculation walking durations.
% edges = [0:0.5:10,11:1:40,41:2:60]; %Bins for k=0.
edges=[0:0.7:20,21:1:40,41:2:60]; %Bins for k=0.5.

figure(1);
h=histogram(T,edges,'Normalization','pdf');
figure(2);
val        = h.Values;   %Extracting values from histogram.
num        = h.NumBins;  %Extracting number of bins.
cent       = h.BinEdges; %Extracting bin edges.
cent       = (cent(1:num)+cent(2:(num+1)))/2; %Calculating bin centers from edges.
red        = find(cent>t_sep); %Indices for red graph.
green      = find(cent<t_sep); %Indices for greed graph.
red_cent   = cent(red);   %Red graph centers.
green_cent = cent(green); %Green graph centers.
red_val    = val(red);    %Red graph values.
green_val  = val(green);   %Green graph values.

%Plotting.
semilogy(red_cent,red_val,'r-','LineWidth',2);
hold on
semilogy(green_cent,green_val,'g-','LineWidth',2);

%Figure properties.
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$T$','interpreter','latex','FontSize',25);
ylabel('\boldmath$P(T)$','interpreter','latex','FontSize',25);
title(['\boldmath$\Gamma=',num2str(gamma),', k=',num2str(k),'$'],'interpreter','latex','FontSize',25);

end