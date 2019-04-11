%runs the model

%load in hydrodynamic data
hydrodynamic_module

%load in variables
variables_module

%for modelrun = 1:5
%for swimspeed = 0.0021:0.0001:0.003;
swimloop = 0;
%for swimspeed = 0:0.0001:0.005
   % swimloop = swimloop + 1;
for modelrun = 1
for rep = 1:replicates

%~~~STARTING DISTRIBUTION OF PARTICLES BASED ON OBSERVATIONAL DATA ~~~~%

	if strcmp(startpoint,'flood')
		top = 43.61;
		middle = 31.72; 
		bottom = 24.67; 
	elseif strcmp(startpoint,'hws')
		top = 28.23;
		middle = 28.51; 
		bottom = 43.27;
elseif strcmp(startpoint,'ebb')
		top = 20.36;
		middle = 40.79;
		bottom = 38.85;
	elseif strcmp(startpoint,'lws')
		top = 27.86;
		middle = 29.88;
		bottom = 42.26;
	end


top_no = N/(100/top);
middle_no = N/(100/middle);
bottom_no = N/(100/bottom);

step = 0;
%~~~ RANDOMLY ASSIGN PARTICLE DEPTHS WITHIN EACH DEPTH BIN ~~~%

	for i = 1:N
		if i < top_no
			Z(i) = ((H/3)*2) + (H-((H/3)*2)).*rand; %random distribution of particles in top depth bin
		elseif  i > top_no && i < (top_no+middle_no)
			Z(i) = (H/3) + (((H/3)*2)-(H/3)).*rand; %random distribution of particles in mid depth bin
		elseif i > (top_no+middle_no) && i <= N
			Z(i) = 0 + ((H/3)-0).*rand; %random distribution of particles in bottom depth bin
		end
	end %end particle loop

%~~~VERTICAL DISPLACEMENT~~~%

		for ts = ts_start:ts_end
	    
	%counter
			timestep_count= ['Timestep counter: ',num2str(ts),' out of ',num2str(ts_end), ' Behaviour: ',behaviour,' ',startpoint, ' to ',endpoint, ' (Replicate ',num2str(rep),];
			disp(timestep_count)
            disp(modelrun)
            disp(swimspeed)
	
			for its = 1:nested_ts %internal timestep loop
	
				step = step + 1; %internal timestep counter
	
				vertical_displacement_module
	
				if strcmp (show_particles, 'on')
					figure (1)
					hold off
					scatter(x,Z,60,'k')
					set(gca, 'XLim', [0 N], 'YLim', [0 24])
					title('1D water column')
					xlabel('')
					set(gca,'xtick',[])
					ylabel('Depth (m)')
					hold on
					pause (0.0005)
				end
	
			end %end internal timestep loop
		end % end external timestep loop


	
	%Number of particles in each depth bin
	hist_Z = histc(Z,edges);
	 
	%histogram as a percentage of population
	hist_Z_percent = 100 ./ (N./hist_Z);
	modelled__distribution = hist_Z_percent;
	observed__distribution = hist_Z_percent_end;
	
	%store distribution results for replicate in a matrix
	distribution_rep(rep,:) = hist_Z_percent;

end % end replicates loop

anova_module
averages_module

%output_module
disp completed

%end


%for i = 1:5
 % xlswrite([num2str(swimspeed),'.xls'],distro_rep(:,:,i),i)
end
%xlswrite('p-values',swimspeed,1,['A' num2str(swimloop)])
%range = ['B', num2str(swimloop), ':', 'F', num2str(swimloop)];
%xlswrite('p-values',p_transform,1,range)
%end