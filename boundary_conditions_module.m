%boundary conditions
%particles stick to the boundaries if they are rigid

if strcmp(boundary,'rigid')
if Z_new(i) >H
Z_new(i) = H -0.0001;
elseif Z_new(i) < 0
Z_new(i) = 0.0001;
end

%particles are reflected back into the water column at a distance equal to that of which they traversed the boundary
elseif strcmp(boundary,'reflective')
if Z_new(i) >H
Z_new(i) = H-(Z_new(i) - H);
elseif Z_new(i) < 0
Z_new(i) = abs(Z_new(i));
end
end 
