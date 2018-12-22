%{

@Copyrights Eran Reches, 2018

The function gets a vector of values and returns a smoother version.

Inputs:

vec - vector of values.

Outputs:

res - result of the smoothing (averaging) operation.

%}

function res = smooth(vec)

res    = zeros(size(vec));
res(1) = vec(1);
res(2) = (vec(1)+vec(2)+vec(3))/3;

for i = 3:(length(vec)-2)
    res(i) = sum(vec(i-2:i+2))/5;
end

res(end-1) = (vec(end-2)+vec(end-2)+vec(end))/3;
res(end)   = vec(end);

end