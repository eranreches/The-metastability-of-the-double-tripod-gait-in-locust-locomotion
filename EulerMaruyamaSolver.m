%{

@Copyrights Eran Reches, 2018

Euler-Maruyama method for solving the SDE.
The oscillators' numbering is
1 4
2 5
3 6

Inputs:

init  - initial conditions in the form of a column vector [phi1_0;phi2_0;phi3_0;phi4_0;phi5_0;phi6_0].
tf    - final time.
dt    - time step.
gamma - internal coupling strength.
k     - feedback coupling strength.
sigma - standard deviation of noise.

Outputs:

t       - time (row vector).
phi     - a 6 by (no. of time steps) matrix of the individual phases.
xi_Tri  - double-tripod order parameter (row vector).
xi_Idl  - idle order parameter (row vector).

%}

function [t,phi,xi_Tri,xi_Idl] = EulerMaruyamaSolver(init,tf,dt,gamma,k,sigma)

f1 = 0.8; f2 = 0.7; b1 = 0.1; b2 = 1.2; l1 = 0.2; l2 = 0.2; l3 = -0.2; %Network parameters definition.
H = @(x) sin(x); %Coupling function.

%Network internal coupling.
internal_coupling = @(phi) gamma*[f1*H(phi(2)-phi(1))+l1*H(phi(4)-phi(1));
                                  b1*H(phi(1)-phi(2))+f2*H(phi(3)-phi(2))+l2*H(phi(5)-phi(2));
                                  b2*H(phi(2)-phi(3))+l3*H(phi(6)-phi(3));
                                  f1*H(phi(5)-phi(4))+l1*H(phi(1)-phi(4));
                                  b1*H(phi(4)-phi(5))+f2*H(phi(6)-phi(5))+l2*H(phi(2)-phi(5));
                                  b2*H(phi(5)-phi(6))+l3*H(phi(3)-phi(6))];

%Virtual nodes functions.
l_trio          = @(phi) (phi(1)+phi(3)+phi(5))/3;
r_trio          = @(phi) (phi(2)+phi(4)+phi(6))/3;

%Feedback.
feedback        = @(phi) k*[H(l_trio(phi)-phi(1));
                            H(r_trio(phi)-phi(2));
                            H(l_trio(phi)-phi(3));
                            H(r_trio(phi)-phi(4));
                            H(l_trio(phi)-phi(5));
                            H(r_trio(phi)-phi(6))];

%Differential.
if     k == 0 && sigma == 0
    dphi = @(phi) internal_coupling(phi)*dt;
elseif k == 0 && sigma ~= 0
    dphi = @(phi) internal_coupling(phi)*dt + sigma*randn(6,1)*sqrt(dt);
elseif k ~= 0 && sigma == 0
    dphi = @(phi) internal_coupling(phi)*dt + feedback(phi)*dt;
elseif k ~= 0 && sigma ~= 0
    dphi = @(phi) internal_coupling(phi)*dt + feedback(phi)*dt + sigma*randn(6,1)*sqrt(dt);
end

steps    = floor(tf/dt); %Number of loop steps.
phi      = zeros(6,steps+1); %Initializing solution matrix.
phi(:,1) = init; %Setting initial conditions.

for t = 1:steps; %Euler steps.
    phi(:,t+1) = phi(:,t) + dphi(phi(:,t));
end

ex      = @(phi1,phi2) exp(1i*(phi1-phi2)); %Imaginary exponent.

xi_Tri  = abs(ex(phi(1,:),0)...
             +ex(phi(2,:),pi)...
             +ex(phi(3,:),0)...
             +ex(phi(4,:),pi)...
             +ex(phi(5,:),0)...
             +ex(phi(6,:),pi))/6; %Double-tripod order parameter.
         
xi_Idl = abs(ex(phi(1,:),0)...
             +ex(phi(2,:),0)...
             +ex(phi(3,:),0)...
             +ex(phi(4,:),0)...
             +ex(phi(5,:),0)...
             +ex(phi(6,:),0))/6; %Idle order parameter.

t = 0:dt:tf; %Time slicing.

end