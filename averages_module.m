%Averages module

%calculates the mean proportion of articles in each depth bin from all replicate model runs


mean_top = mean(distribution_rep(:,3))
se_top = std(distribution_rep(:,3))/(sqrt(replicates))
mean_middle = mean(distribution_rep(:,2))
se_middle = std(distribution_rep(:,2))/(sqrt(replicates))
mean_bottom = mean(distribution_rep(:,1))
se_bottom = std(distribution_rep(:,1))/(sqrt(replicates))

if strcmp(mean_histogram,'on')
mean_bar = [mean_top hist_Z_percent_end(3); mean_middle hist_Z_percent_end(2); mean_bottom hist_Z_percent_end(1)];

se_bar = [se_top standard_error_observed(3); se_middle standard_error_observed(2); se_bottom standard_error_observed(1)];

figure (1)
hold on
bar(mean_bar);
title('Modelled vs observed vertical distribution')
ylim([0 100]);
ylabel('Percent of total population')
xticks([1 2 3])
xticklabels({'Top (0.8m)','Middle (8-16m)','Bottom (16-24m)'});

ngroups = size(mean_bar,1);
nbars = size(mean_bar,2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
x = (1:ngroups) - (groupwidth/2) + (2*i-1) * (groupwidth / (2*nbars));
  errorbar(x, mean_bar(:,i), se_bar(:,i), 'k', 'linestyle', 'none');
end
legend('labels',({'Modelled','Observed'}))
end



