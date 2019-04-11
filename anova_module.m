% 2 way anova to compare modelled and observed data


%organise the distribution replicates so that they are in the same format as the observational data (rows = TMB; columns = reps)

%transpose the matrix
drep = distribution_rep';
%flip the matrix so is reads TMB not BMT
dflip = flipud(drep);
%remove the top line of 0s
distro_rep(:,:,modelrun) = dflip(2:end,:);

%#########################################################
%convert the data to decimal percentages
distro_decimal = distro_rep/100;
% arcsin square root tranform the data
distro_transform = asin(sqrt(distro_decimal));

clear dep;
clear dflip;
clear distro_decimal;

%original ANOVA (raw percentages)
%create a matrix with 2 columns (modelled and observed) and (reps*depthbins) rows

%populate the observed column

if strcmp(endpoint,'flood')
        %top depth bin
        anova_data(1:5,2) = obs_data(1,:);
        %mid depth bin
        anova_data(6:10,2) = obs_data(2,:);
        %bottom depth bin
        anova_data(11:15,2) = obs_data(3,:);
elseif strcmp(endpoint,'hws')
	%top depth bin	
	anova_data(1:5,2) = obs_data(5,:);
	%mid depth bin
	anova_data(6:10,2) = obs_data(6,:);
	%bottom depth bin
	anova_data(11:15,2) = obs_data(7,:);

elseif strcmp(endpoint,'ebb')
	%top depth bin  
	anova_data(1:5,2) = obs_data(9,:);
	%mid depth bin
	anova_data(6:10,2) = obs_data(10,:);
	%bottom depth bin
	anova_data(11:15,2) = obs_data(11,:);

elseif strcmp(endpoint,'lws')
	%top depth bin  
	anova_data(1:5,2) = obs_data(13,:);
	%mid depth bin
	anova_data(6:10,2) = obs_data(14,:);
	%bottom depth bin
	anova_data(11:15,2) = obs_data(15,:);
end

%populate the modelled column
anova_data(1:5,1) = distro_rep(1,:,modelrun);
anova_data(6:10,1) = distro_rep(2,:,modelrun);
anova_data(11:15,1) = distro_rep(3,:,modelrun);

anova_data;


anova_labels = ['modelled';'modelled';'modelled';'modelled';'modelled';'observed';'observed';'observed';'observed';'observed'];

[p,tbl,stats] = anova2(anova_data,5,'off');
%top_data(1:5,1) = anova_data(1:5,1);
%top_data(6:10,1) = anova_data(1:5,2);

%mid_data(1:5,1) = anova_data(6:10,1);
%mid_data(6:10,1) = anova_data(6:10,2);

%bottom_data(1:5,1) = anova_data(11:15,1);
%bottom_data(6:10,1) = anova_data(11:15,2);


p_interaction = p(3)


% ANOVA - transformed data

%create a matrix with 2 columns (modelled and observed) and (reps*depthbins) rows

%populate the observed column

if strcmp(endpoint,'flood')
        %top depth bin
        anova_data(1:5,2) = obs_transform(1,:);
        %mid depth bin
        anova_data(6:10,2) = obs_transform(2,:);
        %bottom depth bin
        anova_data(11:15,2) = obs_transform(3,:);
elseif strcmp(endpoint,'hws')
	%top depth bin	
	anova_data(1:5,2) = obs_transform(5,:);
	%mid depth bin
	anova_data(6:10,2) = obs_transform(6,:);
	%bottom depth bin
	anova_data(11:15,2) = obs_transform(7,:);

elseif strcmp(endpoint,'ebb')
	%top depth bin  
	anova_data(1:5,2) = obs_transform(9,:);
	%mid depth bin
	anova_data(6:10,2) = obs_transform(10,:);
	%bottom depth bin
	anova_data(11:15,2) = obs_transform(11,:);

elseif strcmp(endpoint,'lws')
	%top depth bin  
	anova_data(1:5,2) = obs_transform(13,:);
	%mid depth bin
	anova_data(6:10,2) = obs_transform(14,:);
	%bottom depth bin
	anova_data(11:15,2) = obs_transform(15,:);
end

%populate the modelled column
anova_data(1:5,1) = distro_transform(1,:,modelrun);
anova_data(6:10,1) = distro_transform(2,:,modelrun);
anova_data(11:15,1) = distro_transform(3,:,modelrun);

anova_data;


anova_labels = ['modelled';'modelled';'modelled';'modelled';'modelled';'observed';'observed';'observed';'observed';'observed'];

[p,tbl,stats] = anova2(anova_data,5,'off');
%top_data(1:5,1) = anova_data(1:5,1);
%top_data(6:10,1) = anova_data(1:5,2);

%mid_data(1:5,1) = anova_data(6:10,1);
%mid_data(6:10,1) = anova_data(6:10,2);

%bottom_data(1:5,1) = anova_data(11:15,1);
%bottom_data(6:10,1) = anova_data(11:15,2);


p_transform(modelrun) = p(3)




