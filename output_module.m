%output module - saves data into an array

data_array = cell(41,6);

if strcmp(startpoint,'flood')
data_array(1,1) = cellstr('HWS');
elseif strcmp(startpoint,'hws')
data_array(1,1) = cellstr('Ebb');
elseif strcmp(startpoint,'ebb')
data_array(1,1) = cellstr('LWS');
elseif strcmp(startpoint,'lws')
data_array(1,1) = cellstr('Flood');
end

 datalabels = ["MeanSurf", "MeanMid", "MeanBed", "SESurf", "SEMid", "SEBed"];
data_array(2,1) = cellstr(datalabels(1));
data_array(2,2) = cellstr(datalabels(2));
data_array(2,3) = cellstr(datalabels(3));
data_array(2,4) = cellstr(datalabels(4));
data_array(2,5) = cellstr(datalabels(5));
data_array(2,6) = cellstr(datalabels(6));


data_array(3,1) = num2cell(mean_top);
data_array(3,2) = num2cell(mean_middle);
data_array(3,3) = num2cell(mean_bottom);
data_array(3,4) = num2cell(se_top);
data_array(3,5) = num2cell(se_middle);
data_array(3,6) = num2cell(se_bottom);

anovalabels = ["2Way ANOVA", "1Way ANOVA: Surface", "1Way ANOVA: Middle"," 1Way ANOVA: Bed"];

data_array(5,1) = cellstr(anovalabels(1));
data_array(6:11,1:6) = tbl;

%data_array(13,1) = cellstr(anovalabels(2));
%data_array(14:17,1:6) = t_top;

%data_array(19,1) = cellstr(anovalabels(3));
%data_array(20:23,1:6) = t_mid;

%data_array(25,1) = cellstr(anovalabels(4));
%data_array(26:29,1:6) = t_bottom;

data_array(32,2) = cellstr('Modelled');
data_array(32,3) = cellstr('Observed');
data_array(32,4) = cellstr('Difference');

data_array(33,1) = cellstr('Surface (0-8m)');
data_array(34,1) = cellstr('Middle (8-16m)');
data_array(35,1) = cellstr('Bed (16-24m)');

mean_bar_cell = num2cell(mean_bar);
data_array(33:35,2:3) = mean_bar_cell;

data_array(37,1) = cellstr('Standard Error');
data_array(37,2) = cellstr('Modelled');
data_array(37,3) = cellstr('Observed');

data_array(38,1) = cellstr('Surface (0-8m)');
data_array(39,1) = cellstr('Middle (8-16m)');
data_array(40,1) = cellstr('Bed (16-24m)');

se_bar_cell = num2cell(se_bar);
data_array(38:40,2:3) = se_bar_cell;

