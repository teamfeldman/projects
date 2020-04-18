% Driver function for the CI calculation for buffons needle simulation.

function [] = driver()
count = 0; in_interval = 0;
    
    for (i = 1:100);
        in_interval = buffon();
        if (in_interval == 1);
            count = count + 1;
        end
    end
    
    disp(count);
end