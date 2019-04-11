%this module gives the option to suppress swimming behavour as a function of a vaiable (default is a critical level of K)

if strcmp(swimming_performance, 'con')

        L(i) = 1;

elseif strcmp(swimming_performance,'pass')

	L(i) = 0;

elseif strcmp(swimming_performance,'lambda')
	
	if K(zidx(i),ts) < Kcrit
	L(i) = 1;
	elseif K(zidx(i),ts)  >= Kcrit
	L(i) = 0;
	end
	

end
