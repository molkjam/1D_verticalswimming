%Variables module


N = 25; %number of particles
dt =120; %internal timestep (s)
replicates =5;
swimspeed = 0.008; %default. cruising speed for 120um larvae (Huntley and Zhou, 2004)
behaviour  = 'active'; % tst, up, down or passive
%tst particles swim upward on flood todes in the scurrent speed is great than 0.05ms^1 and down otherwwise

time_swimming = 1;
 %time spent swimming (cruising and escaping) as a decimal percentage

time_escape = 0;
 % of total swimming time spent escaping as a decimal percentage

 if time_escape > 0;
     escspeed =0.03; %in ms-1
 end

%Kcrit = 1; %optional. see swimming performance module
%sinkrate = 0.0008; % sinking rate for mytilus larvae given by Sprung (1984) 

loop = 0;
figpath = 'pwd';
swimming_performance = 'con';
%options:
%'con': constant: lambda = 1
%'lamdba': lambda is a function of K
%'pass': passiveL lambda = 0

startpoint = 'ebb';
endpoint = 'lws';

if strcmp(startpoint,'lws')
	ts_start = lws1_idx;
elseif strcmp(startpoint,'flood')
	ts_start = midflood;
elseif strcmp (startpoint, 'hws')
	ts_start = hws_idx;
elseif strcmp(startpoint,'ebb')
	ts_start = midebb;
end

if strcmp(endpoint,'flood')
	ts_end = midflood;
elseif strcmp(endpoint,'hws')
	ts_end = hws_idx;
elseif strcmp(endpoint,'ebb')
	ts_end = midebb;
elseif strcmp(endpoint,'lws')
	ts_end = lws_idx;
end


show_particles =''; % 'on' displays a visualisation of particle movement in the water column
show_histogram = 'on'; % 'on' shows a bar chart comparing the modelled and oserved distribution profiles
mean_histogram = 'on'; % 'on' generates a bar chart showing the mean observed distribution profile and the mean modelled distribution profile over all replicate model runs (default 5)
boundary = 'reflective';

%nested timestep (number of internal timesteps in model timestep
nested_ts = (LES_ts*60) / dt;

%read in the observational percentage data
obs_data = xlsread("obs_data.xlsx");

%#########################################
%convert obs data to decimal
obsdata_decimal = obs_data/100;
% arcsin square root transform the obs data to anova
obs_transform = asin(sqrt(obsdata_decimal));
clear obsdata_decimal;
%##############################################

%calculate the mean percentage of particles in each depth bin from the replicates
mean_obs = mean(obs_data,2);

%calcuate the SD for each mean
sd_obs = std(obs_data,0,2);

%calculate the SE for each mean
obs_repcount = size (obs_data,2);
se_obs = sd_obs/sqrt(obs_repcount);
 
%ebb tide vertical distribution

if strcmp(endpoint,'flood')
hist_Z_percent_end = [mean_obs(3) mean_obs(2) mean_obs(1)];
standard_error_observed = [se_obs(3) se_obs(2) se_obs(1)];
elseif strcmp(endpoint,'hws')
hist_Z_percent_end = [mean_obs(7) mean_obs(6) mean_obs(5)];
standard_error_observed = [se_obs(7) se_obs(6) se_obs(5)];
elseif strcmp(endpoint,'ebb')
hist_Z_percent_end = [mean_obs(11) mean_obs(10) mean_obs(9)];
standard_error_observed = [se_obs(11) se_obs(10) se_obs(9)];
elseif strcmp(endpoint,'lws')
hist_Z_percent_end = [mean_obs(15) mean_obs(14) mean_obs(13)];
standard_error_observed = [se_obs(15) se_obs(14) se_obs(13)];
end

for i = 1:N
if i < hist_Z_percent_end(3)
Z_obs(i) = ((H/3)*2) + (H-((H/3)*2)).*rand; %random distribution of particles in top depth bin
elseif  i > hist_Z_percent_end(3) && i < (hist_Z_percent_end(3)+hist_Z_percent_end(2))
Z_obs(i) = (H/3) + (((H/3)*2)-(H/3)).*rand; %random distribution of particles in mid depth bin
elseif i > (hist_Z_percent_end(3)+hist_Z_percent_end(2)) && i <= N
Z_obs(i) = 0 + ((H/3)-0).*rand; %random distribution of particles in bottom depth bin
end
end %end particle loop

%binned data
numbins = 3; %number of bins in the histogram
binsize = H/numbins; % size of each depth bin in metres
edges= 0:H/numbins:H; %edges of the bins

%x position of particles (fixed - no horizontal advection)
x= 1 + (N-1)*rand(1,N);



%multiply K by lES scaler
K = K*LES_scale;

swimloop = 0;

%Mersenne twister Random number generator
twister = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(twister);

%Pre allocated arrays and comment strings
Z = zeros(1,N); %particle depths
w = zeros(1,N); %particle swimming speeds
R = zeros(1,N); % Random walk factor
L = zeros(1,N); %swimming ability of particles
Z_new = zeros(1,N); % new particle locations
zidx = zeros(1,N); %depth index of particle loop iteration
Z_offset=zeros(1,N); %offset depth
Ki=zeros(1,N); % Kprime (dt^2/d^2z)


%##########################################################
