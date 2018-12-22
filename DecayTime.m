%{

@Copyrights Eran Reches, 2018

This function calculates the decay time of the order parameter.
The decay times, their mean value and their standard deviation are reaturned.

Inputs:

t           - time vector.
xi_Tri_cell - cell structure of order parameters.
th          - threshold for time measurement.

Outputs:

T - vector of decay times for each of the realization.
mu - mean of the plateau time duration.
s  - standard deviation of the plateau time duration.

%}

function [T,mu,s] = DecayTime(t,xi_Tri_cell,th)

T  = []; %Initializing vector for time values.

for i = 1:length(xi_Tri_cell)
    T = [T,t(find(xi_Tri_cell{i}>th,1,'last'))]; %Saving result.
end

mu = mean(T); %Mean value.
s  = std(T); %Standard deviation.

end