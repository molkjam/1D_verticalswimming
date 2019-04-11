%LES smoothing and interpolating module

depth_interval = 0.01; %depth interval in metres
 H = 24; %water depth (m)

 interp_method = 'spline'; %interpolation method
 Prt = 0.85; %Turbulent Prandtl number
 LES_scale = 1; %to explore different magnitides of K
 
 %external timestep
 LES_ts = 2;

 load('Eddy_Vis.mat')
 [EV, ~, ~, ~, ~] =filloutliers(eddy_vis,interp_method,2);
 EVsmooth = smoothdata(EV,2);
 EVsmooth = smoothdata(EVsmooth,1);
 EV=EVsmooth;
 clear EVsmooth
 clear eddy_vis
 zq = 0:depth_interval:z(end);
 EV_interp = zeros(length(zq),length(time));

 for tidx = 1:length(time) %loops through each timestep
   y = EV(:,tidx) ; % selects the EV values for all depths for the timestep
   y_interp = interp1(z,y,zq,interp_method); %interpolates the EV values for the queried z points (zq)
   EV_interp(:,tidx) = y_interp; %populates the column relating to the timestep with the interpolated values
end

 EV = EV_interp;
 z = zq;

 clear y
 clear y_interp
 clear EV_interp
 clear  zq

 clear y
 clear y_interp
 clear EV_interp
 clear  zq


 %extend the time scale
for xx = 345:380
time(1,xx) = time(1,xx-1)+0.0333333333;
end

p = polyfit(time(:,1:344),tide_5m,4);
x1 = time(1,1):0.0333333333:time(end);
y1 = polyval(p,x1);

 
%attach extrapolated values to tide_5m
 tide_5m(:,345:380) = y1(:,345:380);
clear xx

%Cut dataset to water column height (H)
[~,hidx] = min(abs(z-H),[],2);
 zH = z(1:hidx);
 z = zH;
 clear zH
 EVH = EV(1:hidx,:);
 EV = EVH;
 clear EVH

%extend the EV dataset with blank values to fill

EV(:,344:380) = zeros;
%find the cumulative eddy viscosity to plot the tide
EVsum = sum(EV(:,1:380));

%reflect the tide between hws and ebb overlay anomoly values and extrapolate data
EV_reflect = fliplr(EV(:,194:286));
EV(:,288:380) = EV_reflect;

clear EV_reflect
clear extrap_method
clear EVsum


K = EV*Prt;
meanK = mean(K);

%extend the time dataset to start at 0 hours
time_new = 0:0.033333333:1.966666667;
%add the original time series to the new time series
time_new(1,61:440) = time;

%extend the tide dataset to match the new time dataset 
tide5m_new(1,61:440) = tide_5m;
tide5m_new(1,1:60) = NaN;

tide_reflect = fliplr(tide5m_new(1,140:278));
tide5m_new(1,1:139) = tide_reflect;

clear tide_reflect
time = time_new;
tide_5m = tide5m_new;
clear tide5m_new
clear time_new

%extend K inline with tide and time
K_new(:,61:440) = K;
K_new(:,1:60) = 0;
K_reflect = fliplr(K_new(:,244:319));
K_new(:,1:76) = K_reflect;
K_new(:,67:105) = smoothdata(K_new(:,67:105),2);
K = K_new;
meanK = mean(K);

%find points marking tidal states (Achieved by manually searching the dataset)
lws1_idx = 52;
midflood = 139;
hws_idx = 227;
midebb = 326;
lws_idx = 417;


%Calulate the diffusivity gradient between depth bins
 Kprime = zeros(size(K));
 Kprime(1,:) = (K(2,:)- K(1,:)) / ((z(2)) - (z(1)));
 Kprime(end,:) = (K(end,:) - K(end-1,:)) / (z(end) - z(end-1));
for kk = 2:length(z)-1
 Kprime(kk,:) = (K(kk+1,:) - K(kk-1,:)) / (z(kk+1) - z(kk-1));
end


%Calculate the second derivative of K with respect to z

Kdev = zeros(size(K));
Kdev(1,:) = ((K(2,:) - K(1,:)).^2) / ((z(2)^2) - (z(1)^2));
Kdev(end,:) = ((K(end,:) - K(end-1,:)).^2) / ((z(end)^2) - (z(end-1)^2));

for kk = 2:length(z)-1
        Kdev(kk,:) = ((K(kk+1,:) - K(kk-1,:)).^2) / ((z(kk+1)^2) - (z(kk-1)^2));
end

minKdev = min(Kdev(:));
min_ts = 1/minKdev;

clear interp_method
 clear Prt
 clear tidx
 clear EV
 clear kk

