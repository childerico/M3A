function [SCALED] = mmap_scale(MMAP, M)
% Changes the mean inter-arrival time of an MMAP.
% INPUT
% - MMAP: MMAP to be scaled
% - M: new mean

C = length(MMAP)-2;
if length(M)==1
    
    MOLD = map_mean(MMAP);
    
    ratio = MOLD/M;
    
    SCALED = cell(1,2+C);
    SCALED{1} = MMAP{1} * ratio;
    SCALED{2} = MMAP{2} * ratio;
    
    for c = 1:C
        SCALED{2+c} = MMAP{2+c} * ratio;
    end
else
    options = optimset();
    options.Display = 'off';
    [x] = fminsearch(@(X) objfun(X,M,MMAP), ones(1,C), options);
    
    SCALED{1} = MMAP{1};
    SCALED{2} = [];
    for c = 1:C
        SCALED{2+c} = MMAP{2+c} * x(c);
    end
    SCALED = mmap_normalize(SCALED);
end
end

function f = objfun(x,M,MMAP)
f = 0;
C = length(MMAP)-2;
SCALED{1} = MMAP{1};
SCALED{2} = [];
for c = 1:C
    SCALED{2+c} = MMAP{2+c} * x(c);
end
SCALED = mmap_normalize(SCALED);
l = mmap_count_lambda(SCALED);
for c=1:C
    f= f + norm((1/M(c))-l(c));
end
end

