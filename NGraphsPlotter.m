%{

@Copyrights Eran Reches, 2018

This function performs N ralizations of the SDE
model and plots the order parameter versus time.

Inputs:

N           - number of realizations.
init        - initial conditions in the form of a column vector [phi1_0;phi2_0;phi3_0;phi4_0;phi5_0;phi6_0].
tf          - final time.
dt          - time step
gamma       - internal coupling strength.
k           - feedback coupling strength.
sigma       - standard deviation of noise.
plot_enable - boolean that enables\disables plotting.
t_sep       - time border between 'good' and 'bad' decays.
th          - threshold for coloration. Should satisfy 0<th<1.
              If th=0, then the threshold value is not plotted
              and coloration is done with th=0.5.

Outputs:

t            - time (row vector).
xi_Tri_cell  - cell structure containing xi_Tri for all the realizations.

%}

function [t,xi_Tri_cell] = NGraphsPlotter(N,init,tf,dt,gamma,k,sigma,plot_enable,t_sep,th)

xi_Tri_cell = cell(1,N); %Defining cell structure to hold the order parameter xi_Tri for each realization.

for i = 1:N %Performing N realizations.
    [t,~,xi_Tri,~] = EulerMaruyamaSolver(init,tf,dt,gamma,k,sigma); %Solving one realization.
    xi_Tri_cell{i} = xi_Tri; %Saving.
end

if plot_enable == false
    return
end

th_enable = true;
if th == 0
    th = 0.5;
    th_enable = false;
end

%This section is used to color the curves according to their behavior and
%decay times. 'Good' decays are green while 'bad' decays are red. In
%addition, the darker the color - the longer the decay time till th value.
%First, to seperate 'bad' decays from 'good' ones the code checks when the
%order parameter arives first to th% of its initial value. Then the index
%of the th% value is saved.

bad  = [];
good = [];
for i = 1:N
    if t(find(xi_Tri_cell{i}>th,1,'last')) > t_sep
        bad  = [bad,[i;find(xi_Tri_cell{i}>th,1,'last')]];
    else
        good = [good,[i;find(xi_Tri_cell{i}>th,1,'last')]];
    end
end

%Coloration functions.
c_min = 0.9; %Color scheme borders.
c_max = 0.3;

if ~isempty(bad)
    min1 = min([Inf,bad(2,:)]); %Minimum time index.
    max1 = max([0,bad(2,:)]); %Maximum time index.
    s1   = (c_max-c_min)/(max1-min1); %Slope.
    f1   = @(x) s1*(x-min1)+c_min; %Color scheme function.
end

if ~isempty(good)
    min2 = min([Inf,good(2,:)]);
    max2 = max([0,good(2,:)]);
    s2   = (c_max-c_min)/(max2-min2);
    f2   = @(x) s2*(x-min2)+c_min;
end

%Plotting.
hold on
for i = 1:size(bad,2)
    plot(t,xi_Tri_cell{bad(1,i)},'LineWidth',2,'Color',[f1(bad(2,i)),0,0]);
end

for i = 1:size(good,2)
    plot(t,xi_Tri_cell{good(1,i)},'LineWidth',2,'Color',[0,f2(good(2,i)),0]);
end

if th_enable
    plot([0,tf],[th,th],'--k','LineWidth',2);
end

%Figure properties.
ax            = gca;
ax.Box        = 'on';
ax.FontSize   = 15;
ax.FontWeight = 'bold';
ax.LineWidth  = 5;
xlabel('\boldmath$t$','interpreter','latex','FontSize',25);
ylabel('\boldmath$\xi_{\textrm{Tri}}$','interpreter','latex','FontSize',25);
title(['\boldmath$\Gamma=',num2str(gamma),', k=',num2str(k),'$'],'interpreter','latex','FontSize',25);
xlim([0,tf]);
ylim([0,1.1]);

end