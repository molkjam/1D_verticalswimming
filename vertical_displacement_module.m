%vertical_displacement_module

for i =1:N %particle loop

%Random number between -1 and 1
%normal distribution
R(i) = -1 + 2.*rand;

 %swimspeed
w(i) = swimspeed;


%find the location of the particle
%local index of z nearest to the depth of the particle
zidx(i) = knnsearch(z',Z(i));

%find the diffusivity gradient at the particles location
Ki(i) = Kprime(zidx(i),ts);

%offset the particles location at a distance of 1/2K'dt
Z_offset(i) = Z(i) + ((Ki(i)/2)*dt);
%find the depth index for the offset particle
offset_zidx(i) = knnsearch(z', Z_offset(i));

swimming_capacity_module

%GENERATE A MATRIX OF THE SWIMMING SPEEDS OF EACH PARTICLE DURING EACH TIMESTEP
swim_matrix(i,step,rep) = w(i) * L(i);

Kstep(i,step) = K(zidx(i),ts);

KRWstep(i,step) = Kstep(i,step) * R(i);

%calculate particle vertical displacement
%using the equation Z(n+1) = Zn + K'(Zn)dt + (R((2K(Zn +
%1/2K'dt)dt)/r)^0.5) + (w*l)dt (Visser,1997)

if strcmp(behaviour,'active')  

Z_new(i) = Z(i)  + (Ki(i)*dt) + R(i) *((2*K(offset_zidx(i),ts)*dt)/(1/3))^0.5 +((w(i)*L(i))*dt);

%elseif strcmp(behaviour,'down')

%Z_new(i) = Z(i)  + (Ki(i)*dt) + R(i) *((2*K(offset_zidx(i),ts)*dt)/(1/3))^0.5 -(sinkrate*dt);

%elseif strcmp(behaviour,'tst')
 %       if abs(tide_5m(1,ts)) > 0.05
  %              if tide_5m(1,ts) > 0
   %                     Z_new(i) = Z(i)  + (Ki(i)*dt) + R(i) *((2*K(offset_zidx(i),ts)*dt)/(1/3))^0.5 +((w(i)*L(i))*dt);
    %            elseif tide_5m(1,ts) < 0
     %                   Z_new(i) = Z(i)  + (Ki(i)*dt) + R(i) *((2*K(offset_zidx(i),ts)*dt)/(1/3))^0.5 - (sinkrate*dt);
      %          end
       % elseif abs(tide_5m(1,ts)) <= 0.05
        %                Z_new(i) = Z(i)  + (Ki(i)*dt) + R(i) *((2*K(offset_zidx(i),ts)*dt)/(1/3))^0.5 - (sinkrate*dt);
        %end

elseif strcmp(behaviour,'passive')
Z_new(i) = Z(i)  + (Ki(i)*dt) + R(i) *((2*K(offset_zidx(i),ts)*dt)/(1/3))^0.5;
end
boundary_conditions_module

% New particle Location
Z(i) = Z_new(i);

end

